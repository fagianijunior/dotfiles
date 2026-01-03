{ pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        ControllerMode = "dual";
        Experimental = true; # Enable experimental features.
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    bluez
    bluez-tools
  ];
}
