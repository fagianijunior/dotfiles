-- Keybinding Conflict Checker
-- This script analyzes all keybindings defined in the configuration
-- and checks for potential conflicts

local function extract_keybindings_from_file(filepath)
  local f = io.open(filepath, "r")
  if not f then
    return {}
  end
  
  local content = f:read("*all")
  f:close()
  
  local keybindings = {}
  
  -- Pattern 1: vim.keymap.set("mode", "key", ...)
  for mode, key in content:gmatch('vim%.keymap%.set%s*%(%s*["\']([^"\']+)["\']%s*,%s*["\']([^"\']+)["\']') do
    table.insert(keybindings, {
      mode = mode,
      key = key,
      file = filepath,
    })
  end
  
  -- Pattern 2: keymap("mode", "key", ...)
  for mode, key in content:gmatch('keymap%s*%(%s*["\']([^"\']+)["\']%s*,%s*["\']([^"\']+)["\']') do
    table.insert(keybindings, {
      mode = mode,
      key = key,
      file = filepath,
    })
  end
  
  return keybindings
end

local function check_conflicts()
  print("=== Keybinding Conflict Analysis ===\n")
  
  local files = {
    'home/neovim/config/keymaps.lua',
    'home/neovim/config/plugins/telescope.lua',
    'home/neovim/config/plugins/lsp.lua',
    'home/neovim/config/plugins/gitsigns.lua',
    'home/neovim/config/plugins/neo-tree.lua',
    'home/neovim/config/plugins/conform.lua',
    'home/neovim/config/plugins/toggleterm.lua',
  }
  
  local all_keybindings = {}
  
  -- Extract all keybindings
  for _, file in ipairs(files) do
    local bindings = extract_keybindings_from_file(file)
    for _, binding in ipairs(bindings) do
      table.insert(all_keybindings, binding)
    end
  end
  
  print("Total keybindings found: " .. #all_keybindings .. "\n")
  
  -- Group by mode and key
  local grouped = {}
  for _, binding in ipairs(all_keybindings) do
    local key = binding.mode .. ":" .. binding.key
    if not grouped[key] then
      grouped[key] = {}
    end
    table.insert(grouped[key], binding)
  end
  
  -- Check for conflicts
  local conflicts = {}
  for key, bindings in pairs(grouped) do
    if #bindings > 1 then
      table.insert(conflicts, {
        key = key,
        bindings = bindings,
      })
    end
  end
  
  if #conflicts == 0 then
    print("✓ No keybinding conflicts detected!\n")
  else
    print("⚠ Found " .. #conflicts .. " potential conflicts:\n")
    for _, conflict in ipairs(conflicts) do
      print("Conflict: " .. conflict.key)
      for _, binding in ipairs(conflict.bindings) do
        print("  - " .. binding.file)
      end
      print()
    end
  end
  
  -- Print keybinding summary by prefix
  print("\n=== Keybinding Summary by Prefix ===\n")
  
  local prefixes = {}
  for _, binding in ipairs(all_keybindings) do
    if binding.mode == "n" and binding.key:match("^<leader>") then
      local prefix = binding.key:match("^<leader>(%w)")
      if prefix then
        if not prefixes[prefix] then
          prefixes[prefix] = {}
        end
        table.insert(prefixes[prefix], binding.key)
      end
    end
  end
  
  local sorted_prefixes = {}
  for prefix, _ in pairs(prefixes) do
    table.insert(sorted_prefixes, prefix)
  end
  table.sort(sorted_prefixes)
  
  for _, prefix in ipairs(sorted_prefixes) do
    print("<leader>" .. prefix .. " (" .. #prefixes[prefix] .. " bindings)")
    table.sort(prefixes[prefix])
    for _, key in ipairs(prefixes[prefix]) do
      print("  " .. key)
    end
    print()
  end
  
  return #conflicts == 0
end

-- Run the check
local ok = check_conflicts()
os.exit(ok and 0 or 1)
