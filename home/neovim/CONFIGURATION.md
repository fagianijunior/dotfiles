# Neovim Configuration Documentation

## Overview

This is a complete Neovim configuration integrated with NixOS using home-manager. The configuration follows a declarative approach with all plugins managed through Nix, ensuring reproducibility across systems.

## Theme

The configuration uses **Catppuccin Macchiato** theme consistently across all components.

## Plugin Loading Order

The plugins are loaded in the following order (defined in `config/init.lua`):

1. **Core Configuration**
   - `options.lua` - General Neovim options
   - `keymaps.lua` - Global keybindings and leader key setup

2. **Theme** (loaded first for consistent appearance)
   - `catppuccin` - Theme configuration

3. **Navigation & Search**
   - `telescope` - Fuzzy finder for files, grep, buffers, commands

4. **Language Support**
   - `lsp` - Language Server Protocol configuration
   - `luasnip` - Snippet engine (loaded before completion)
   - `cmp` - Completion engine with multiple sources
   - `treesitter` - Advanced syntax highlighting

5. **Version Control**
   - `gitsigns` - Git integration with inline indicators

6. **File Management**
   - `neo-tree` - File explorer with Git integration

7. **UI Enhancements**
   - `which-key` - Keybinding discovery
   - `lualine` - Statusline with LSP diagnostics

8. **Code Quality**
   - `conform` - Code formatting with multiple formatters

9. **Terminal**
   - `toggleterm` - Integrated terminal

## Keybinding Organization

All custom keybindings use **Space** as the leader key.

### Keybinding Prefixes

- `<leader>f` - **Find/Search** (Telescope)
  - `<leader>ff` - Find files
  - `<leader>fg` - Live grep (search in files)
  - `<leader>fb` - Find buffers
  - `<leader>fc` - Find commands
  - `<leader>fh` - Find help
  - `<leader>fk` - Find keymaps
  - `<leader>fr` - Find recent files
  - `<leader>fw` - Find word under cursor
  - `<leader>fd` - Find diagnostics

- `<leader>g` - **Git** (gitsigns) - Note: Most git actions use `<leader>h` prefix
  
- `<leader>h` - **Git Hunks** (gitsigns)
  - `<leader>hs` - Stage hunk
  - `<leader>hu` - Unstage hunk (undo stage)
  - `<leader>hr` - Reset hunk
  - `<leader>hS` - Stage buffer
  - `<leader>hR` - Reset buffer
  - `<leader>hb` - Blame line
  - `<leader>hp` - Preview hunk
  - `<leader>hd` - Diff this
  - `<leader>hD` - Diff this ~
  - `]c` - Next hunk
  - `[c` - Previous hunk

- `<leader>c` - **Code Actions**
  - `<leader>ca` - Code action (LSP)
  - `<leader>cf` - Format code (conform)

- `<leader>r` - **Refactoring**
  - `<leader>rn` - Rename symbol (LSP)

- `<leader>d` - **Diagnostics**
  - `<leader>de` - Show diagnostic (float)
  - `<leader>dl` - Diagnostic list
  - `<leader>ds` - Document symbols
  - `<leader>D` - Type definition

- `<leader>w` - **Workspace**
  - `<leader>ws` - Workspace symbols

- `<leader>e` - **Explorer**
  - `<leader>e` - Toggle neo-tree

- `<leader>t` - **Terminal & Toggles**
  - `<leader>t1`, `<leader>t2`, `<leader>t3`, `<leader>t4` - Multiple terminal instances
  - `<leader>tb` - Toggle line blame (gitsigns)
  - `<leader>td` - Toggle deleted lines (gitsigns)

- `<leader>q` - **Quit**
  - `<leader>q` - Quit current window
  - `<leader>Q` - Quit all

### LSP Keybindings (buffer-local)

These keybindings are available when LSP is attached to a buffer:

- `gd` - Go to definition
- `gD` - Go to declaration
- `gr` - Go to references
- `gi` - Go to implementation
- `K` - Hover documentation
- `[d` - Previous diagnostic
- `]d` - Next diagnostic

### Terminal Keybindings

- `<C-\>` - Toggle terminal

### Window Navigation

- `<C-h>` - Move to left window
- `<C-j>` - Move to bottom window
- `<C-k>` - Move to top window
- `<C-l>` - Move to right window

### Buffer Navigation

- `<S-h>` - Previous buffer
- `<S-l>` - Next buffer

## Language Server Configuration

The following language servers are configured:

- **Lua** (`lua_ls`) - Lua language server with Neovim API support
- **Nix** (`nil_ls`) - Nix language server with nixpkgs-fmt integration
- **TypeScript/JavaScript** (`tsserver`) - TypeScript language server
- **Python** (`pyright`) - Python language server

LSP features include:
- Auto-completion
- Go to definition/declaration/references
- Hover documentation
- Rename refactoring
- Code actions
- Inline diagnostics

## Code Formatting

The following formatters are configured via conform.nvim:

- **JavaScript/TypeScript/JSON/YAML/Markdown** - prettier
- **Lua** - stylua
- **Nix** - nixpkgs-fmt
- **Python** - black
- **Rust** - rustfmt

Note: Go formatting (gofmt) is available if you have the Go toolchain installed.

Formatting is triggered:
- Automatically on save (for configured filetypes)
- Manually with `<leader>cf`

## Completion Sources

nvim-cmp integrates the following completion sources (in priority order):

1. **LSP** - Language server completions
2. **LuaSnip** - Snippet completions
3. **Buffer** - Words from current buffer
4. **Path** - File path completions

## Treesitter Parsers

The following language parsers are installed:

- lua, nix, python, typescript, javascript, tsx
- rust, go, bash
- json, yaml, toml, markdown
- html, css
- vim, vimdoc

Features enabled:
- Advanced syntax highlighting
- Incremental selection
- Text objects
- Smart indentation

## Known Issues and Limitations

### 1. Keybinding Conflicts

**Issue**: Some keybindings may conflict with terminal emulator or system shortcuts.

**Affected keybindings**:
- `<C-\>` (toggleterm) - May conflict with some terminal emulators
- `<C-h/j/k/l>` (window navigation) - May conflict with terminal navigation

**Workaround**: Configure your terminal emulator to pass these keys through to Neovim, or modify the keybindings in the respective configuration files.

### 2. LSP Diagnostic Conflicts

**Issue**: The LSP configuration includes format-on-save for all servers that support formatting. This may conflict with conform.nvim's format-on-save.

**Impact**: Files may be formatted twice on save, which is usually harmless but may cause slight delays.

**Workaround**: If this causes issues, you can disable LSP format-on-save by modifying the `on_attach` function in `config/plugins/lsp.lua` to remove the format-on-save autocmd.

### 3. Neo-tree and Telescope File Icons

**Issue**: File icons require a Nerd Font to be installed and configured in your terminal.

**Impact**: Without a Nerd Font, icons will appear as boxes or question marks.

**Workaround**: Install a Nerd Font (e.g., JetBrainsMono Nerd Font, FiraCode Nerd Font) and configure your terminal to use it.

### 4. Treesitter Parser Compilation

**Issue**: With Nix-managed Neovim, Treesitter parsers are pre-compiled and cannot be updated at runtime.

**Impact**: You cannot use `:TSInstall` or `:TSUpdate` commands. Parser updates require rebuilding the Nix configuration.

**Workaround**: To add or update parsers, modify the `nvim-treesitter.withPlugins` section in `default.nix` and rebuild your NixOS/home-manager configuration.

### 5. Plugin Updates

**Issue**: Plugins are managed by Nix and follow the nixpkgs channel version.

**Impact**: Plugin versions may lag behind the latest releases. You cannot update plugins independently.

**Workaround**: 
- Update your nixpkgs channel to get newer plugin versions
- Use overlays to pin specific plugin versions if needed
- For bleeding-edge plugins, you can use `fetchFromGitHub` in your Nix configuration

### 6. Telescope FZF Native

**Issue**: The telescope-fzf-native plugin requires compilation and may not work on all systems.

**Impact**: Telescope will fall back to Lua-based sorting if the native extension fails to load.

**Workaround**: This is handled gracefully by the configuration. If you experience issues, you can remove `telescope-fzf-native-nvim` from the plugin list.

### 7. Completion Menu Appearance

**Issue**: The completion menu appearance depends on the terminal's color support.

**Impact**: In terminals without true color support, the completion menu may not match the theme perfectly.

**Workaround**: Ensure your terminal supports true colors (24-bit color). Most modern terminals do, but you may need to set `TERM=xterm-256color` or similar.

### 8. Which-key Popup Delay

**Issue**: The which-key popup has a 300ms delay (configured in `options.lua` as `timeoutlen`).

**Impact**: There's a slight delay before the popup appears after pressing the leader key.

**Workaround**: You can adjust `vim.opt.timeoutlen` in `config/options.lua` to a lower value (e.g., 200) if you prefer a faster popup, but this may make it harder to see the popup before completing a keybinding sequence.

## Verification

To verify your configuration is working correctly, you can run the verification script:

```vim
:lua require('verify').run_all()
```

This will check:
- Plugin installation
- Core configuration (leader key, colorscheme, options)
- Keybindings
- Keybinding conflicts
- LSP configuration
- Completion sources
- Treesitter parsers

## Troubleshooting

### Neovim won't start or shows errors

1. Check that all plugins are properly installed:
   ```bash
   nix-store -q --references $(which nvim) | grep vimPlugins
   ```

2. Verify the Lua configuration syntax:
   ```bash
   nvim --headless -c "lua require('init')" -c "quit"
   ```

3. Check for errors in the Neovim log:
   ```bash
   nvim --startuptime startup.log
   cat startup.log
   ```

### LSP not working

1. Verify the language server is installed:
   ```bash
   which lua-language-server
   which nil
   which typescript-language-server
   which pyright
   ```

2. Check LSP status in Neovim:
   ```vim
   :LspInfo
   ```

3. Check LSP logs:
   ```vim
   :lua vim.cmd('e ' .. vim.lsp.get_log_path())
   ```

### Completion not working

1. Verify nvim-cmp is loaded:
   ```vim
   :lua print(vim.inspect(require('cmp').get_config()))
   ```

2. Check that completion sources are available:
   ```vim
   :CmpStatus
   ```

### Treesitter highlighting not working

1. Verify parsers are installed:
   ```vim
   :TSInstallInfo
   ```

2. Check Treesitter status for current buffer:
   ```vim
   :TSBufToggle highlight
   ```

## Customization

To customize this configuration:

1. **Modify options**: Edit `config/options.lua`
2. **Add keybindings**: Edit `config/keymaps.lua` or the respective plugin config
3. **Configure plugins**: Edit files in `config/plugins/`
4. **Add plugins**: Add to `plugins` list in `default.nix`
5. **Add language servers**: Add to `extraPackages` in `default.nix` and configure in `config/plugins/lsp.lua`
6. **Add formatters**: Add to `extraPackages` in `default.nix` and configure in `config/plugins/conform.lua`

After making changes, rebuild your NixOS/home-manager configuration:

```bash
# For home-manager
home-manager switch

# For NixOS
sudo nixos-rebuild switch
```

## Performance

The configuration is optimized for fast startup:

- Plugins are pre-compiled by Nix (no runtime compilation)
- No lazy loading needed (Nix handles this efficiently)
- LSP servers start on-demand per filetype
- Treesitter parsers are pre-compiled

Typical startup time: < 100ms

## References

- [Neovim Documentation](https://neovim.io/doc/)
- [NixOS Wiki - Neovim](https://nixos.wiki/wiki/Neovim)
- [Catppuccin Theme](https://github.com/catppuccin/nvim)
- [Telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
