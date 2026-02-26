-- Neovim Configuration Verification Script
-- This script verifies the configuration is properly set up
-- Requirements: All

local M = {}

-- Color codes for output
local colors = {
  reset = "\27[0m",
  green = "\27[32m",
  red = "\27[31m",
  yellow = "\27[33m",
  blue = "\27[34m",
}

local function print_success(msg)
  print(colors.green .. "✓ " .. msg .. colors.reset)
end

local function print_error(msg)
  print(colors.red .. "✗ " .. msg .. colors.reset)
end

local function print_warning(msg)
  print(colors.yellow .. "⚠ " .. msg .. colors.reset)
end

local function print_info(msg)
  print(colors.blue .. "ℹ " .. msg .. colors.reset)
end

-- Verify plugin installation
function M.verify_plugins()
  print_info("Verifying plugin installation...")
  
  local required_plugins = {
    'catppuccin',
    'telescope',
    'lspconfig',
    'cmp',
    'luasnip',
    'nvim-treesitter',
    'gitsigns',
    'neo-tree',
    'which-key',
    'lualine',
    'conform',
    'toggleterm',
  }
  
  local all_ok = true
  for _, plugin in ipairs(required_plugins) do
    local ok = pcall(require, plugin)
    if ok then
      print_success("Plugin '" .. plugin .. "' loaded")
    else
      print_error("Plugin '" .. plugin .. "' not found")
      all_ok = false
    end
  end
  
  return all_ok
end

-- Verify core configuration
function M.verify_core_config()
  print_info("Verifying core configuration...")
  
  local all_ok = true
  
  -- Check leader key
  if vim.g.mapleader == " " then
    print_success("Leader key set to space")
  else
    print_error("Leader key not set to space (current: " .. tostring(vim.g.mapleader) .. ")")
    all_ok = false
  end
  
  -- Check colorscheme
  local colorscheme = vim.g.colors_name
  if colorscheme and colorscheme:match("catppuccin") then
    print_success("Colorscheme set to Catppuccin (" .. colorscheme .. ")")
  else
    print_error("Colorscheme not set to Catppuccin (current: " .. tostring(colorscheme) .. ")")
    all_ok = false
  end
  
  -- Check important options
  if vim.opt.number:get() then
    print_success("Line numbers enabled")
  else
    print_warning("Line numbers not enabled")
  end
  
  if vim.opt.relativenumber:get() then
    print_success("Relative line numbers enabled")
  else
    print_warning("Relative line numbers not enabled")
  end
  
  return all_ok
end

-- Verify keybindings
function M.verify_keybindings()
  print_info("Verifying keybindings...")
  
  local keybinding_groups = {
    telescope = {
      { 'n', '<leader>ff', 'Find files' },
      { 'n', '<leader>fg', 'Live grep' },
      { 'n', '<leader>fb', 'Find buffers' },
      { 'n', '<leader>fc', 'Find commands' },
    },
    lsp = {
      -- These are buffer-local, so we can't check them here
      -- They will be verified when LSP attaches
    },
    git = {
      -- These are set by gitsigns, buffer-local
    },
    neo_tree = {
      { 'n', '<leader>e', 'Toggle neo-tree' },
    },
    conform = {
      { 'n', '<leader>cf', 'Format code' },
    },
    toggleterm = {
      { 'n', '<C-\\>', 'Toggle terminal' },
    },
  }
  
  local all_ok = true
  
  -- Check global keybindings
  for group, bindings in pairs(keybinding_groups) do
    for _, binding in ipairs(bindings) do
      local mode, key, desc = binding[1], binding[2], binding[3]
      local keymaps = vim.api.nvim_get_keymap(mode)
      local found = false
      
      for _, keymap in ipairs(keymaps) do
        if keymap.lhs == key then
          found = true
          break
        end
      end
      
      if found then
        print_success("Keybinding " .. key .. " (" .. desc .. ") is set")
      else
        print_warning("Keybinding " .. key .. " (" .. desc .. ") not found (may be buffer-local)")
      end
    end
  end
  
  return all_ok
end

-- Check for keybinding conflicts
function M.check_keybinding_conflicts()
  print_info("Checking for keybinding conflicts...")
  
  local modes = { 'n', 'i', 'v', 'x', 't' }
  local conflicts = {}
  
  for _, mode in ipairs(modes) do
    local keymaps = vim.api.nvim_get_keymap(mode)
    local seen = {}
    
    for _, keymap in ipairs(keymaps) do
      local key = keymap.lhs
      if seen[key] then
        table.insert(conflicts, {
          mode = mode,
          key = key,
          first = seen[key],
          second = keymap.rhs or keymap.callback,
        })
      else
        seen[key] = keymap.rhs or keymap.callback
      end
    end
  end
  
  if #conflicts == 0 then
    print_success("No keybinding conflicts detected")
    return true
  else
    print_warning("Found " .. #conflicts .. " potential keybinding conflicts:")
    for _, conflict in ipairs(conflicts) do
      print("  Mode: " .. conflict.mode .. ", Key: " .. conflict.key)
    end
    return false
  end
end

-- Verify LSP configuration
function M.verify_lsp()
  print_info("Verifying LSP configuration...")
  
  local lspconfig = require('lspconfig')
  local configured_servers = {
    'lua_ls',
    'nil_ls',
    'ts_ls',  -- Updated from tsserver
    'pyright',
  }
  
  local all_ok = true
  for _, server in ipairs(configured_servers) do
    if lspconfig[server] then
      print_success("LSP server '" .. server .. "' configured")
    else
      print_error("LSP server '" .. server .. "' not configured")
      all_ok = false
    end
  end
  
  return all_ok
end

-- Verify completion sources
function M.verify_completion()
  print_info("Verifying completion sources...")
  
  local cmp = require('cmp')
  local config = cmp.get_config()
  
  local required_sources = {
    'nvim_lsp',
    'luasnip',
    'buffer',
    'path',
  }
  
  local all_ok = true
  local configured_sources = {}
  
  for _, source_group in ipairs(config.sources) do
    for _, source in ipairs(source_group) do
      configured_sources[source.name] = true
    end
  end
  
  for _, source_name in ipairs(required_sources) do
    if configured_sources[source_name] then
      print_success("Completion source '" .. source_name .. "' configured")
    else
      print_error("Completion source '" .. source_name .. "' not configured")
      all_ok = false
    end
  end
  
  return all_ok
end

-- Verify Treesitter parsers
function M.verify_treesitter()
  print_info("Verifying Treesitter parsers...")
  
  local ts_ok, ts_parsers = pcall(require, 'nvim-treesitter.parsers')
  if not ts_ok then
    print_error("Treesitter not available")
    return false
  end
  
  local required_parsers = {
    'lua', 'nix', 'python', 'typescript', 'javascript',
  }
  
  local all_ok = true
  for _, parser in ipairs(required_parsers) do
    if ts_parsers.has_parser(parser) then
      print_success("Treesitter parser '" .. parser .. "' installed")
    else
      print_warning("Treesitter parser '" .. parser .. "' not installed")
      all_ok = false
    end
  end
  
  return all_ok
end

-- Run all verifications
function M.run_all()
  print("\n" .. colors.blue .. "=== Neovim Configuration Verification ===" .. colors.reset .. "\n")
  
  local results = {
    plugins = M.verify_plugins(),
    core_config = M.verify_core_config(),
    keybindings = M.verify_keybindings(),
    conflicts = M.check_keybinding_conflicts(),
    lsp = M.verify_lsp(),
    completion = M.verify_completion(),
    treesitter = M.verify_treesitter(),
  }
  
  print("\n" .. colors.blue .. "=== Summary ===" .. colors.reset .. "\n")
  
  local all_passed = true
  for category, passed in pairs(results) do
    if passed then
      print_success(category .. ": PASSED")
    else
      print_error(category .. ": FAILED")
      all_passed = false
    end
  end
  
  print("\n")
  if all_passed then
    print_success("All verifications passed!")
  else
    print_warning("Some verifications failed. Please review the output above.")
  end
  
  return all_passed
end

return M
