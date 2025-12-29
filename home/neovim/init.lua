-- sane defaults
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

-- leader
vim.g.mapleader = " "

-- which-key
require("which-key").setup()

-- lualine
require("lualine").setup {
  options = {
    theme = "auto",
    section_separators = "",
    component_separators = "",
  }
}

-- telescope
require("telescope").setup()
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")

-- treesitter
require("nvim-treesitter.configs").setup {
  highlight = { enable = true },
  indent = { enable = true },
}

-- comment
require("Comment").setup()

-- surround
require("nvim-surround").setup()

-- LSP
local lspconfig = require("lspconfig")

local servers = {
  "nil_ls",
  "lua_ls",
  "tsserver",
  "bashls",
}

for _, server in ipairs(servers) do
  lspconfig[server].setup {}
end

-- completion
local cmp = require("cmp")

cmp.setup {
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm { select = true },
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
}

