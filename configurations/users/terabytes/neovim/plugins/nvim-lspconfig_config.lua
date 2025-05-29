local lspconfig = require('lspconfig')
local cmp = require('cmp') -- Assuming nvim-cmp is installed for capabilities

-- Function to set up common keymaps for LSP
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o> in insert mode.
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings. Use in nvim_buf_set_keymap instead of vim.keymap.set
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', function()
        vim.lsp.buf.format { async = true }
    end, bufopts)

    -- Set up formatting on save (optional, could use null-ls instead)
    -- if client.supports_method("textDocument/formatting") then
    --     vim.api.nvim_create_autocmd("BufWritePre", {
    --         group = vim.api.nvim_create_augroup("LspFormatting." .. bufnr, { clear = true }),
    --         buffer = bufnr,
    --         callback = function()
    --             vim.lsp.buf.format { async = true }
    --         end,
    --     })
    -- end
end

-- Capabilities (integrating with nvim-cmp)
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- Check if cmp_nvim_lsp is available before merging capabilities
if pcall(require, 'cmp_nvim_lsp') then
  capabilities = require('cmp_nvim_lsp').default_capabilities()
end


-- Configure diagnostics display
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

-- Set up keymaps for navigating diagnostics
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Setup language servers
-- Examples based on your neovim.nix file
lspconfig.nil_ls.setup({ -- Nix LSP
    on_attach = on_attach,
    capabilities = capabilities,
})

lspconfig.pyright.setup({ -- Python LSP
    on_attach = on_attach,
    capabilities = capabilities,
})
local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup({ -- Lua LSP (often configured via sumneko-lua-language-server)
    on_attach = on_attach,
    capabilities = capabilities,
    settings = { -- Optional: Customize Lua LSP settings
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
})

-- Add more language servers as needed.
-- You'll need the corresponding LSP server installed on your system.
-- lspconfig.rust_analyzer.setup({ on_attach = on_attach, capabilities = capabilities })
-- lspconfig.tsserver.setup({ on_attach = on_attach, capabilities = capabilities })
-- lspconfig.html.setup({ on_attach = on_attach, capabilities = capabilities })
-- lspconfig.cssls.setup({ on_attach = on_attach, capabilities = capabilities })
-- lspconfig.jsonls.setup({ on_attach = on_attach, capabilities = capabilities })
-- lspconfig.yamlls.setup({ on_attach = on_attach, capabilities = capabilities })

-- Optional: Autocommand to enable format on save if you don't use null-ls for formatting
-- vim.api.nvim_create_autocmd('BufWritePost', {
--   callback = function()
--     vim.lsp.buf.format({ async = true })
--   end,
-- })

