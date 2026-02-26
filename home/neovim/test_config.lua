-- Test script to verify Neovim configuration loads without errors
-- This script simulates loading the configuration and reports any issues

local function test_lua_syntax()
  print("Testing Lua configuration syntax...")
  
  local config_files = {
    'home/neovim/config/init.lua',
    'home/neovim/config/options.lua',
    'home/neovim/config/keymaps.lua',
    'home/neovim/config/verify.lua',
  }
  
  local plugin_files = {
    'home/neovim/config/plugins/catppuccin.lua',
    'home/neovim/config/plugins/telescope.lua',
    'home/neovim/config/plugins/lsp.lua',
    'home/neovim/config/plugins/cmp.lua',
    'home/neovim/config/plugins/luasnip.lua',
    'home/neovim/config/plugins/treesitter.lua',
    'home/neovim/config/plugins/gitsigns.lua',
    'home/neovim/config/plugins/neo-tree.lua',
    'home/neovim/config/plugins/which-key.lua',
    'home/neovim/config/plugins/lualine.lua',
    'home/neovim/config/plugins/conform.lua',
    'home/neovim/config/plugins/toggleterm.lua',
  }
  
  local all_files = {}
  for _, f in ipairs(config_files) do table.insert(all_files, f) end
  for _, f in ipairs(plugin_files) do table.insert(all_files, f) end
  
  local errors = {}
  for _, file in ipairs(all_files) do
    local f = io.open(file, "r")
    if f then
      local content = f:read("*all")
      f:close()
      
      local func, err = load(content, file)
      if not func then
        table.insert(errors, {file = file, error = err})
        print("✗ " .. file .. ": SYNTAX ERROR")
        print("  " .. err)
      else
        print("✓ " .. file .. ": OK")
      end
    else
      table.insert(errors, {file = file, error = "File not found"})
      print("✗ " .. file .. ": NOT FOUND")
    end
  end
  
  return #errors == 0, errors
end

local function check_keybinding_documentation()
  print("\nChecking keybinding documentation...")
  
  -- Read the documentation file
  local f = io.open("home/neovim/CONFIGURATION.md", "r")
  if not f then
    print("✗ CONFIGURATION.md not found")
    return false
  end
  
  local content = f:read("*all")
  f:close()
  
  -- Check for key sections
  local required_sections = {
    "Keybinding Organization",
    "Known Issues and Limitations",
    "Language Server Configuration",
    "Code Formatting",
    "Troubleshooting",
  }
  
  local all_ok = true
  for _, section in ipairs(required_sections) do
    if content:find(section, 1, true) then
      print("✓ Section '" .. section .. "' found")
    else
      print("✗ Section '" .. section .. "' missing")
      all_ok = false
    end
  end
  
  return all_ok
end

local function check_plugin_loading_order()
  print("\nChecking plugin loading order in init.lua...")
  
  local f = io.open("home/neovim/config/init.lua", "r")
  if not f then
    print("✗ init.lua not found")
    return false
  end
  
  local content = f:read("*all")
  f:close()
  
  -- Check that catppuccin is loaded first (before other plugins)
  local catppuccin_pos = content:find("require%('plugins%.catppuccin'%)")
  local telescope_pos = content:find("require%('plugins%.telescope'%)")
  
  if catppuccin_pos and telescope_pos and catppuccin_pos < telescope_pos then
    print("✓ Catppuccin loaded before other plugins")
  else
    print("✗ Plugin loading order incorrect")
    return false
  end
  
  -- Check that luasnip is loaded before cmp
  local luasnip_pos = content:find("require%('plugins%.luasnip'%)")
  local cmp_pos = content:find("require%('plugins%.cmp'%)")
  
  if luasnip_pos and cmp_pos and luasnip_pos < cmp_pos then
    print("✓ LuaSnip loaded before nvim-cmp")
  else
    print("✗ LuaSnip should be loaded before nvim-cmp")
    return false
  end
  
  return true
end

-- Run all tests
print("=== Neovim Configuration Test Suite ===\n")

local syntax_ok, syntax_errors = test_lua_syntax()
local doc_ok = check_keybinding_documentation()
local order_ok = check_plugin_loading_order()

print("\n=== Test Summary ===")
print("Lua Syntax: " .. (syntax_ok and "PASS" or "FAIL"))
print("Documentation: " .. (doc_ok and "PASS" or "FAIL"))
print("Plugin Loading Order: " .. (order_ok and "PASS" or "FAIL"))

if syntax_ok and doc_ok and order_ok then
  print("\n✓ All tests passed!")
  os.exit(0)
else
  print("\n✗ Some tests failed")
  os.exit(1)
end
