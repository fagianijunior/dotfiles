{ lib, ... }:
{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system = {
    stateVersion = "25.05";
    autoUpgrade = {
      enable = true;
      allowReboot = true;
      operation = "switch";
      dates = "weekly";
    };
  };
}
