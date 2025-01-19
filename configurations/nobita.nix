{ lib, config, ... }:
{
  # Configurações específicas para nobita
  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  networking.hostName = "nobita";
  
  boot.initrd = {
    availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    kernelModules = [ "kvm-amd" "amdgpu" ];

    luks.devices = {
      "luks-8ac9c6cc-79c9-4106-b25c-df7dbfbf318b".device = "/dev/disk/by-uuid/8ac9c6cc-79c9-4106-b25c-df7dbfbf318b";
    };
  };


  fileSystems."/" = {
    device = "/dev/disk/by-uuid/e3f69aa5-b756-4389-96f7-7de0b20b2d94";
    fsType = "ext4";
  };

    fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/8BD5-4ABF";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [{
    device = "/dev/disk/by-uuid/2679d95c-a11f-4add-a8a4-955469e18a5c";
  }];

  services = {
    xserver.videoDrivers = [ "amdgpu" ];
  };
}