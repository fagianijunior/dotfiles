# Design Document - Neovim Configuration

## Overview

Esta configuração do Neovim será integrada ao NixOS através do home-manager, seguindo uma abordagem declarativa e reproduzível. A configuração será modular, com arquivos Lua organizados por funcionalidade, e todos os plugins gerenciados através do Nix. O tema Catppuccin Macchiato será aplicado consistentemente em todos os componentes.

## Architecture

### High-Level Structure

```
home/neovim/
├── default.nix          # Declaração Nix dos plugins e configuração
└── config/              # Configuração Lua
    ├── init.lua         # Entry point
    ├── options.lua      # Opções gerais do Neovim
    ├── keymaps.lua      # Keybindings globais
    └── plugins/         # Configuração individual de plugins
        ├── telescope.lua
        ├── lsp.lua
        ├── cmp.lua
        ├── treesitter.lua
        ├── gitsigns.lua
        ├── neo-tree.lua
        ├── which-key.lua
        ├── lualine.lua
        ├── conform.lua
        ├── toggleterm.lua
        └── catppuccin.lua
```

### Integration Flow

1. **Nix Layer**: `home/neovim/default.nix` declara plugins e aponta para configuração Lua
2. **Lua Entry Point**: `init.lua` carrega opções, keymaps e configurações de plugins
3. **Plugin Configuration**: Cada plugin tem seu arquivo de configuração isolado
4. **Theme Application**: Catppuccin é carregado primeiro e aplicado a todos os componentes

## Components and Interfaces

### 1. Nix Configuration Module (`default.nix`)

**Responsabilidades:**
- Declarar todos os plugins necessários
- Configurar extraPackages (LSPs, formatters, etc.)
- Apontar para a configuração Lua
- Integrar com o home-manager

**Interface:**
```nix
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    plugins = with pkgs.vimPlugins; [
      # Lista de plugins
    ];
    
    extraPackages = with pkgs; [
      # LSPs, formatters, etc.
    ];
    
    extraLuaConfig = ''
      ${builtins.readFile ./config/init.lua}
    '';
  };
}
```

### 2. Core Configuration (`init.lua`)

**Responsabilidades:**
- Carregar opções gerais
- Carregar keymaps globais
- Inicializar configurações de plugins na ordem correta

**Interface:**
```lua
-- Load core configuration
require('options')
require('keymaps')

-- Load plugin configurations
require('plugins.catppuccin')  -- Theme first
require('plugins.telescope')
require('plugins.lsp')
-- ... outros plugins
```

### 3. Options Module (`options.lua`)

**Responsabilidades:**
- Configurar opções do Neovim (number, relativenumber, etc.)
- Definir comportamento do editor
- Configurar UI básica

### 4. Keymaps Module (`keymaps.lua`)

**Responsabilidades:**
- Definir tecla líder (space)
- Configurar keymaps globais não relacionados a plugins
- Estabelecer convenções de prefixos

### 5. Plugin Configurations

Cada plugin terá seu módulo isolado com:
- Setup do plugin
- Keymaps específicos
- Configurações customizadas

## Data Models

### Plugin Configuration Structure

```lua
{
  -- Plugin setup
  setup = function()
    require('plugin-name').setup({
      -- configurações
    })
  end,
  
  -- Keymaps
  keymaps = {
    { mode, key, action, opts }
  },
  
  -- Theme integration
  theme = {
    -- Customizações de cor específicas
  }
}
```

### LSP Configuration Model

```lua
{
  server_name = {
    cmd = { "language-server-command" },
    filetypes = { "filetype1", "filetype2" },
    settings = {
      -- Server-specific settings
    },
    on_attach = function(client, bufnr)
      -- Keymaps e configurações por buffer
    end
  }
}
```

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*


### Configuration Verification Properties

Como esta é uma configuração declarativa (não um programa com lógica complexa), as propriedades focam em verificar que a configuração está corretamente estruturada e completa. Estas são verificações de exemplo que garantem que componentes essenciais estão presentes.

Property 1: Plugin installation verification
*For the* built Neovim configuration, all specified plugins should be present in the runtimepath
**Validates: Requirements 1.1**

Property 2: Lua configuration loading
*For the* Neovim initialization, core configuration variables (like mapleader) should be set correctly
**Validates: Requirements 1.2**

Property 3: Nix-managed plugins only
*For the* Neovim installation, dynamic plugin managers like lazy.nvim should not be present
**Validates: Requirements 1.5**

Property 4: Telescope keybindings completeness
*For the* Telescope configuration, keybindings for file finding, grep, buffers, and commands should all be defined
**Validates: Requirements 2.1, 2.4**

Property 5: LSP auto-attach
*For any* supported filetype, opening a file should trigger the corresponding LSP client
**Validates: Requirements 3.1**

Property 6: LSP action keybindings
*For the* LSP configuration, keybindings for go-to-definition, hover, rename, and code actions should be defined
**Validates: Requirements 3.3**

Property 7: Multiple LSP configuration
*For the* LSP setup, multiple language servers (nil, typescript, python, etc.) should be configured
**Validates: Requirements 3.4**

Property 8: Completion sources integration
*For the* nvim-cmp configuration, all sources (LSP, snippets, buffer, path) should be registered
**Validates: Requirements 4.2**

Property 9: Snippet navigation keybindings
*For the* LuaSnip configuration, keybindings for jumping forward and backward in snippets should be defined
**Validates: Requirements 5.3**

Property 10: Treesitter parser installation
*For the* Treesitter configuration, parsers for common languages should be listed for installation
**Validates: Requirements 6.3**

Property 11: Treesitter text objects
*For the* Treesitter configuration, text object modules should be enabled
**Validates: Requirements 6.4**

Property 12: Git action keybindings
*For the* gitsigns configuration, keybindings for stage, unstage, and reset hunks should be defined
**Validates: Requirements 7.3**

Property 13: Git blame keybinding
*For the* gitsigns configuration, a keybinding for showing blame information should be defined
**Validates: Requirements 7.4**

Property 14: Neo-tree toggle keybinding
*For the* neo-tree configuration, a keybinding to toggle the file explorer should be defined
**Validates: Requirements 8.1**

Property 15: Neo-tree Git integration
*For the* neo-tree configuration, Git status indicators and file icons should be enabled
**Validates: Requirements 8.4**

Property 16: Which-key group organization
*For the* which-key configuration, logical groups (find, git, lsp, etc.) should be defined with descriptions
**Validates: Requirements 9.3**

Property 17: Lualine component completeness
*For the* lualine configuration, sections should include mode, filename, filetype, cursor position, and Git status
**Validates: Requirements 10.2**

Property 18: Lualine LSP diagnostics
*For the* lualine configuration, LSP diagnostic components should be included
**Validates: Requirements 10.3**

Property 19: Lualine theme consistency
*For the* lualine configuration, the theme should be set to catppuccin
**Validates: Requirements 10.4**

Property 20: Conform format on save
*For the* conform configuration, format_on_save should be enabled
**Validates: Requirements 11.1**

Property 21: Conform formatter mapping
*For the* conform configuration, formatters should be mapped to specific filetypes
**Validates: Requirements 11.2**

Property 22: Conform manual format keybinding
*For the* conform configuration, a keybinding for manual formatting should be defined
**Validates: Requirements 11.3**

Property 23: Conform multiple formatters
*For the* conform configuration, multiple formatters (prettier, stylua, nixpkgs-fmt, etc.) should be configured
**Validates: Requirements 11.4**

Property 24: Toggleterm keybinding
*For the* toggleterm configuration, a keybinding to toggle the terminal should be defined
**Validates: Requirements 12.1**

Property 25: Toggleterm multiple terminals
*For the* toggleterm configuration, keybindings or commands for multiple terminal instances should be available
**Validates: Requirements 12.3**

Property 26: Catppuccin colorscheme activation
*For the* Neovim initialization, the colorscheme should be set to catppuccin-macchiato
**Validates: Requirements 13.1**

Property 27: Catppuccin plugin integrations
*For the* Catppuccin configuration, integrations for installed plugins should be enabled
**Validates: Requirements 13.4**

Property 28: Leader key configuration
*For the* Neovim initialization, the leader key should be set to space
**Validates: Requirements 14.1**

Property 29: Keybinding prefix conventions
*For the* keybinding configuration, related commands should be grouped under logical prefixes (f for find, g for git, l for LSP)
**Validates: Requirements 14.3**

## Error Handling

### Nix Build Errors

- Se um plugin não está disponível no nixpkgs, documentar alternativas ou usar overlay
- Se há conflitos de versão, especificar versões explicitamente
- Validar sintaxe Nix antes do build

### Lua Configuration Errors

- Usar pcall() para carregar configurações de plugins opcionais
- Fornecer mensagens de erro claras se plugins não estão disponíveis
- Validar que funções de plugin existem antes de chamar

### LSP Errors

- Verificar se language servers estão instalados antes de configurar
- Fornecer fallbacks se LSP não iniciar
- Logar erros de LSP para debugging

### Plugin Conflicts

- Documentar ordem de carregamento de plugins
- Evitar keybindings conflitantes através de namespacing
- Testar configuração em ambiente limpo

## Testing Strategy

### Configuration Validation Tests

Como esta é uma configuração declarativa, os testes focam em verificar que:

1. **Structural Integrity**: A configuração Nix é sintaticamente válida
2. **Completeness**: Todos os componentes necessários estão presentes
3. **Correctness**: Configurações individuais estão corretas

### Unit Tests

Unit tests verificarão aspectos específicos da configuração:

- Verificar que arquivos Lua são sintaticamente válidos
- Verificar que keybindings não têm conflitos
- Verificar que todos os plugins referenciados existem no nixpkgs
- Verificar que LSPs especificados estão em extraPackages

### Property-Based Tests

Usaremos scripts de verificação (não PBT tradicional, pois é configuração) para validar propriedades:

- **Framework**: Scripts Lua/Bash para verificação
- **Iterations**: Verificação única por propriedade (não aleatória)
- **Tagging**: Cada script referenciará a propriedade que valida

Exemplo de script de verificação:
```lua
-- Verifica Property 1: Plugin installation
local function verify_plugins()
  local required_plugins = {
    'telescope', 'nvim-lspconfig', 'nvim-cmp',
    'LuaSnip', 'nvim-treesitter', 'gitsigns',
    'neo-tree', 'which-key', 'lualine',
    'conform', 'toggleterm', 'catppuccin'
  }
  
  for _, plugin in ipairs(required_plugins) do
    local ok = pcall(require, plugin)
    assert(ok, "Plugin " .. plugin .. " not found")
  end
end
```

### Integration Tests

- Iniciar Neovim em modo headless e verificar que não há erros
- Abrir arquivos de diferentes tipos e verificar que LSP inicia
- Executar comandos de plugins e verificar sucesso
- Verificar que tema está aplicado corretamente

### Manual Verification

Alguns aspectos requerem verificação manual:
- Aparência visual do tema
- Responsividade da UI
- Experiência de uso dos keybindings
- Performance geral

## Implementation Notes

### Plugin Management via Nix

Todos os plugins serão declarados em `programs.neovim.plugins` usando `pkgs.vimPlugins`. Isso garante:
- Reprodutibilidade
- Versionamento através do nixpkgs
- Sem downloads em runtime
- Integração com garbage collection do Nix

### Lua Configuration Loading

A configuração Lua será injetada via `extraLuaConfig` que lê os arquivos Lua. Estrutura modular permite:
- Fácil manutenção
- Reutilização de componentes
- Debugging simplificado

### LSP and Tool Installation

Language servers e formatters serão instalados via `extraPackages`, garantindo que estão disponíveis no PATH do Neovim.

### Theme Consistency

Catppuccin será configurado com integrações explícitas para cada plugin, garantindo consistência visual em toda a interface.

### Keybinding Organization

Keybindings seguirão convenções:
- `<leader>f`: Find/Search (Telescope)
- `<leader>g`: Git (gitsigns)
- `<leader>l`: LSP actions
- `<leader>e`: Explorer (neo-tree)
- `<leader>t`: Terminal (toggleterm)
- `<leader>c`: Code actions (format, etc.)

### Performance Considerations

- Lazy loading não é necessário com Nix (plugins já estão compilados)
- Treesitter parsers serão pré-compilados
- LSPs iniciarão sob demanda por filetype
- Configuração será otimizada para startup rápido
