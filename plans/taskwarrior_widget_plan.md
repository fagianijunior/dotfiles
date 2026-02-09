# Plano de Implementação: Widget Taskwarrior Interativo

## 1. Arquitetura Proposta

O projeto será dividido em três camadas para melhor manutenibilidade e separação de responsabilidades:

1.  **Fonte de Dados (Taskwarrior CLI):** `task export`
2.  **Backend (Python):** Lógica, parsing de JSON, estruturação hierárquica (Projetos > Tarefas > Subtarefas) e execução de comandos de ação (`task start`, `task done`).
3.  **Frontend (QML):** Exibição da lista de projetos, contagem de tarefas e o popup flutuante interativo.

## 2. Tarefas e Estrutura de Implementação

A implementação será focada em dois novos arquivos principais: um script Python para o backend e um componente QML para a interface.

### Backend (Python)

*   **Responsabilidade:** Manipular dados e executar comandos.
*   **Nome Sugerido:** `home/quickshell/config/taskwarrior/task_data_model.py`

### Frontend (QML)

*   **Responsabilidade:** Apresentação da UI e conexão com o backend Python.
*   **Nome Sugerido:** `home/quickshell/config/taskwarrior/TaskProjectPopup.qml` (para o popup flutuante). O `TaskwarriorWidget.qml` existente será modificado para carregar o modelo Python e exibir o sumário.

## 3. Fluxo de Ações (Mermaid)

```mermaid
sequenceDiagram
    participant Q as QML (TaskwarriorWidget)
    participant P as Python (task_data_model.py)
    participant T as Taskwarrior CLI

    Q->>P: 1. get_project_summary()
    P->>T: 2. task project.isnot:"" status:pending export
    T-->>P: 3. JSON de Tarefas Pendentes
    P->>P: 4. Parse JSON e Contar Tarefas por Projeto
    P-->>Q: 5. Retornar: [{projeto, count, uuid_projeto}, ...]
    
    Q->>Q: 6. Renderizar lista de projetos na barra
    Q->>Q: 7. Clique no projeto (Abre Popup)
    
    Q->>P: 8. get_tasks_for_project(projeto_uuid)
    P->>P: 9. Estruturar Tarefas/Subtarefas Hierarquicamente
    P-->>Q: 10. Retornar Modelo Hierárquico
    
    Q->>Q: 11. Renderizar Popup com Tarefas e Botões
    Q->>P: 12. perform_action(id_tarefa, acao)
    P->>T: 13. task <id_tarefa> <acao>
    T-->>P: 14. Resultado da Ação
    P-->>Q: 15. Sucesso / Recarregar (Goto 1)