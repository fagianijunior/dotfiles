-- conform.nvim - Code formatting
-- Provides automatic and manual code formatting with multiple formatters

local conform = require("conform")

conform.setup({
  -- Map formatters to filetypes
  formatters_by_ft = {
    -- Web development
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    yaml = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    markdown = { "prettier" },
    
    -- Systems programming
    lua = { "stylua" },
    nix = { "nixpkgs_fmt" },
    python = { "black" },
    rust = { "rustfmt" },
    -- go = { "gofmt" },  -- Uncomment if you have Go installed
  },
  
  -- Format on save
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
})

-- Manual format keybinding
vim.keymap.set({ "n", "v" }, "<leader>cf", function()
  conform.format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 500,
  })
end, { desc = "Format file or range (in visual mode)" })
