#!/usr/bin/env python
import json
import subprocess
from collections import defaultdict

# Filtro para buscar todas as tarefas ativas (não concluídas nem deletadas)
TASK_FILTER_ARGS = ['status.not:completed', 'status.not:deleted']

def execute_task_command(args):
    """Executa um comando Taskwarrior e retorna a saída bruta."""
    try:
        # O filtro e o comando 'export' são passados como uma lista de argumentos
        command = ['task'] + TASK_FILTER_ARGS + args
        result = subprocess.run(
            command,
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        error_info = {"error": str(e), "stdout": e.stdout, "stderr": e.stderr}
        return json.dumps({"projectsSummary": [], "error": error_info})
    except FileNotFoundError as e:
        error_info = {"error": f"Comando 'task' não encontrado: {e}"}
        return json.dumps({"projectsSummary": [], "error": error_info})

def get_project_summary_json():
    """
    Retorna um JSON contendo o sumário de projetos, incluindo uma categoria "Outros"
    para tarefas sem projeto.
    """
    # O comando agora é apenas 'export', pois o filtro é adicionado em execute_task_command
    raw_json = execute_task_command(['export'])
    if not raw_json:
        return json.dumps({"projectsSummary": [], "error": "Comando task retornou vazio."})

    try:
        # Primeiro, parseamos para verificar se é um objeto de erro
        data = json.loads(raw_json)
        if "error" in data:
            return raw_json # Repassa o JSON de erro
        tasks = data
    except json.JSONDecodeError:
        return json.dumps({"projectsSummary": [], "error": "Falha ao decodificar JSON do Taskwarrior."})

    # Agrupa tarefas por projeto, usando "Outros" como padrão
    projects_data = defaultdict(list)
    for task in tasks:
        project_name = task.get('project')
        if project_name:
            projects_data[project_name].append(task)
        else:
            projects_data['Outros'].append(task)

    # Prepara a saída
    output_list = []
    # Garante que "Outros" apareça por último, se existir
    other_tasks = projects_data.pop('Outros', None)

    # Adiciona projetos ordenados
    for name in sorted(projects_data.keys()):
        task_list = projects_data[name]
        output_list.append({
            'project': name,
            'count': len(task_list),
            'tasks': task_list
        })
    
    # Adiciona "Outros" no final
    if other_tasks:
        output_list.append({
            'project': 'Outros',
            'count': len(other_tasks),
            'tasks': other_tasks
        })
        
    return json.dumps({"projectsSummary": output_list})

if __name__ == '__main__':
    # A saída principal do script é o JSON do sumário
    print(get_project_summary_json())
