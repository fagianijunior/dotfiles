{ pkgs, ... }:
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
      '';
      plugins = with pkgs.vimPlugins; [
     
        { 
          plugin = nvim-tree-lua;
          type = "lua";
          config = ''
            -- set termguicolors to enale highlight groups
            vim.opt.termguicolors = true

            require("nvim-tree").setup({
              sort = {
                sorter = "case_sensitive"
              },
              view = {
                width = 30
              },
              renderer = {
                group_empty = true
              },
              filters = {
                dotfiles = true
              }
            });
            vim.api.nvim_create_autocmd("VimEnter", {
              callback = function()
                local args = vim.fn.argv()
                -- Does not open NvimTree wen editing a single file
                if #args == 0 then
                  require("nvim-tree.api").tree.open()
                end
              end
            });
          '';
        }
        {
          plugin = nvim-treesitter.withAllGrammars;
          type = "lua";
          config = ''
            require'nvim-treesitter.configs'.setup {
              -- Modules and its options go here
              highlight = { enable = true },
              incremental_selection = {
                enable = true,
                keymaps = {
                  init_selection = "gnn",
                  node_incremental = "grn",
                  scope_incremental = "grc",
                  node_decremental = "grm",
                },
              },
              textobjects = { enable = true },
              indent = { enable = true }
            }
          '';
        }
        {
          plugin = nvim-lspconfig;
        }
        {
          plugin = luasnip;
          type = "lua";
          config = ''
            local luasnip = require 'luasnip';
            local s = luasnip.snippet;
            local sn = luasnip.snippet_node;
            local t = luasnip.text_node;
            local i = luasnip.insert_node;
            local f = luasnip.function_node;
            local c = luasnip.choice_node;
            local d = luasnip.dynamic_node;
            local r = luasnip.restore_node;

            luasnip.add_snippets("tex", {
              s("\\start", {t({ "\\documentclass[a4paper]{article}", 
                "\\usepackage{alltt, amssymb, listings, todonotes}",
                "\\begin{document}", 
                "\\section*{ - \\today}", "",}), 
              i(1), 
              t({"", 
                "\\end{document}",}), 
              }),

              s("\\verbatim", {t({ "\\begin{verbatim}", "" }),
              i(1), 
              t({"", 
                "\\end{verbatim}",}), 
              }),

              s("\\alltt", {t({ "\\begin{alltt}", "" }),
              i(1), 
              t({"", 
                "\\end{alltt}",}), 
              }), 

              s("\\itemize", {t({ "\\begin{itemize}", "" }),
              t("\\item "), i(1), 
              t({"", 
                "\\end{itemize}",}), 
              }),

              s("\\enumerate", {t({ "\\begin{enumerate}", "" }),
                t("\\item "), i(1), 
                t({"", 
                  "\\end{enumerate}",
                }), 
              }),

              s("\\lstlisting", {t({ "%\\lstset{language=C}", "\\begin{lstlisting}", "" }),
              i(1), 
              t({"", 
                "\\end{lstlisting}",}), 
              }),

              --text
              s("\\dc", { t("\\documentclass{"), i(1), t("}"), }),
              s("\\bf", { t("\\textbf{"), i(1), t("}"), }),
              s("\\it", { t("\\textit{"), i(1), t("}"), }),
              s("\\section", { t("\\section{"), i(1), t("}"), }),
              s("\\todo", { t("\\todo{"), i(1), t("}"), }),

              s("\\red", { t("\\textcolor{red}{"), i(1), t("}"), }),
              s("\\green", { t("\\textcolor{green}{"), i(1), t("}"), }),
              s("\\blue", { t("\\textcolor{blue}{"), i(1), t("}"), }),
              s("\\gray", { t("\\textcolor{gray}{"), i(1), t("}"), }),
              s("\\pink", { t("\\textcolor{pink}{"), i(1), t("}"), }),

              -- math
              s("\\frac", { t("\\frac{"), i(1), t("}{"), i(2), t("}"), }),
            });
          '';
          }
          {
            plugin = cmp-nvim-lsp;
            type = "lua";
            config = ''
              -- mostly stolen from rafaelrc7's dotfile
              local lspconfig = require "lspconfig"
              local capabilities = require("cmp_nvim_lsp").default_capabilities()

              -- nix
              lspconfig.nil_ls.setup{
                cmd = { "${pkgs.nil}/bin/nil" },
                capabilities = capabilities,
              };

              -- html
              capabilities.textDocument.completion.completionItem.snippetSupport = true;
              lspconfig.html.setup {
                cmd = {"${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-html-language-server", "--stdio"},
                capabilities = capabilities,
              };

              -- CSS
              lspconfig.cssls.setup {
                cmd = {"${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-css-language-server", "--stdio"},
                capabilities = capabilities,
              };

              -- Json
            lspconfig.jsonls.setup {
              cmd = {"${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-json-language-server", "--stdio"},
              commands = {
                Format = {
                  function()
                  vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0});
                  end
                },
              },
              capabilities = capabilities,
            };

            -- Python (pyright)
            lspconfig.pyright.setup{
              cmd = {"${pkgs.pyright}/bin/pyright-langserver", "--stdio"},
              settings = {
                python = {
                  analysis = {
                    extraPaths = {".", "src"},
                  },
                },
              },
              capabilities = capabilities,
            };

            -- Lua
            lspconfig.lua_ls.setup {
              cmd = {"${pkgs.sumneko-lua-language-server}/bin/lua-language-server"},
              settings = {
                Lua = {
                  runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                  },
                  diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = {'vim'},
                  },
                  workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                  },
                  -- Do not send telemetry data containing a randomized but unique identifier
                  telemetry = {
                    enable = false,
                  },
                },
              },
              capabilities = capabilities,
            }
            '';
          }
          { plugin = cmp-buffer; }
          { plugin = cmp-path; }
          { plugin = cmp-cmdline; }
          { plugin = cmp_luasnip; }
          {
            plugin = nvim-cmp;
            type = "lua";
            config = ''
              local cmp = require "cmp";
              cmp.setup({
                mapping = cmp.mapping.preset.insert({
                  ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                  ["<C-f>"] = cmp.mapping.scroll_docs(4),
                  ["<C-Space>"] = cmp.mapping.complete(),
                  ["<C-e>"] = cmp.mapping.abort(),
                  ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                  { name = "nvim_lsp" },
                  { name = "luasnip" },
                  { name = "path" },
                  { name = "buffer" },
                  { name = "codecompanion" },
                }),
                -- snippet = {
                --  expand = function(args)
                --  luasnip.lsp_expand(args.body)
                --  end
                --};
                --window = {
                --  completion = cmp.config.window.bordered(),
                --  documentation = cmp.config.window.bordered(),
                --};
              });
            '';
          }
          { plugin = vim-nix; }
          { plugin = mini-diff; }
          { plugin = mini-icons; }
          {
            plugin = vimtex;
            config = ''
            let g:vimtex_view_method = 'zathura'
            autocmd User VimtexEventQuit VimtexClean
            nnoremap <F4> :NvimTreeToggle<CR>
            nnoremap <F5> :VimtexCompile<CR>
            nnoremap <F6> :VimtexStop<CR>:VimtexClean<CR>
            '';
          }
          { plugin = img-clip-nvim; }
          { plugin = markview-nvim; }
          { plugin = comment-nvim; }
          { 
            plugin = lualine-nvim;
            type = "lua";
            config = ''
            require("lualine").setup {
              options = {
                icons_enabled = true,
                theme = "auto",
              },
            }
            '';
          }
          {
            plugin = plenary-nvim;
          }
          {
            plugin = codecompanion-nvim;
            type = "lua";
            config = ''
              require("codecompanion").setup({
                providers = {
                  openai = {
                    api_key = os.getenv("GPT_API_KEY"),
                    model = "gpt-4-turbo", -- ou outro modelo disponível
                    base_url = "https://api.openai.com/v1"
                  },
                  gemini = {
                    api_key = os.getenv("GEMINI_API_KEY"),
                    model = "gemini-pro",
                    base_url = "https://generativelanguage.googleapis.com/v1beta/models"
                  }
                },
                default_provider = "openai" -- ou "gemini"
              })
            '';
          }
          {
            plugin  = telescope-nvim;
            type = "lua";
            config = ''
              require('telescope').setup({
                pickers = {
                    buffers = {
                      show_all_buffers = true,
                      sort_mru = true,
                      mappings = {
                        i = {
                        ["<c-d>"] = "delete_buffer",
                      },
                    },
                    find_files = {
                      find_command = { 'rg', '--files', '--hidden' },
                    },
                  },
                },
              })
            '';

          }
          {
            plugin = oil-nvim;
          }
          {
            plugin = none-ls-nvim;
          }
          {
            plugin = dashboard-nvim;
          }
        ];
      };
    };
  }
