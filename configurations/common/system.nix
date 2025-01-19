{ ... }:
{
  system = {
    stateVersion = "24.11";
    autoUpgrade = {
      enable = true;
      allowReboot = true;
      operation = "switch";
      dates = "weekly";
    };
  };
}