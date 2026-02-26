-- Neovim Configuration Entry Point
-- Requirements: 1.2, 14.1

-- Load core configuration
require('options')
require('keymaps')

-- Load plugin configurations
-- Theme must be loaded first for consistent appearance
require('plugins.catppuccin')

-- Fuzzy finder
require('plugins.telescope')

-- LSP
require('plugins.lsp')

-- Snippets (must be loaded before completion for proper integration)
require('plugins.luasnip')

-- Completion
require('plugins.cmp')

-- Treesitter for syntax highlighting
require('plugins.treesitter')

-- Git integration
require('plugins.gitsigns')

-- File explorer
require('plugins.neo-tree')

-- Keybinding discovery
require('plugins.which-key')

-- Statusline
require('plugins.lualine')

-- Code formatting
require('plugins.conform')

-- Terminal integration
require('plugins.toggleterm')

-- Configuration verification (can be run with :lua require('verify').run_all())
-- This is available for debugging but not run automatically
