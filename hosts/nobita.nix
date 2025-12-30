{
  imports = [
    ../modules/base/locale.nix
    ../modules/base/networking-iwd.nix

    ../modules/hardware/amd-common.nix
    ../modules/hardware/graphics-amd.nix

    ../modules/desktop/session.nix
    ../modules/desktop/hyprland.nix
    ../modules/desktop/pipewire.nix

    ../modules/profiles/desktop.nix
  ];

  networking.hostName = "nobita";
  console.keyMap = "us";
}
