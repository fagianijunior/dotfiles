{
  imports = [
    ./doraemon-hardware.nix
    ./quirks/resume-keyboard.nix

    ../modules/base/locale.nix
    ../modules/base/networking-iwd.nix

    ../modules/hardware/amd-common.nix
    ../modules/hardware/graphics-amd.nix

    ../modules/desktop/session.nix
    ../modules/desktop/hyprland.nix
    ../modules/desktop/pipewire.nix

    ../modules/profiles/laptop.nix
  ];

  networking.hostName = "doraemon";
  console.keyMap = "br-abnt2";
}
