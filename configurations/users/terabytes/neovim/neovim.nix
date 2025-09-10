{ pkgs, ... }:
let
# Read the original lua config for cmp-nvim-lsp
  cmpNvimLspConfigLua = builtins.readFile ./plugins/cmp-nvim-lsp_config.lua;

  # Replace the placeholder with the actual path from pkgs.nil
  # Nix will evaluate this expression to the concrete path during the build
  cmpNvimLspConfig = builtins.replaceStrings
    [
      "__NIL_LS_PATH__"
      "__LANGSERVER_EXTRACTED_PATH__"
      "__PYRIGHT_PATH__"
      "__SUMNEKO_LUA_LANGUAGE_SERVER_PATH__"
      "__TERRAFORM_LS_PATH__"
    ]
    [
      "${pkgs.nil}/bin/nil"
      "${pkgs.nodePackages.vscode-langservers-extracted}"
      "${pkgs.pyright}"
      "${pkgs.sumneko-lua-language-server}"
      "${pkgs.terraform-ls}"
    ]
    cmpNvimLspConfigLua;
in
{
  programs = {
    helix.enable = true;

    # codecompanion commands #
    ##########################
    # ga - On chat window change between models.

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      extraConfig = ''
        set number relativenumber
        set mouse=a
        set updatetime=300
        set runtimepath^=${./snippets}
        set clipboard=unnamedplus
      '';

      plugins = with pkgs.vimPlugins; [
        {
          # Configuração do plugin Luasnip para gerenciamento de snippets
          plugin = luasnip;
          type = "lua";
          config = builtins.readFile ./plugins/luasnip_config.lua;
        }
        {
          plugin = nvim-tree-lua;
          type = "lua";
          config = builtins.readFile ./plugins/nvim-tree-lua_config.lua;
        }
        {
          plugin = nvim-treesitter.withAllGrammars;
          type = "lua";
          config = builtins.readFile ./plugins/nvim-treesitter_config.lua;
        }
        {
          plugin = nvim-cmp;
          type = "lua";
          config = builtins.readFile ./plugins/nvim-cmp_config.lua;
        }
        {
          plugin = cmp-nvim-lsp;
          type = "lua";
          config = cmpNvimLspConfig;
        }
        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = builtins.readFile ./plugins/nvim-lspconfig_config.lua;
        }
        { plugin = cmp-buffer; }
        { plugin = cmp-path; }
        { plugin = cmp-cmdline; }
        { plugin = cmp_luasnip; }
        { plugin = vim-nix; }
        { plugin = mini-diff; }
        { plugin = mini-icons; }
        {
          plugin = vimtex;
          config = ''
            " This is necessary for VimTeX to load properly. The "indent" is optional.
            " Note: Most plugin managers will do this automatically!
            filetype plugin indent on

            " This enables Vim's and neovim's syntax-related features. Without this, some
            " VimTeX features will not work (see ":help vimtex-requirements" for more
            " info).
            " Note: Most plugin managers will do this automatically!
            syntax enable

            " Viewer options: One may configure the viewer either by specifying a built-in
            " viewer method:
            let g:vimtex_view_method = 'zathura'

            " VimTeX uses latexmk as the default compiler backend. If you use it, which is
            " strongly recommended, you probably don't need to configure anything. If you
            " want another compiler backend, you can change it as follows. The list of
            " supported backends and further explanation is provided in the documentation,
            " see ":help vimtex-compiler".
            let g:vimtex_compiler_method = 'latexrun'

            " Most VimTeX mappings rely on localleader and this can be changed with the
            " following line. The default is usually fine and is the symbol "\".
            " let maplocalleader = ","
          '';
        }
        { plugin = img-clip-nvim; }
        { plugin = markview-nvim; }
        { plugin = comment-nvim; }
        { 
          plugin = lualine-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/lualine-nvim.lua;
        }
        {
          plugin = catppuccin-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/catppuccin-nvim_config.lua;
        }
        { plugin = plenary-nvim; }
        {
          plugin = codecompanion-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/codecompaion-nvim_config.lua;
          }
          {
            plugin  = telescope-nvim;
            type = "lua";
            config = builtins.readFile ./plugins/telescope-nvim_config.lua;
          }
          { plugin = none-ls-nvim; }
          { plugin = dashboard-nvim; }
          { plugin = yuck-vim; }
          {
            plugin = image-nvim;
            type = "lua";
            config = builtins.readFile ./plugins/image_nvim_config.lua;
          }
        ];
      };
    };
  }
