# Configurações específicas para doraemon
{ lib, config, pkgs, ... }:
{
  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    graphics.extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
    ];
  };

  networking.hostName = "doraemon";
  powerManagement.cpuFreqGovernor = "ondemand";

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ "i915" "kvm-intel" ];

      luks.devices = {
        "luks-ce36695c-ae19-461e-8409-e64128ea7871".device = "/dev/disk/by-uuid/ce36695c-ae19-461e-8409-e64128ea7871";
      };
    };
    kernelParams = [
      "splash"
      "quiet"
      "plymouth.enable=1"
      "boot.shell_on_fail"
      "loglevel=3"
      "udev.log_priority=3"
      "lsm=landlock,lockdown,yama,integrity,apparmor,bpf,tomoyo,selinux"
      "usbcore.autosuspend=-1"
      "security=selinux"
    ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/4cc535e5-17c1-416f-9ae6-5482d718d05d";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/31DE-36D5";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };

  swapDevices = [{
    device = "/dev/disk/by-uuid/bc6dfe5c-dab8-4e15-88bb-a9b1aecdb0b3";
  }];

  services = {
    xserver.videoDrivers = [ "i915" ];
  };
}
