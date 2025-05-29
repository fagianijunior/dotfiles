  -- mostly stolen from rafaelrc7's dotfile
  local lspconfig = require "lspconfig"
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  -- nix
  lspconfig.nil_ls.setup{
    cmd = { "__NIL_LS_PATH__" },
    capabilities = capabilities,
  };

  -- html
  capabilities.textDocument.completion.completionItem.snippetSupport = true;
  lspconfig.html.setup {
    cmd = {"__LANGSERVER_EXTRACTED_PATH__/bin/vscode-html-language-server", "--stdio"},
    capabilities = capabilities,
  };

  -- CSS
  lspconfig.cssls.setup {
    cmd = {"__LANGSERVER_EXTRACTED_PATH__/bin/vscode-css-language-server", "--stdio"},
    capabilities = capabilities,
  };

  -- Json
lspconfig.jsonls.setup {
  cmd = {"__LANGSERVER_EXTRACTED_PATH__/bin/vscode-json-language-server", "--stdio"},
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
  cmd = {"__PYRIGHT_PATH__/bin/pyright-langserver", "--stdio"},
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
  cmd = {"__SUMNEKO_LUA_LANGUAGE_SERVER_PATH__/bin/lua-language-server"},
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
  cmd = { "__TERRAFORM_LS_PATH__/bin/terraform-ls", "serve" },
  capabilities = capabilities,
}

-- Ruby
lspconfig.ruby_lsp.setup {
  cmd = { "__RUBY_LSP_PATH__/bin/ruby-lsp" },
  capabilities = capabilities,
}

