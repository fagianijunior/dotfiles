-- LuaSnip Configuration
-- Requirements: 5.3, 5.4

local luasnip = require('luasnip')

-- Configure LuaSnip options
luasnip.config.set_config({
  -- Remember the last snippet to allow jumping back into it
  history = true,
  
  -- Update snippets as you type
  updateevents = "TextChanged,TextChangedI",
  
  -- Enable autotriggered snippets
  enable_autosnippets = true,
  
  -- Use treesitter for better snippet parsing (when available)
  ext_opts = {
    [require("luasnip.util.types").choiceNode] = {
      active = {
        virt_text = { { "●", "GruvboxOrange" } },
      },
    },
  },
})

-- Load friendly-snippets
-- Requirements: 5.4
require("luasnip.loaders.from_vscode").lazy_load()

-- Keybindings for snippet navigation
-- Requirements: 5.3 (C-k for forward, C-j for backward)
vim.keymap.set({"i", "s"}, "<C-k>", function()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  end
end, { silent = true, desc = "Expand snippet or jump to next placeholder" })

vim.keymap.set({"i", "s"}, "<C-j>", function()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  end
end, { silent = true, desc = "Jump to previous snippet placeholder" })

-- Additional useful keybinding for changing choice nodes
vim.keymap.set({"i", "s"}, "<C-l>", function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end, { silent = true, desc = "Cycle through snippet choices" })
