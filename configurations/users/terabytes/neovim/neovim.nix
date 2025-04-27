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
            };

            -- Terraform
            lspconfig.terraformls.setup {
              cmd = { "${pkgs.terraform-ls}/bin/terraform-ls", "serve" },
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
              local fmt = string.format;
              require("codecompanion").setup({
                strategies = {
                  -- CHAT STRATEGY ----------------------------------------------------------
                  chat = {
                    adapter = "gemini",
                    roles = {
                      ---The header name for the LLM's messages
                      ---@type string|fun(adapter: CodeCompanion.Adapter): string
                      llm = function(adapter)
                        return "CodeCompanion (" .. adapter.formatted_name .. ")"
                      end,

                      ---The header name for your messages
                      ---@type string
                      user = "Me",
                    },
                    tools = {
                      groups = {
                        ["full_stack_dev"] = {
                          description = "Full Stack Developer - Can run code, edit code and modify files",
                          system_prompt = "**DO NOT** make any assumptions about the dependencies that a user has installed. If you need to install any dependencies to fulfil the user's request, do so via the Command Runner tool. If the user doesn't specify a path, use their current working directory.",
                          tools = {
                            "cmd_runner",
                            "editor",
                            "files",
                          },
                        },
                      },
                      ["cmd_runner"] = {
                        callback = "strategies.chat.agents.tools.cmd_runner",
                        description = "Run shell commands initiated by the LLM",
                        opts = {
                          requires_approval = true,
                        },
                      },
                      ["editor"] = {
                        callback = "strategies.chat.agents.tools.editor",
                        description = "Update a buffer with the LLM's response",
                      },
                      ["files"] = {
                        callback = "strategies.chat.agents.tools.files",
                        description = "Update the file system with the LLM's response",
                        opts = {
                          requires_approval = true,
                        },
                      },
                      opts = {
                        auto_submit_errors = false, -- Send any errors to the LLM automatically?
                        auto_submit_success = false, -- Send any successful output to the LLM automatically?
                        system_prompt = [[## Tools Access and Execution Guidelines

### Overview
You now have access to specialized tools that empower you to assist users with specific tasks. These tools are available only when explicitly requested by the user.

### General Rules
- **User-Triggered:** Only use a tool when the user explicitly indicates that a specific tool should be employed (e.g., phrases like "run command" for the cmd_runner).
- **Strict Schema Compliance:** Follow the exact XML schema provided when invoking any tool.
- **XML Format:** Always wrap your responses in a markdown code block designated as XML and within the `<tools></tools>` tags.
- **Valid XML Required:** Ensure that the constructed XML is valid and well-formed.
- **Multiple Commands:**
  - If issuing commands of the same type, combine them within one `<tools></tools>` XML block with separate `<action></action>` entries.
  - If issuing commands for different tools, ensure they're wrapped in `<tool></tool>` tags within the `<tools></tools>` block.
- **No Side Effects:** Tool invocations should not alter your core tasks or the general conversation structure.]],
                      },
                    },
                    variables = {
                      --["buffer"] = {
                      --  callback = "strategies.chat.variables.buffer",
                      --  description = "Share the current buffer with the LLM",
                      --  opts = {
                      --    contains_code = true,
                      --    has_params = true,
                      --  },
                      --},
                      ["lsp"] = {
                        callback = "strategies.chat.variables.lsp",
                        description = "Share LSP information and code for the current buffer",
                        opts = {
                          contains_code = true,
                        },
                      },
                      ["viewport"] = {
                        callback = "strategies.chat.variables.viewport",
                        description = "Share the code that you see in Neovim with the LLM",
                        opts = {
                          contains_code = true,
                        },
                      },
                    },
                    slash_commands = {
                      ["buffer"] = {
                        callback = "strategies.chat.slash_commands.buffer",
                        description = "Insert open buffers",
                        opts = {
                          contains_code = true,
                          provider = telescope, -- default|telescope|mini_pick|fzf_lua|snacks
                        },
                      },
                      ["fetch"] = {
                        callback = "strategies.chat.slash_commands.fetch",
                        description = "Insert URL contents",
                        opts = {
                          adapter = "jina",
                        },
                      },
                      ["file"] = {
                        callback = "strategies.chat.slash_commands.file",
                        description = "Insert a file",
                        opts = {
                          contains_code = true,
                          max_lines = 1000,
                          provider = telescope, -- default|telescope|mini_pick|fzf_lua|snacks
                        },
                      },
                      ["help"] = {
                        callback = "strategies.chat.slash_commands.help",
                        description = "Insert content from help tags",
                        opts = {
                          contains_code = false,
                          max_lines = 128, -- Maximum amount of lines to of the help file to send (NOTE: Each vimdoc line is typically 10 tokens)
                          provider = telescope, -- telescope|mini_pick|fzf_lua|snacks
                        },
                      },
                      ["now"] = {
                        callback = "strategies.chat.slash_commands.now",
                        description = "Insert the current date and time",
                        opts = {
                          contains_code = false,
                        },
                      },
                      ["symbols"] = {
                        callback = "strategies.chat.slash_commands.symbols",
                        description = "Insert symbols for a selected file",
                        opts = {
                          contains_code = true,
                          provider = telescope, -- default|telescope|mini_pick|fzf_lua|snacks
                        },
                      },
                      ["terminal"] = {
                        callback = "strategies.chat.slash_commands.terminal",
                        description = "Insert terminal output",
                        opts = {
                          contains_code = false,
                        },
                      },
                      ["workspace"] = {
                        callback = "strategies.chat.slash_commands.workspace",
                        description = "Load a workspace file",
                        opts = {
                          contains_code = true,
                        },
                      },
                    },
                    keymaps = {
                      options = {
                        modes = {
                          n = "?",
                        },
                        callback = "keymaps.options",
                        description = "Options",
                        hide = true,
                      },
                      completion = {
                        modes = {
                          i = "<C-_>",
                        },
                        index = 1,
                        callback = "keymaps.completion",
                        description = "Completion Menu",
                      },
                      send = {
                        modes = {
                          n = { "<CR>", "<C-s>" },
                          i = "<C-s>",
                        },
                        index = 2,
                        callback = "keymaps.send",
                        description = "Send",
                      },
                      regenerate = {
                        modes = {
                          n = "gr",
                        },
                        index = 3,
                        callback = "keymaps.regenerate",
                        description = "Regenerate the last response",
                      },
                      close = {
                        modes = {
                          n = "<C-c>",
                          i = "<C-c>",
                        },
                        index = 4,
                        callback = "keymaps.close",
                        description = "Close Chat",
                      },
                      stop = {
                        modes = {
                          n = "q",
                        },
                        index = 5,
                        callback = "keymaps.stop",
                        description = "Stop Request",
                      },
                      clear = {
                        modes = {
                          n = "gx",
                        },
                        index = 6,
                        callback = "keymaps.clear",
                        description = "Clear Chat",
                      },
                      codeblock = {
                        modes = {
                          n = "gc",
                        },
                        index = 7,
                        callback = "keymaps.codeblock",
                        description = "Insert Codeblock",
                      },
                      yank_code = {
                        modes = {
                          n = "gy",
                        },
                        index = 8,
                        callback = "keymaps.yank_code",
                        description = "Yank Code",
                      },
                      pin = {
                        modes = {
                          n = "gp",
                        },
                        index = 9,
                        callback = "keymaps.pin_reference",
                        description = "Pin Reference",
                      },
                      watch = {
                        modes = {
                          n = "gw",
                        },
                        index = 10,
                        callback = "keymaps.toggle_watch",
                        description = "Watch Buffer",
                      },
                      next_chat = {
                        modes = {
                          n = "}",
                        },
                        index = 11,
                        callback = "keymaps.next_chat",
                        description = "Next Chat",
                      },
                      previous_chat = {
                        modes = {
                          n = "{",
                        },
                        index = 12,
                        callback = "keymaps.previous_chat",
                        description = "Previous Chat",
                      },
                      next_header = {
                        modes = {
                          n = "]]",
                        },
                        index = 13,
                        callback = "keymaps.next_header",
                        description = "Next Header",
                      },
                      previous_header = {
                        modes = {
                          n = "[[",
                        },
                        index = 14,
                        callback = "keymaps.previous_header",
                        description = "Previous Header",
                      },
                      change_adapter = {
                        modes = {
                          n = "ga",
                        },
                        index = 15,
                        callback = "keymaps.change_adapter",
                        description = "Change adapter",
                      },
                      fold_code = {
                        modes = {
                          n = "gf",
                        },
                        index = 15,
                        callback = "keymaps.fold_code",
                        description = "Fold code",
                      },
                      debug = {
                        modes = {
                          n = "gd",
                        },
                        index = 16,
                        callback = "keymaps.debug",
                        description = "View debug info",
                      },
                      system_prompt = {
                        modes = {
                          n = "gs",
                        },
                        index = 17,
                        callback = "keymaps.toggle_system_prompt",
                        description = "Toggle the system prompt",
                      },
                      auto_tool_mode = {
                        modes = {
                          n = "gta",
                        },
                        index = 18,
                        callback = "keymaps.auto_tool_mode",
                        description = "Toggle automatic tool mode",
                      },
                    },
                    opts = {
                      register = "+", -- The register to use for yanking code
                      yank_jump_delay_ms = 400, -- Delay in milliseconds before jumping back from the yanked code
                    },
                  },
                  -- INLINE STRATEGY --------------------------------------------------------
                  inline = {
                    adapter = "gemini",
                    keymaps = {
                      accept_change = {
                        modes = {
                          n = "ga",
                        },
                        index = 1,
                        callback = "keymaps.accept_change",
                        description = "Accept change",
                      },
                      reject_change = {
                        modes = {
                          n = "gr",
                        },
                        index = 2,
                        callback = "keymaps.reject_change",
                        description = "Reject change",
                      },
                    },
                    variables = {
                      ["buffer"] = {
                        callback = "strategies.inline.variables.buffer",
                        description = "Share the current buffer with the LLM",
                        opts = {
                          contains_code = true,
                        },
                      },
                      ["chat"] = {
                        callback = "strategies.inline.variables.chat",
                        description = "Share the currently open chat buffer with the LLM",
                        opts = {
                          contains_code = true,
                        },
                      },
                      ["clipboard"] = {
                        callback = "strategies.inline.variables.clipboard",
                        description = "Share the contents of the clipboard with the LLM",
                        opts = {
                          contains_code = true,
                        },
                      },
                    },
                  },
                  -- CMD STRATEGY -----------------------------------------------------------
                  cmd = {
                    adapter = "gemini",
                    opts = {
                      system_prompt = [[You are currently plugged in to the Neovim text editor on a user's machine. Your core task is to generate an command-line inputs that the user can run within Neovim. Below are some rules to adhere to:

- Return plain text only
- Do not wrap your response in a markdown block or backticks
- Do not use any line breaks or newlines in you response
- Do not provide any explanations
- Generate an command that is valid and can be run in Neovim
- Ensure the command is relevant to the user's request]],
                    },
                  },
                },
                gemini = function()
                  return require('codecompanion.adapters').extend('gemini', {
                    env = {
                      api_key = os.getenv("GEMINI_API_KEY"),
                    },
                    schema = {
                      model = {
                        default = 'gemini-2.5-pro-exp-03-25'
                      }
                    }
                  })
                end,
                opts = {
                  log_level = 'DEBUG',
                },
                display = {
                  diff = {
                    enabled = true,
                    close_chat_at = 240,
                    layout = 'vertical',
                    opts = { 'internal', 'filler', 'closeoff', 'algorithm:patience', 'followwrap', 'linematch:120' },
                    provider = 'default',
                  },
                },
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
            plugin = none-ls-nvim;
          }
          {
            plugin = dashboard-nvim;
          }
        ];
      };
    };
  }
