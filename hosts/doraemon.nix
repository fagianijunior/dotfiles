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
    ../modules/profiles/bluetooth.nix
    ../modules/profiles/logitech.nix

    ../modules/base/users.nix

    ../modules/profiles/doraemon.nix
  ];

  networking.hostName = "doraemon";

  services.xserver = {
    xkb = {
      layout = "br";
      variant = "abnt2";
    };
  };

  system.stateVersion = "25.11";
}
