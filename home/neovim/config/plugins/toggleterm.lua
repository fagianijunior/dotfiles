-- Toggleterm Configuration
-- Requirements: 12.1, 12.3, 12.4

local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
  vim.notify("toggleterm not found!", vim.log.levels.ERROR)
  return
end

toggleterm.setup({
  -- Size of the terminal
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  
  -- Open terminal in insert mode
  open_mapping = [[<C-\>]],
  
  -- Hide the number column in terminal buffers
  hide_numbers = true,
  
  -- Shade the terminal background
  shade_terminals = true,
  shading_factor = 2,
  
  -- Start terminal in insert mode
  start_in_insert = true,
  
  -- Close terminal on process exit
  close_on_exit = true,
  
  -- Shell to use
  shell = vim.o.shell,
  
  -- Persist terminal size
  persist_size = true,
  
  -- Persist terminal mode
  persist_mode = true,
  
  -- Direction of the terminal
  direction = 'float',
  
  -- Floating terminal configuration
  float_opts = {
    border = 'curved',
    width = math.floor(vim.o.columns * 0.8),
    height = math.floor(vim.o.lines * 0.8),
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal",
    }
  },
  
  -- Highlight groups for terminal
  highlights = {
    Normal = {
      link = 'Normal'
    },
    NormalFloat = {
      link = 'NormalFloat'
    },
    FloatBorder = {
      link = 'FloatBorder'
    },
  },
})

-- Keybindings for multiple terminal instances
-- Requirements: 12.3, 12.4
local Terminal = require('toggleterm.terminal').Terminal

-- Create specific terminal instances
local terminals = {}

-- Function to get or create a terminal
local function get_terminal(id)
  if not terminals[id] then
    terminals[id] = Terminal:new({
      count = id,
      direction = "float",
      hidden = true,
    })
  end
  return terminals[id]
end

-- Toggle specific terminal instances
vim.keymap.set('n', '<leader>t1', function()
  get_terminal(1):toggle()
end, { desc = "Toggle terminal 1", noremap = true, silent = true })

vim.keymap.set('n', '<leader>t2', function()
  get_terminal(2):toggle()
end, { desc = "Toggle terminal 2", noremap = true, silent = true })

vim.keymap.set('n', '<leader>t3', function()
  get_terminal(3):toggle()
end, { desc = "Toggle terminal 3", noremap = true, silent = true })

vim.keymap.set('n', '<leader>t4', function()
  get_terminal(4):toggle()
end, { desc = "Toggle terminal 4", noremap = true, silent = true })

-- Terminal mode keybindings
-- Make it easier to escape terminal mode
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = "Exit terminal mode", noremap = true, silent = true })
vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], { desc = "Navigate left from terminal", noremap = true, silent = true })
vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], { desc = "Navigate down from terminal", noremap = true, silent = true })
vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], { desc = "Navigate up from terminal", noremap = true, silent = true })
vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], { desc = "Navigate right from terminal", noremap = true, silent = true })
