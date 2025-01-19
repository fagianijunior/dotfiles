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
    # Networking settings https://nixos.wiki/wiki/Networking
    enableRedistributableFirmware = true;
  };
}