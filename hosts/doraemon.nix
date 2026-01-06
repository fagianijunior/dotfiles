{
  imports = [
    ./doraemon-hardware.nix

    ../modules/base

    ./quirks/resume-keyboard.nix

    ../modules/hardware/amd-common.nix
    ../modules/hardware/graphics-amd.nix

    ../modules/desktop/session.nix
    ../modules/desktop/hyprland.nix
    ../modules/desktop/pipewire.nix

    ../modules/profiles/doraemon.nix
    ../modules/profiles/workstation.nix
    ../modules/profiles/development.nix
    ../modules/profiles/multimedia.nix
    ../modules/profiles/utilities.nix
    ../modules/profiles/bluetooth.nix
    ../modules/profiles/logitech.nix
  ];

  networking.hostName = "doraemon";

  system.stateVersion = "25.11";
}
