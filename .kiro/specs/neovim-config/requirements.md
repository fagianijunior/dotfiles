# Requirements Document

## Introduction

Este documento especifica os requisitos para uma configuração completa do Neovim integrada ao NixOS, com foco em produtividade para desenvolvimento, usando o tema Catppuccin Macchiato e um conjunto curado de plugins essenciais.

## Glossary

- **Neovim**: Editor de texto modal baseado em Vim
- **Plugin Manager**: Sistema para gerenciar plugins do Neovim (gerenciamento nativo do Nix via home-manager)
- **LSP (Language Server Protocol)**: Protocolo para fornecer recursos de IDE (autocompletar, diagnósticos, etc.)
- **Fuzzy Finder**: Ferramenta de busca difusa para arquivos e conteúdo
- **Treesitter**: Parser incremental para syntax highlighting avançado
- **Catppuccin Macchiato**: Tema de cores específico da paleta Catppuccin
- **NixOS Configuration**: Configuração declarativa do sistema usando Nix
- **Completion Engine**: Motor de autocompletar que integra múltiplas fontes

## Requirements

### Requirement 1

**User Story:** Como desenvolvedor, eu quero uma configuração do Neovim integrada ao NixOS, para que minha configuração seja declarativa e reproduzível.

#### Acceptance Criteria

1. WHEN the NixOS configuration is built THEN the system SHALL install Neovim with todos os plugins especificados via Nix
2. WHEN the user inicia o Neovim THEN the system SHALL carregar a configuração Lua automaticamente
3. WHEN the configuration files são modificados THEN the system SHALL permitir rebuild sem conflitos com o gerenciamento de pacotes do Nix
4. WHERE NixOS home-manager é usado THEN the system SHALL integrar a configuração do Neovim no perfil do usuário
5. THE system SHALL gerenciar plugins através do Nix ao invés de plugin managers dinâmicos como lazy.nvim

### Requirement 2

**User Story:** Como desenvolvedor, eu quero fuzzy finding com Telescope, para que eu possa navegar rapidamente entre arquivos e buscar conteúdo.

#### Acceptance Criteria

1. WHEN the user pressiona um atalho de busca THEN the system SHALL abrir o Telescope com a interface de busca apropriada
2. WHEN the user digita caracteres no Telescope THEN the system SHALL filtrar resultados em tempo real usando fuzzy matching
3. WHEN the user seleciona um resultado THEN the system SHALL abrir o arquivo ou executar a ação correspondente
4. THE Neovim SHALL fornecer atalhos para buscar arquivos, grep em conteúdo, buffers abertos e comandos

### Requirement 3

**User Story:** Como desenvolvedor, eu quero LSP configurado com nvim-lspconfig, para que eu tenha recursos de IDE como autocompletar e diagnósticos.

#### Acceptance Criteria

1. WHEN a file de uma linguagem suportada é aberta THEN the system SHALL iniciar o language server apropriado automaticamente
2. WHEN o LSP está ativo THEN the system SHALL exibir diagnósticos inline e na lista de diagnósticos
3. WHEN the user invoca ações LSP THEN the system SHALL fornecer go-to-definition, hover, rename e code actions
4. WHEN múltiplos language servers estão disponíveis THEN the system SHALL configurar cada um com suas capacidades específicas

### Requirement 4

**User Story:** Como desenvolvedor, eu quero autocompletar inteligente com nvim-cmp, para que eu possa escrever código mais rapidamente.

#### Acceptance Criteria

1. WHEN the user digita código THEN the system SHALL exibir sugestões de autocompletar automaticamente
2. WHEN múltiplas fontes de completion estão disponíveis THEN the system SHALL integrar LSP, snippets, buffer e path
3. WHEN the user navega pelas sugestões THEN the system SHALL exibir documentação e informações adicionais
4. WHEN the user seleciona uma sugestão THEN the system SHALL inserir o texto e expandir snippets se aplicável

### Requirement 5

**User Story:** Como desenvolvedor, eu quero snippets com LuaSnip, para que eu possa inserir templates de código rapidamente.

#### Acceptance Criteria

1. WHEN the user digita um trigger de snippet THEN the system SHALL oferecer o snippet no menu de completion
2. WHEN um snippet é expandido THEN the system SHALL posicionar o cursor no primeiro placeholder
3. WHEN the user está em um snippet THEN the system SHALL permitir navegação entre placeholders com atalhos
4. THE Neovim SHALL carregar snippets padrão para linguagens comuns

### Requirement 6

**User Story:** Como desenvolvedor, eu quero syntax highlighting avançado com Treesitter, para que eu tenha melhor visualização do código.

#### Acceptance Criteria

1. WHEN a file é aberta THEN the system SHALL aplicar syntax highlighting baseado em Treesitter
2. WHEN o código é editado THEN the system SHALL atualizar o highlighting incrementalmente
3. THE Neovim SHALL instalar parsers para linguagens comuns automaticamente
4. WHEN Treesitter está ativo THEN the system SHALL fornecer text objects e movimentação baseada em sintaxe

### Requirement 7

**User Story:** Como desenvolvedor, eu quero integração Git com gitsigns, para que eu possa ver mudanças e gerenciar hunks diretamente no editor.

#### Acceptance Criteria

1. WHEN a file em um repositório Git é aberta THEN the system SHALL exibir indicadores de mudanças na coluna de sinais
2. WHEN the user navega pelo código THEN the system SHALL mostrar hunks adicionados, modificados e removidos
3. WHEN the user invoca ações Git THEN the system SHALL permitir stage, unstage e reset de hunks
4. THE Neovim SHALL exibir blame information inline quando solicitado

### Requirement 8

**User Story:** Como desenvolvedor, eu quero um file explorer com neo-tree, para que eu possa navegar na estrutura de diretórios visualmente.

#### Acceptance Criteria

1. WHEN the user abre o neo-tree THEN the system SHALL exibir a árvore de diretórios do projeto
2. WHEN the user navega na árvore THEN the system SHALL permitir abrir, criar, renomear e deletar arquivos
3. WHEN arquivos são modificados externamente THEN the system SHALL atualizar a árvore automaticamente
4. THE Neovim SHALL integrar ícones de arquivo e indicadores Git no neo-tree

### Requirement 9

**User Story:** Como desenvolvedor, eu quero descoberta de atalhos com which-key, para que eu possa aprender e lembrar keybindings facilmente.

#### Acceptance Criteria

1. WHEN the user pressiona uma tecla líder THEN the system SHALL exibir um popup com atalhos disponíveis após um delay
2. WHEN the user continua pressionando teclas THEN the system SHALL filtrar e mostrar sub-menus apropriados
3. THE Neovim SHALL organizar atalhos em grupos lógicos com descrições claras
4. WHEN the user completa uma sequência THEN the system SHALL executar o comando e fechar o popup

### Requirement 10

**User Story:** Como desenvolvedor, eu quero uma statusline informativa com lualine, para que eu veja informações importantes do editor.

#### Acceptance Criteria

1. WHEN o Neovim está aberto THEN the system SHALL exibir uma statusline na parte inferior
2. THE statusline SHALL mostrar modo atual, nome do arquivo, tipo de arquivo, posição do cursor e status Git
3. WHEN o LSP está ativo THEN the statusline SHALL exibir diagnósticos e status do servidor
4. THE statusline SHALL usar o tema Catppuccin Macchiato consistentemente

### Requirement 11

**User Story:** Como desenvolvedor, eu quero formatação automática com conform.nvim, para que meu código siga padrões de estilo automaticamente.

#### Acceptance Criteria

1. WHEN the user salva um arquivo THEN the system SHALL formatar o código automaticamente usando o formatter apropriado
2. WHEN múltiplos formatters estão disponíveis THEN the system SHALL usar o formatter configurado para aquele tipo de arquivo
3. WHEN the user invoca formatação manual THEN the system SHALL formatar o buffer atual imediatamente
4. THE Neovim SHALL configurar formatters comuns como prettier, black, stylua, etc.

### Requirement 12

**User Story:** Como desenvolvedor, eu quero um terminal integrado com toggleterm, para que eu possa executar comandos sem sair do editor.

#### Acceptance Criteria

1. WHEN the user ativa o toggleterm THEN the system SHALL abrir um terminal flutuante ou em split
2. WHEN the user alterna o terminal THEN the system SHALL mostrar ou esconder o terminal mantendo o estado
3. WHEN múltiplos terminais são criados THEN the system SHALL permitir navegação entre eles
4. THE Neovim SHALL permitir configurar terminais específicos para tarefas comuns

### Requirement 13

**User Story:** Como desenvolvedor, eu quero o tema Catppuccin Macchiato aplicado consistentemente, para que toda a interface tenha uma aparência coesa.

#### Acceptance Criteria

1. WHEN o Neovim inicia THEN the system SHALL aplicar o tema Catppuccin Macchiato a todos os componentes
2. THE theme SHALL ser aplicado ao editor, statusline, file explorer, Telescope e todos os plugins
3. WHEN plugins exibem UI THEN the system SHALL usar as cores do tema Catppuccin Macchiato
4. THE configuration SHALL garantir que cores customizadas de plugins respeitem a paleta do tema

### Requirement 14

**User Story:** Como desenvolvedor, eu quero keybindings intuitivos e consistentes, para que eu possa trabalhar eficientemente.

#### Acceptance Criteria

1. THE Neovim SHALL usar espaço como tecla líder para comandos customizados
2. WHEN the user pressiona atalhos THEN the system SHALL executar ações de forma previsível e consistente
3. THE configuration SHALL agrupar atalhos relacionados sob prefixos lógicos (ex: `<leader>f` para find, `<leader>g` para git)
4. WHEN há conflitos potenciais THEN the system SHALL priorizar atalhos mais usados e documentar exceções
