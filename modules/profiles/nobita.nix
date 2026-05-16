{ pkgs, ... }:
{
  # Desktop performance configuration
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  boot.kernelParams = [ "btusb.enable_iso" ];

  imports = [
    ./ai-services.nix
    ./gaming.nix
  ];
}
