# Implementation Plan - Neovim Configuration

- [x] 1. Create Neovim module structure
  - Create `home/neovim/` directory
  - Create `home/neovim/config/` directory for Lua files
  - Create `home/neovim/config/plugins/` directory for plugin configurations
  - _Requirements: 1.1, 1.2, 1.4_

- [x] 2. Set up base Nix configuration
  - Create `home/neovim/default.nix` with basic structure
  - Configure `programs.neovim.enable` and basic options
  - Set up `extraLuaConfig` to load from config files
  - Add neovim module import to `home/default.nix`
  - _Requirements: 1.1, 1.4, 1.5_

- [x] 3. Create core Lua configuration files
  - Create `config/init.lua` as entry point
  - Create `config/options.lua` with Neovim options (number, relativenumber, etc.)
  - Create `config/keymaps.lua` with leader key and global keybindings
  - _Requirements: 1.2, 14.1_

- [x] 4. Configure Catppuccin theme
  - Add catppuccin plugin to Nix configuration
  - Create `config/plugins/catppuccin.lua` with theme setup
  - Configure Catppuccin flavor as Macchiato
  - Enable plugin integrations (telescope, treesitter, cmp, gitsigns, etc.)
  - Set colorscheme in init.lua
  - _Requirements: 13.1, 13.4_

- [x]* 4.1 Verify Catppuccin theme configuration
  - **Property 26: Catppuccin colorscheme activation**
  - **Property 27: Catppuccin plugin integrations**
  - **Validates: Requirements 13.1, 13.4**

- [x] 5. Configure Telescope for fuzzy finding
  - Add telescope and dependencies to Nix configuration
  - Create `config/plugins/telescope.lua` with setup
  - Configure file finder, live grep, buffers, and command palette
  - Add keybindings: `<leader>ff` (files), `<leader>fg` (grep), `<leader>fb` (buffers), `<leader>fc` (commands)
  - _Requirements: 2.1, 2.4_

- [x]* 5.1 Verify Telescope configuration
  - **Property 4: Telescope keybindings completeness**
  - **Validates: Requirements 2.1, 2.4**

- [x] 6. Configure LSP with nvim-lspconfig
  - Add nvim-lspconfig plugin to Nix configuration
  - Add language servers to extraPackages (nil, lua-language-server, typescript-language-server, pyright)
  - Create `config/plugins/lsp.lua` with LSP setup
  - Configure on_attach function with keybindings (gd, K, gr, <leader>rn, <leader>ca)
  - Set up multiple language servers (Lua, Nix, TypeScript, Python)
  - _Requirements: 3.1, 3.3, 3.4_

- [x]* 6.1 Verify LSP configuration
  - **Property 5: LSP auto-attach**
  - **Property 6: LSP action keybindings**
  - **Property 7: Multiple LSP configuration**
  - **Validates: Requirements 3.1, 3.3, 3.4**

- [x] 7. Configure completion with nvim-cmp
  - Add nvim-cmp and completion sources to Nix configuration (cmp-nvim-lsp, cmp-buffer, cmp-path, cmp-luasnip)
  - Create `config/plugins/cmp.lua` with completion setup
  - Configure completion sources (LSP, buffer, path, snippets)
  - Set up completion keybindings (Tab, S-Tab, CR, C-Space)
  - Integrate with LSP capabilities
  - _Requirements: 4.2_

- [x]* 7.1 Verify nvim-cmp configuration
  - **Property 8: Completion sources integration**
  - **Validates: Requirements 4.2**

- [x] 8. Configure snippets with LuaSnip
  - Add LuaSnip and friendly-snippets to Nix configuration
  - Create `config/plugins/luasnip.lua` with snippet setup
  - Configure snippet navigation keybindings (C-k, C-j)
  - Load friendly-snippets
  - _Requirements: 5.3, 5.4_

- [x]* 8.1 Verify LuaSnip configuration
  - **Property 9: Snippet navigation keybindings**
  - **Validates: Requirements 5.3**

- [x] 9. Configure Treesitter for syntax highlighting
  - Add nvim-treesitter plugin to Nix configuration
  - Create `config/plugins/treesitter.lua` with setup
  - Enable highlight, indent, and incremental selection
  - Configure parsers for common languages (lua, nix, python, typescript, javascript, rust, go, etc.)
  - Enable text objects module
  - _Requirements: 6.3, 6.4_

- [x]* 9.1 Verify Treesitter configuration
  - **Property 10: Treesitter parser installation**
  - **Property 11: Treesitter text objects**
  - **Validates: Requirements 6.3, 6.4**

- [x] 10. Configure Git integration with gitsigns
  - Add gitsigns plugin to Nix configuration
  - Create `config/plugins/gitsigns.lua` with setup
  - Configure sign column indicators
  - Add keybindings for Git actions: `<leader>hs` (stage), `<leader>hu` (unstage), `<leader>hr` (reset), `<leader>hb` (blame)
  - _Requirements: 7.3, 7.4_

- [x]* 10.1 Verify gitsigns configuration
  - **Property 12: Git action keybindings**
  - **Property 13: Git blame keybinding**
  - **Validates: Requirements 7.3, 7.4**

- [x] 11. Configure file explorer with neo-tree
  - Add neo-tree and dependencies (nvim-web-devicons, nui.nvim) to Nix configuration
  - Create `config/plugins/neo-tree.lua` with setup
  - Configure filesystem, buffers, and git status sources
  - Enable file icons and Git indicators
  - Add keybinding: `<leader>e` to toggle neo-tree
  - _Requirements: 8.1, 8.4_

- [x]* 11.1 Verify neo-tree configuration
  - **Property 14: Neo-tree toggle keybinding**
  - **Property 15: Neo-tree Git integration**
  - **Validates: Requirements 8.1, 8.4**

- [x] 12. Configure keybinding discovery with which-key
  - Add which-key plugin to Nix configuration
  - Create `config/plugins/which-key.lua` with setup
  - Register keybinding groups with descriptions (find, git, lsp, code, etc.)
  - Configure popup delay and appearance
  - _Requirements: 9.3, 14.3_

- [x]* 12.1 Verify which-key configuration
  - **Property 16: Which-key group organization**
  - **Property 29: Keybinding prefix conventions**
  - **Validates: Requirements 9.3, 14.3**

- [x] 13. Configure statusline with lualine
  - Add lualine plugin to Nix configuration
  - Create `config/plugins/lualine.lua` with setup
  - Configure sections: mode, filename, filetype, cursor position, Git branch, Git diff
  - Add LSP diagnostics to statusline
  - Set theme to catppuccin
  - _Requirements: 10.2, 10.3, 10.4_

- [x]* 13.1 Verify lualine configuration
  - **Property 17: Lualine component completeness**
  - **Property 18: Lualine LSP diagnostics**
  - **Property 19: Lualine theme consistency**
  - **Validates: Requirements 10.2, 10.3, 10.4**

- [x] 14. Configure code formatting with conform.nvim
  - Add conform.nvim plugin to Nix configuration
  - Add formatters to extraPackages (prettier, stylua, nixpkgs-fmt, black, etc.)
  - Create `config/plugins/conform.lua` with setup
  - Configure formatters by filetype
  - Enable format_on_save
  - Add manual format keybinding: `<leader>cf`
  - _Requirements: 11.1, 11.2, 11.3, 11.4_

- [x]* 14.1 Verify conform configuration
  - **Property 20: Conform format on save**
  - **Property 21: Conform formatter mapping**
  - **Property 22: Conform manual format keybinding**
  - **Property 23: Conform multiple formatters**
  - **Validates: Requirements 11.1, 11.2, 11.3, 11.4**

- [x] 15. Configure integrated terminal with toggleterm
  - Add toggleterm plugin to Nix configuration
  - Create `config/plugins/toggleterm.lua` with setup
  - Configure floating terminal with appropriate size
  - Add keybinding: `<C-\>` to toggle terminal
  - Configure multiple terminal instances with `<leader>t1`, `<leader>t2`, etc.
  - _Requirements: 12.1, 12.3, 12.4_

- [x]* 15.1 Verify toggleterm configuration
  - **Property 24: Toggleterm keybinding**
  - **Property 25: Toggleterm multiple terminals**
  - **Validates: Requirements 12.1, 12.3**

- [x] 16. Final integration and verification
  - Ensure all plugin configurations are loaded in init.lua in correct order
  - Verify no keybinding conflicts
  - Test that all plugins work together
  - Document any known issues or limitations
  - _Requirements: All_

- [x]* 16.1 Create configuration validation script
  - Write Lua script to verify all properties
  - **Property 1: Plugin installation verification**
  - **Property 2: Lua configuration loading**
  - **Property 3: Nix-managed plugins only**
  - **Property 28: Leader key configuration**
  - **Validates: Requirements 1.1, 1.2, 1.5, 14.1**

- [x]* 16.2 Run integration tests
  - Test Neovim startup in headless mode
  - Verify no errors in initialization
  - Test opening files of different types
  - Verify LSP attachment for supported filetypes
  - _Requirements: All_

- [x] 17. Checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.
