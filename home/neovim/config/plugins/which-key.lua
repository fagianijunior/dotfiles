-- Which-Key Configuration
-- Requirements: 9.3, 14.3

local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  vim.notify("Which-Key not found!", vim.log.levels.ERROR)
  return
end

which_key.setup({
  preset = "modern",
  
  -- Delay before showing the popup
  delay = 300,
  
  -- Filter function for mappings
  filter = function(mapping)
    return true
  end,
  
  -- Configure the popup window
  win = {
    border = "rounded",
    padding = { 1, 2 },
  },
  
  -- Layout configuration
  layout = {
    width = { min = 20, max = 50 },
    spacing = 3,
  },
  
  -- Key configuration
  keys = {
    scroll_down = "<c-d>",
    scroll_up = "<c-u>",
  },
  
  -- Icons configuration
  icons = {
    breadcrumb = "»",
    separator = "➜",
    group = "+",
    mappings = true,
  },
  
  show_help = true,
  show_keys = true,
  
  -- Disable for certain filetypes
  disable = {
    ft = { "TelescopePrompt" },
  },
})

-- Register keybinding groups with descriptions using new API
-- Requirements: 9.3, 14.3
which_key.add({
  -- Find group
  { "<leader>f", group = "find" },
  { "<leader>ff", desc = "Find files" },
  { "<leader>fg", desc = "Live grep" },
  { "<leader>fb", desc = "Find buffers" },
  { "<leader>fc", desc = "Find commands" },
  { "<leader>fh", desc = "Find help" },
  { "<leader>fk", desc = "Find keymaps" },
  { "<leader>fr", desc = "Find recent files" },
  { "<leader>fw", desc = "Find word under cursor" },
  { "<leader>fd", desc = "Find diagnostics" },
  
  -- Git group
  { "<leader>g", group = "git" },
  { "<leader>gs", desc = "Stage hunk" },
  { "<leader>gu", desc = "Unstage hunk" },
  { "<leader>gr", desc = "Reset hunk" },
  { "<leader>gb", desc = "Blame line" },
  { "<leader>gS", desc = "Stage buffer" },
  { "<leader>gR", desc = "Reset buffer" },
  { "<leader>gp", desc = "Preview hunk" },
  { "<leader>gd", desc = "Diff this" },
  { "<leader>gD", desc = "Diff this ~" },
  { "<leader>gB", desc = "Blame toggle" },
  
  -- LSP group
  { "<leader>l", group = "lsp" },
  { "<leader>ld", desc = "Go to definition" },
  { "<leader>lD", desc = "Go to declaration" },
  { "<leader>lr", desc = "References" },
  { "<leader>li", desc = "Go to implementation" },
  { "<leader>lt", desc = "Type definition" },
  { "<leader>ls", desc = "Document symbols" },
  { "<leader>lw", desc = "Workspace symbols" },
  { "<leader>lf", desc = "Format" },
  { "<leader>la", desc = "Code action" },
  { "<leader>ln", desc = "Rename" },
  { "<leader>lh", desc = "Hover documentation" },
  { "<leader>lk", desc = "Signature help" },
  
  -- Code group
  { "<leader>c", group = "code" },
  { "<leader>cf", desc = "Format" },
  { "<leader>ca", desc = "Code action" },
  { "<leader>cr", desc = "Rename" },
  
  -- Other groups
  { "<leader>e", desc = "File explorer" },
  { "<leader>t", group = "terminal" },
  { "<leader>t1", desc = "Terminal 1" },
  { "<leader>t2", desc = "Terminal 2" },
  { "<leader>t3", desc = "Terminal 3" },
  { "<leader>t4", desc = "Terminal 4" },
  { "<leader>q", desc = "Quit" },
  { "<leader>Q", desc = "Quit all" },
  { "<leader>w", group = "window" },
  { "<leader>b", group = "buffer" },
  
  -- Visual mode git mappings
  { "<leader>g", group = "git", mode = "v" },
  { "<leader>gs", desc = "Stage hunk", mode = "v" },
  { "<leader>gr", desc = "Reset hunk", mode = "v" },
})
