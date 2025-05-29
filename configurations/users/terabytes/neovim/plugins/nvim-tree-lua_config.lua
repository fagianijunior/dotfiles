-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- set termguicolors to enable highlight groups
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
    dotfiles = false
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
