{ config, lib, ... }:

{
  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/f9ce2e50-b408-4479-b849-e83ede69c61f";
  };

  boot.initrd.luks.devices."cryptswap" = {
    device = "/dev/disk/by-uuid/383dd51b-b0fc-4769-8e7d-219241619a10";
  };

  boot.resumeDevice = "/dev/mapper/cryptswap";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  fileSystems = {
    "/" = {
      device = "/dev/mapper/cryptroot";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/E503-847E";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };

  swapDevices = [
    {
      device = "/dev/mapper/cryptswap";
      options = [ "discard" ];
    }
  ];
}
