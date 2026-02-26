# Neovim Configuration

A complete, declarative Neovim configuration integrated with NixOS using home-manager. Features the Catppuccin Macchiato theme and a curated set of essential plugins for productive development.

## Quick Start

### Apply the Configuration

```bash
# For home-manager users
home-manager switch

# For NixOS users (if integrated into system configuration)
sudo nixos-rebuild switch
```

### Verify the Configuration

After applying, verify everything is working:

```bash
# Run the verification script inside Neovim
nvim -c 'lua require("verify").run_all()' -c 'quit'
```

## Features

- **Theme**: Catppuccin Macchiato applied consistently across all components
- **Fuzzy Finding**: Telescope for files, grep, buffers, and commands
- **LSP Support**: Language servers for Lua, Nix, TypeScript, and Python
- **Smart Completion**: nvim-cmp with LSP, snippets, buffer, and path sources
- **Syntax Highlighting**: Treesitter with parsers for 15+ languages
- **Git Integration**: Gitsigns with inline indicators and hunk management
- **File Explorer**: Neo-tree with Git integration and file icons
- **Keybinding Discovery**: Which-key for learning and remembering shortcuts
- **Statusline**: Lualine with LSP diagnostics and Git status
- **Code Formatting**: Conform.nvim with multiple formatters (prettier, stylua, black, etc.)
- **Integrated Terminal**: Toggleterm with floating terminal support

## Structure

```
home/neovim/
├── default.nix              # Nix configuration (plugins, LSPs, formatters)
├── config/
│   ├── init.lua            # Entry point
│   ├── options.lua         # Neovim options
│   ├── keymaps.lua         # Global keybindings
│   ├── verify.lua          # Verification script
│   └── plugins/            # Plugin configurations
│       ├── catppuccin.lua
│       ├── telescope.lua
│       ├── lsp.lua
│       ├── cmp.lua
│       ├── luasnip.lua
│       ├── treesitter.lua
│       ├── gitsigns.lua
│       ├── neo-tree.lua
│       ├── which-key.lua
│       ├── lualine.lua
│       ├── conform.lua
│       └── toggleterm.lua
├── CONFIGURATION.md         # Detailed documentation
├── README.md               # This file
├── integration_test.sh     # Integration test script
├── test_config.lua         # Configuration test script
└── check_keybindings.lua   # Keybinding conflict checker
```

## Testing

### Before Applying (Pre-flight Checks)

Run the integration test to verify the configuration is ready:

```bash
bash home/neovim/integration_test.sh
```

This checks:
- Lua syntax validity
- Keybinding conflicts
- File completeness
- Documentation completeness
- Nix syntax validity

### After Applying (Runtime Verification)

After applying the configuration with home-manager, verify it's working:

```bash
nvim -c 'lua require("verify").run_all()' -c 'quit'
```

This verifies:
- All plugins are loaded
- Core configuration is correct
- Keybindings are set
- LSP servers are configured
- Completion sources are available
- Treesitter parsers are installed

### Individual Tests

```bash
# Check Lua syntax
lua home/neovim/test_config.lua

# Check for keybinding conflicts
lua home/neovim/check_keybindings.lua
```

## Key Bindings

Leader key: **Space**

### Quick Reference

- `<leader>ff` - Find files
- `<leader>fg` - Live grep (search in files)
- `<leader>e` - Toggle file explorer
- `<leader>cf` - Format code
- `<C-\>` - Toggle terminal
- `gd` - Go to definition (LSP)
- `K` - Hover documentation (LSP)
- `<leader>ca` - Code actions (LSP)

For a complete list of keybindings, see [CONFIGURATION.md](./CONFIGURATION.md).

## Language Support

### Configured Language Servers

- **Lua** - lua_ls (with Neovim API support)
- **Nix** - nil_ls
- **TypeScript/JavaScript** - tsserver
- **Python** - pyright

### Configured Formatters

- **JavaScript/TypeScript/JSON/YAML/Markdown** - prettier
- **Lua** - stylua
- **Nix** - nixpkgs-fmt
- **Python** - black
- **Rust** - rustfmt

Note: Go formatting (gofmt) requires the Go toolchain to be installed separately.

## Customization

### Adding a Plugin

1. Add the plugin to `default.nix`:
   ```nix
   plugins = with pkgs.vimPlugins; [
     # ... existing plugins
     your-new-plugin
   ];
   ```

2. Create a configuration file in `config/plugins/`:
   ```lua
   -- config/plugins/your-plugin.lua
   require('your-plugin').setup({
     -- configuration
   })
   ```

3. Load it in `config/init.lua`:
   ```lua
   require('plugins.your-plugin')
   ```

4. Rebuild: `home-manager switch`

### Adding a Language Server

1. Add the LSP to `extraPackages` in `default.nix`:
   ```nix
   extraPackages = with pkgs; [
     # ... existing packages
     your-language-server
   ];
   ```

2. Configure it in `config/plugins/lsp.lua`:
   ```lua
   lspconfig.your_lsp.setup({
     on_attach = on_attach,
     capabilities = capabilities,
   })
   ```

3. Rebuild: `home-manager switch`

### Adding a Formatter

1. Add the formatter to `extraPackages` in `default.nix`:
   ```nix
   extraPackages = with pkgs; [
     # ... existing packages
     your-formatter
   ];
   ```

2. Configure it in `config/plugins/conform.lua`:
   ```lua
   formatters_by_ft = {
     your_filetype = { "your-formatter" },
   }
   ```

3. Rebuild: `home-manager switch`

## Documentation

- [CONFIGURATION.md](./CONFIGURATION.md) - Comprehensive documentation including:
  - Complete keybinding reference
  - Known issues and limitations
  - Troubleshooting guide
  - Performance notes
  - Customization guide

## Troubleshooting

### Configuration not loading

1. Check that the neovim module is imported in `home/default.nix`
2. Verify the configuration with: `nix-instantiate --parse home/neovim/default.nix`
3. Check for errors: `nvim --startuptime startup.log`

### Plugins not working

1. Verify plugins are installed: `nix-store -q --references $(which nvim) | grep vimPlugins`
2. Check plugin status in Neovim: `:checkhealth`
3. Run the verification script: `:lua require('verify').run_all()`

### LSP not working

1. Verify LSP is installed: `which lua-language-server` (or other LSP)
2. Check LSP status: `:LspInfo`
3. Check LSP logs: `:lua vim.cmd('e ' .. vim.lsp.get_log_path())`

For more troubleshooting tips, see [CONFIGURATION.md](./CONFIGURATION.md#troubleshooting).

## Requirements

- NixOS or Nix package manager with home-manager
- A terminal with true color support (24-bit color)
- A Nerd Font (for file icons) - recommended: JetBrainsMono Nerd Font

## References

- [Neovim Documentation](https://neovim.io/doc/)
- [NixOS Wiki - Neovim](https://nixos.wiki/wiki/Neovim)
- [home-manager Manual](https://nix-community.github.io/home-manager/)
- [Catppuccin Theme](https://github.com/catppuccin/nvim)

## License

This configuration is part of a personal dotfiles repository. Feel free to use and modify as needed.
