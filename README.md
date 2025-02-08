On first time, after insallation execute this

# Change the file ~/.config/nix/nix.conf to enable flake experimental feature:
# experimental-features = nix-command flakes

# $ sudo systemctl restart nix-daemon

sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --impure --flake .#nobita
