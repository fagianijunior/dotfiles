{ pkgs, ... }:
{
  # Desktop performance configuration
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  imports = [
    ./ai-services.nix
    ./gaming.nix
  ];
}
