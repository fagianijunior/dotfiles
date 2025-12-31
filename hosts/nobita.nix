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
  ];

  networking.hostName = "nobita";
  console.keyMap = "us";

  services.xserver = {
    xkb = {
      layout = "us";
      variant = "intl";
    };
  };

  system.stateVersion = "25.11";
}
