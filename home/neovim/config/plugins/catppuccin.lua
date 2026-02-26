-- Catppuccin Theme Configuration
-- Requirements: 13.1, 13.4

local status_ok, catppuccin = pcall(require, "catppuccin")
if not status_ok then
  vim.notify("Catppuccin not found!", vim.log.levels.ERROR)
  return
end

catppuccin.setup({
  flavour = "macchiato", -- latte, frappe, macchiato, mocha
  background = {
    light = "latte",
    dark = "macchiato",
  },
  transparent_background = false,
  show_end_of_buffer = false,
  term_colors = true,
  dim_inactive = {
    enabled = false,
    shade = "dark",
    percentage = 0.15,
  },
  no_italic = false,
  no_bold = false,
  no_underline = false,
  styles = {
    comments = { "italic" },
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  color_overrides = {},
  custom_highlights = {},
  integrations = {
    -- Core integrations
    cmp = true,
    gitsigns = true,
    nvimtree = false,
    treesitter = true,
    notify = false,
    mini = {
      enabled = false,
      indentscope_color = "",
    },
    
    -- Plugin integrations
    telescope = {
      enabled = true,
      style = "nvchad",
    },
    lsp_trouble = false,
    which_key = true,
    
    -- Additional integrations
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { "italic" },
        hints = { "italic" },
        warnings = { "italic" },
        information = { "italic" },
      },
      underlines = {
        errors = { "underline" },
        hints = { "underline" },
        warnings = { "underline" },
        information = { "underline" },
      },
      inlay_hints = {
        background = true,
      },
    },
    
    -- Neo-tree integration
    neotree = true,
    
    -- Other integrations that might be useful
    dap = false,
    dap_ui = false,
    indent_blankline = {
      enabled = false,
      scope_color = "",
      colored_indent_levels = false,
    },
    markdown = true,
    mason = false,
    semantic_tokens = true,
  },
})

-- Set the colorscheme
vim.cmd.colorscheme("catppuccin-macchiato")
