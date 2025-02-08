{ ... }:
{
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    logitech.wireless = {
      enable = true;
      # It install solaar package
      enableGraphical = true;
    };
    # Networking settings https://nixos.wiki/wiki/Networking
    enableRedistributableFirmware = true;
  };
}