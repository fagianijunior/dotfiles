{
  imports = [
    ./nobita-hardware.nix

    ../modules/base

    ../modules/hardware/amd-common.nix
    ../modules/hardware/graphics-amd.nix
    ../modules/hardware/rocm.nix
    ../modules/hardware/power-management.nix

    ../modules/desktop/session.nix
    ../modules/desktop/hyprland.nix
    ../modules/desktop/pipewire.nix

    ../modules/profiles/nobita.nix
    ../modules/profiles/workstation.nix
    ../modules/profiles/development.nix
    ../modules/profiles/multimedia.nix
    ../modules/profiles/utilities.nix
    ../modules/profiles/bluetooth.nix
    ../modules/profiles/logitech.nix
  ];

  # Enable ROCm support for RX 6600 GPU
  hardware.rocm.enable = true;

  networking.hostName = "nobita";

  system.stateVersion = "25.11";
}
