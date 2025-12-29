{ config, pkgs, lib, catppucin-flavor, ... }:

{
  imports  = [
    ./pyprland.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;

    settings = lib.mkMerge [
      (import ./variables.nix)
      (import ./general.nix)
      (import ./monitors.nix)
      (import ./keybinds.nix)
      (import ./autostart.nix)
      (import ./rules.nix)
      (import ./decorations.nix)
    ];
  };
}