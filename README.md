On first time, after insallation execute this

# Change the file ~/.config/nix/nix.conf to enable flake experimental feature:
# experimental-features = nix-command flakes

# $ sudo systemctl restart nix-daemon

sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --impure --flake .#nobita



# Upgrade
nix-env -f channel:nixos-unstable -u
nix flake --extra-experimental-features 'nix-command flakes' update
nixos-rebuild build --flake .#nobita
nix store --extra-experimental-features 'nix-command flakes' diff-closures /run/current-system /home/terabytes/Workspace/fagianijunior/dotfiles/result
sudo nixos-rebuild switch --flake .#nobita
