#!/usr/bin/env python3
"""
Script para obter tarefas do Taskwarrior para o Quickshell
"""

import json
import subprocess
import sys
from datetime import datetime, timezone

def get_tasks(limit=5):
    """Obtém tarefas pendentes do Taskwarrior"""
    try:
        # Executa o comando task export
        result = subprocess.run(
            ['task', 'export', 'status:pending', f'limit:{limit}'],
            capture_output=True,
            text=True,
            timeout=10
        )
        
        if result.returncode != 0:
            return {"error": f"Task command failed: {result.stderr}"}
        
        if not result.stdout.strip():
            return []
        
        # Parse JSON
        tasks = json.loads(result.stdout)
        
        # Processa e formata as tarefas
        formatted_tasks = []
        for task in tasks:
            formatted_task = {
                "id": task.get("id"),
                "uuid": task.get("uuid"),
                "description": task.get("description", "No description"),
                "project": task.get("project"),
                "priority": task.get("priority"),
                "status": task.get("status"),
                "urgency": task.get("urgency", 0),
                "tags": task.get("tags", []),
                "due": task.get("due"),
                "entry": task.get("entry"),
                "modified": task.get("modified")
            }
            
            # Formata data de vencimento se existir
            if formatted_task["due"]:
                try:
                    due_date = datetime.fromisoformat(formatted_task["due"].replace('Z', '+00:00'))
                    formatted_task["due_formatted"] = due_date.strftime("%Y-%m-%d")
                    formatted_task["is_overdue"] = due_date < datetime.now(timezone.utc)
                except:
                    formatted_task["due_formatted"] = formatted_task["due"]
                    formatted_task["is_overdue"] = False
            
            formatted_tasks.append(formatted_task)
        
        # Ordena por urgência (maior primeiro)
        formatted_tasks.sort(key=lambda x: x.get("urgency", 0), reverse=True)
        
        return formatted_tasks
        
    except subprocess.TimeoutExpired:
        return {"error": "Task command timed out"}
    except json.JSONDecodeError as e:
        return {"error": f"Failed to parse task output: {e}"}
    except FileNotFoundError:
        return {"error": "Task command not found. Is Taskwarrior installed?"}
    except Exception as e:
        return {"error": f"Unexpected error: {e}"}

def get_task_summary():
    """Obtém resumo das tarefas"""
    try:
        # Conta tarefas por status
        result = subprocess.run(
            ['task', 'count', 'status:pending'],
            capture_output=True,
            text=True,
            timeout=5
        )
        
        pending_count = int(result.stdout.strip()) if result.returncode == 0 else 0
        
        # Conta tarefas com alta prioridade
        result = subprocess.run(
            ['task', 'count', 'status:pending', 'priority:H'],
            capture_output=True,
            text=True,
            timeout=5
        )
        
        high_priority_count = int(result.stdout.strip()) if result.returncode == 0 else 0
        
        # Conta tarefas vencidas
        result = subprocess.run(
            ['task', 'count', 'status:pending', 'due.before:now'],
            capture_output=True,
            text=True,
            timeout=5
        )
        
        overdue_count = int(result.stdout.strip()) if result.returncode == 0 else 0
        
        return {
            "pending": pending_count,
            "high_priority": high_priority_count,
            "overdue": overdue_count
        }
        
    except Exception as e:
        return {"error": f"Failed to get task summary: {e}"}

if __name__ == "__main__":
    # Verifica argumentos
    limit = 5
    if len(sys.argv) > 1:
        try:
            limit = int(sys.argv[1])
        except ValueError:
            pass
    
    # Obtém tarefas
    tasks = get_tasks(limit)
    
    # Adiciona resumo se não houver erro
    if not isinstance(tasks, dict) or "error" not in tasks:
        summary = get_task_summary()
        output = {
            "tasks": tasks,
            "summary": summary
        }
    else:
        output = tasks
    
    # Imprime JSON
    print(json.dumps(output, indent=2, ensure_ascii=False))