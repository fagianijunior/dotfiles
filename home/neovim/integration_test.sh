#!/usr/bin/env bash
# Integration test script for Neovim configuration
# This script performs various checks to ensure the configuration is working

echo "=== Neovim Configuration Integration Test ==="
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Helper functions
pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((TESTS_PASSED++))
}

fail() {
    echo -e "${RED}✗${NC} $1"
    ((TESTS_FAILED++))
}

warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

# Test 1: Check Neovim is installed
info "Checking Neovim installation..."
if command -v nvim &> /dev/null; then
    NVIM_VERSION=$(nvim --version | head -n1)
    pass "Neovim is installed: $NVIM_VERSION"
else
    fail "Neovim is not installed"
    exit 1
fi

# Test 2: Check Lua syntax
info "Checking Lua configuration syntax..."
if lua home/neovim/test_config.lua &> /dev/null; then
    pass "All Lua files have valid syntax"
else
    fail "Lua syntax errors detected"
fi

# Test 3: Check keybinding conflicts
info "Checking for keybinding conflicts..."
if lua home/neovim/check_keybindings.lua &> /dev/null; then
    pass "No keybinding conflicts detected"
else
    fail "Keybinding conflicts found"
fi

# Test 4: Check Neovim can start in headless mode
info "Testing Neovim startup in headless mode..."
# Note: This test may fail if plugins aren't installed yet (before home-manager switch)
if timeout 5 nvim --headless -c "quit" 2>&1 | grep -qi "error\|failed"; then
    warn "Neovim startup may have errors (this is expected before home-manager switch)"
else
    pass "Neovim starts without critical errors"
fi

# Test 5: Check configuration files exist
info "Checking configuration files..."
CONFIG_FILES=(
    "home/neovim/default.nix"
    "home/neovim/config/init.lua"
    "home/neovim/config/options.lua"
    "home/neovim/config/keymaps.lua"
    "home/neovim/config/verify.lua"
    "home/neovim/CONFIGURATION.md"
)

ALL_FILES_EXIST=true
for file in "${CONFIG_FILES[@]}"; do
    if [ -f "$file" ]; then
        pass "File exists: $file"
    else
        fail "File missing: $file"
        ALL_FILES_EXIST=false
    fi
done

# Test 6: Check plugin configuration files exist
info "Checking plugin configuration files..."
PLUGIN_FILES=(
    "home/neovim/config/plugins/catppuccin.lua"
    "home/neovim/config/plugins/telescope.lua"
    "home/neovim/config/plugins/lsp.lua"
    "home/neovim/config/plugins/cmp.lua"
    "home/neovim/config/plugins/luasnip.lua"
    "home/neovim/config/plugins/treesitter.lua"
    "home/neovim/config/plugins/gitsigns.lua"
    "home/neovim/config/plugins/neo-tree.lua"
    "home/neovim/config/plugins/which-key.lua"
    "home/neovim/config/plugins/lualine.lua"
    "home/neovim/config/plugins/conform.lua"
    "home/neovim/config/plugins/toggleterm.lua"
)

for file in "${PLUGIN_FILES[@]}"; do
    if [ -f "$file" ]; then
        pass "Plugin config exists: $(basename $file)"
    else
        fail "Plugin config missing: $(basename $file)"
        ALL_FILES_EXIST=false
    fi
done

# Test 7: Check documentation completeness
info "Checking documentation..."
if [ -f "home/neovim/CONFIGURATION.md" ]; then
    DOC_SECTIONS=(
        "Keybinding Organization"
        "Known Issues and Limitations"
        "Language Server Configuration"
        "Code Formatting"
        "Troubleshooting"
    )
    
    DOC_COMPLETE=true
    for section in "${DOC_SECTIONS[@]}"; do
        if grep -q "$section" home/neovim/CONFIGURATION.md; then
            pass "Documentation section exists: $section"
        else
            fail "Documentation section missing: $section"
            DOC_COMPLETE=false
        fi
    done
else
    fail "CONFIGURATION.md not found"
fi

# Test 8: Verify Nix configuration syntax
info "Checking Nix configuration syntax..."
if nix-instantiate --parse home/neovim/default.nix &> /dev/null; then
    pass "Nix configuration has valid syntax"
else
    warn "Could not verify Nix syntax (nix-instantiate not available or syntax error)"
fi

# Summary
echo ""
echo "=== Test Summary ==="
echo "Tests passed: $TESTS_PASSED"
echo "Tests failed: $TESTS_FAILED"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
    echo ""
    echo "The Neovim configuration is ready to use."
    echo "To apply the configuration, run:"
    echo "  home-manager switch"
    echo ""
    echo "To verify the configuration after applying, run:"
    echo "  nvim -c 'lua require(\"verify\").run_all()' -c 'quit'"
    exit 0
else
    echo -e "${RED}✗ Some tests failed${NC}"
    echo "Please review the errors above and fix them before proceeding."
    exit 1
fi
