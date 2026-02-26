-- Neovim Options Configuration
-- Requirements: 1.2

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.cursorline = true
opt.wrap = false

-- Behavior
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.undofile = true
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300

-- Scrolling
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Command-line completion
opt.wildmenu = true  -- Enhanced command-line completion
opt.wildmode = "longest:full,full"  -- Complete longest common string, then full match
opt.wildoptions = "pum"  -- Show completion matches in a popup menu
opt.pumheight = 10  -- Maximum number of items in popup menu
opt.pumblend = 10  -- Popup menu transparency (0-100)
