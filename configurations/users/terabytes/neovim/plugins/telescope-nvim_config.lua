require('telescope').setup({
  pickers = {
    buffers = {
      show_all_buffers = true,
      sort_mru = true,
      mappings = {
        i = {
          ["<c-d>"] = "delete_buffer",
	},
      },
      find_files = {
        find_command = { 'rg', '--files', '--hidden' },
      },
    },
  },
})
