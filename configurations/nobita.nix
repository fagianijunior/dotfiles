{ lib, config, pkgs, ... }:
{
  # Configurações específicas para nobita
  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  networking.hostName = "nobita";
  powerManagement.cpuFreqGovernor = "performance";
  
  environment.systemPackages = with pkgs; [
    openrgb-with-all-plugins
    openvscode-server
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ "amdgpu" ];
      luks.devices = {
        "luks-0e088135-c164-4ff4-84af-62f887cb390c".device = "/dev/disk/by-uuid/0e088135-c164-4ff4-84af-62f887cb390c";
      };
    };
    # Parâmetros em comum devem ser configurados em configurations/common/boot.nix
    # Adicione aqui parâmtros específicos para essa máquina
    kernelParams = [
      "radeon.cik_support=0"
      "amdgpu.cik_support=1"
      "radeon.si_support=0"
      "amdgpu.si_support=1"
    ];
    blacklistedKernelModules = [ "radeon" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/7f5bc3ff-1da0-43e6-aa55-d5eeee7b140a";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/355E-2E1A";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };

  swapDevices = [{
    device = "/dev/disk/by-uuid/a1414c71-dd07-4b41-9af4-85f20d456637";
  }];

  services = {
    hardware.openrgb.enable = true;
    
    xserver.videoDrivers = [ "amdgpu" ];

    ollama = {
      enable = true;
      package = pkgs.ollama;
    };
  };
}
