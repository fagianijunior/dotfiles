{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Plugins will be added here as we progress through tasks
    plugins = with pkgs.vimPlugins; [
      # Theme
      catppuccin-nvim
      
      # Fuzzy finder
      telescope-nvim
      plenary-nvim  # Required dependency for telescope
      telescope-fzf-native-nvim  # Better sorting performance
      
      # LSP
      nvim-lspconfig
      
      # Completion
      nvim-cmp
      cmp-nvim-lsp  # LSP completion source
      cmp-buffer    # Buffer completion source
      cmp-path      # Path completion source
      cmp_luasnip   # Snippet completion source
      cmp-cmdline   # Command-line completion source
      
      # Snippets
      luasnip              # Snippet engine (required for cmp-luasnip)
      friendly-snippets    # Collection of pre-made snippets
      
      # Treesitter
      (nvim-treesitter.withPlugins (p: [
        p.lua
        p.nix
        p.python
        p.typescript
        p.javascript
        p.tsx
        p.rust
        p.go
        p.bash
        p.json
        p.yaml
        p.toml
        p.markdown
        p.html
        p.css
        p.vim
        p.vimdoc
      ]))
      nvim-treesitter-textobjects  # Text objects based on treesitter
      
      # Git integration
      gitsigns-nvim
      
      # File explorer
      neo-tree-nvim
      nvim-web-devicons  # File icons
      nui-nvim           # UI component library (required by neo-tree)
      
      # Keybinding discovery
      which-key-nvim
      
      # Statusline
      lualine-nvim
      
      # Code formatting
      conform-nvim
      
      # Terminal integration
      toggleterm-nvim
      
      # Core plugins will be added in subsequent tasks
    ];

    # External packages (LSPs, formatters, etc.) will be added in subsequent tasks
    extraPackages = with pkgs; [
      # Telescope dependencies
      ripgrep  # For live grep functionality
      fd       # For file finding (faster than find)
      
      # Language servers
      nil  # Nix LSP
      lua-language-server
      nodePackages.typescript-language-server
      pyright  # Python LSP
      
      # Formatters
      nodePackages.prettier  # JavaScript, TypeScript, JSON, YAML, Markdown, etc.
      stylua                 # Lua formatter
      nixpkgs-fmt           # Nix formatter
      black                  # Python formatter
      rustfmt               # Rust formatter
      # Note: gofmt comes with the go package, install go if you need Go formatting
      
      # Language servers and formatters will be added as needed
    ];

    # Load Lua configuration from config files
    # We need to inline all the configuration since require() won't work with extraLuaConfig
    extraLuaConfig = ''
      -- Load options
      ${builtins.readFile ./config/options.lua}
      
      -- Load keymaps
      ${builtins.readFile ./config/keymaps.lua}
      
      -- Load plugin configurations
      ${builtins.readFile ./config/plugins/catppuccin.lua}
      ${builtins.readFile ./config/plugins/telescope.lua}
      ${builtins.readFile ./config/plugins/lsp.lua}
      ${builtins.readFile ./config/plugins/luasnip.lua}
      ${builtins.readFile ./config/plugins/cmp.lua}
      ${builtins.readFile ./config/plugins/treesitter.lua}
      ${builtins.readFile ./config/plugins/gitsigns.lua}
      ${builtins.readFile ./config/plugins/neo-tree.lua}
      ${builtins.readFile ./config/plugins/which-key.lua}
      ${builtins.readFile ./config/plugins/lualine.lua}
      ${builtins.readFile ./config/plugins/conform.lua}
      ${builtins.readFile ./config/plugins/toggleterm.lua}
    '';
  };
}
