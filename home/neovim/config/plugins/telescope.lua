-- Telescope Configuration
-- Requirements: 2.1, 2.4

local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  vim.notify("Telescope not found!", vim.log.levels.ERROR)
  return
end

local actions = require("telescope.actions")

telescope.setup({
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { "truncate" },
    
    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
        
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        
        ["<C-c>"] = actions.close,
        
        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,
        
        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
        
        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,
        
        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,
        
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-l>"] = actions.complete_tag,
        ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
      },
      
      n = {
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
        
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        
        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["H"] = actions.move_to_top,
        ["M"] = actions.move_to_middle,
        ["L"] = actions.move_to_bottom,
        
        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,
        
        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,
        
        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,
        
        ["?"] = actions.which_key,
      },
    },
  },
  
  pickers = {
    -- File finder configuration
    find_files = {
      theme = "dropdown",
      previewer = false,
      hidden = true,
      find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
    },
    
    -- Live grep configuration
    live_grep = {
      theme = "ivy",
    },
    
    -- Buffer configuration
    buffers = {
      theme = "dropdown",
      previewer = false,
      initial_mode = "normal",
      mappings = {
        i = {
          ["<C-d>"] = actions.delete_buffer,
        },
        n = {
          ["dd"] = actions.delete_buffer,
        },
      },
    },
    
    -- Command palette configuration
    commands = {
      theme = "ivy",
    },
  },
  
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})

-- Load telescope extensions
pcall(telescope.load_extension, "fzf")

-- Keybindings for Telescope
-- Requirements: 2.1, 2.4
local keymap = vim.keymap.set
local builtin = require("telescope.builtin")

-- Find files
keymap("n", "<leader>ff", builtin.find_files, { desc = "Find files" })

-- Live grep (search in files)
keymap("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })

-- Find buffers
keymap("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })

-- Find commands
keymap("n", "<leader>fc", builtin.commands, { desc = "Find commands" })

-- Additional useful telescope commands
keymap("n", "<leader>fh", builtin.help_tags, { desc = "Find help" })
keymap("n", "<leader>fk", builtin.keymaps, { desc = "Find keymaps" })
keymap("n", "<leader>fr", builtin.oldfiles, { desc = "Find recent files" })
keymap("n", "<leader>fw", builtin.grep_string, { desc = "Find word under cursor" })
keymap("n", "<leader>fd", builtin.diagnostics, { desc = "Find diagnostics" })

