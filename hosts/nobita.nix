{
  imports = [
    ./nobita-hardware.nix

    ../modules/base

    ../modules/hardware/amd-common.nix
    ../modules/hardware/graphics-amd.nix

    ../modules/desktop/session.nix
    ../modules/desktop/hyprland.nix
    ../modules/desktop/pipewire.nix

    ../modules/profiles/nobita.nix
    ../modules/profiles/workstation.nix
    ../modules/profiles/bluetooth.nix
    ../modules/profiles/logitech.nix
  ];

  networking.hostName = "nobita";

  services.xserver = {
    xkb = {
      layout = "us,br";
      variant = ",abnt2";
    };
  };

  system.stateVersion = "25.11";
}
