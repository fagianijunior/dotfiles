{ pkgs, lib, config, ... }:

let
  inherit (pkgs) vimPlugins;
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;

    withNodeJs = true;
    withPython3 = true;

    plugins = with vimPlugins; [
      # Core
      plenary-nvim

      # UI / UX
      nvim-web-devicons
      lualine-nvim
      which-key-nvim

      # Navigation
      telescope-nvim

      # Editing
      nvim-surround
      comment-nvim
      indent-blankline-nvim

      # Treesitter
      (nvim-treesitter.withPlugins (p: [
        p.bash
        p.lua
        p.nix
        p.javascript
        p.typescript
        p.json
        p.yaml
        p.html
        p.css
        p.markdown
      ]))

      # LSP
      nvim-lspconfig

      # Completion
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip
    ];

    extraLuaConfig = builtins.readFile ./init.lua;
  };

  ############################
  # LSP servers via Nix
  ############################

  home.packages = with pkgs; [
    # Nix
    nil
    alejandra

    # JS / TS
    nodePackages.typescript-language-server
    nodePackages.prettier

    # Lua
    lua-language-server

    # Bash
    shellcheck
    shfmt
  ];
}

