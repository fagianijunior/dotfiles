#!/usr/bin/env bash
# Verify that all Nix packages referenced in default.nix exist

set -e

echo "=== Verifying Nix Package References ==="
echo ""

# Extract plugin names from default.nix
PLUGINS=$(grep -E '^\s+[a-zA-Z0-9_-]+\s*(#.*)?$' home/neovim/default.nix | \
          grep -v '^\s*#' | \
          sed 's/^\s*//' | \
          sed 's/\s*#.*//' | \
          grep -v '^$')

echo "Checking vimPlugins..."
FAILED=0

while IFS= read -r plugin; do
    if [ -z "$plugin" ]; then
        continue
    fi
    
    # Skip lines that are not plugin names
    if [[ "$plugin" =~ ^(with|plugins|extraPackages|\[|\]|\(|\)|formatters_by_ft) ]]; then
        continue
    fi
    
    # Check if it's a vim plugin
    if nix eval "nixpkgs#vimPlugins.$plugin.pname" &> /dev/null; then
        echo "✓ vimPlugins.$plugin exists"
    else
        echo "✗ vimPlugins.$plugin NOT FOUND"
        FAILED=1
    fi
done <<< "$PLUGINS"

echo ""
if [ $FAILED -eq 0 ]; then
    echo "✓ All vim plugins verified"
    exit 0
else
    echo "✗ Some vim plugins not found"
    exit 1
fi
