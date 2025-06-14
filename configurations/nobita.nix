{ lib, config, pkgs, ... }:
{
  import = [
    ./common/battery_monitor.nix
  ];
  # Configurações específicas para nobita
  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  networking.hostName = "nobita";
  powerManagement.cpuFreqGovernor = "performance";
  
  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ "amdgpu" ];
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
      device = "/dev/disk/by-uuid/8f4d7ea0-475b-4c46-b01a-a2e98fca897d";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/9F4B-576C";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };

  swapDevices = [{
    device = "/dev/disk/by-uuid/336bdc5c-2367-4569-a0c3-965923750214";
  }];

  environment = {
    systemPackages = with pkgs; [
      openrgb-with-all-plugins
      playonlinux
    ];
  };

  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
  };

  virtualisation = {
    docker.enable = true;
  };

  services = {
    hardware.openrgb.enable = true;
    
    xserver.videoDrivers = [ "amdgpu" ];

    ollama = {
      enable = true;
      package = pkgs.ollama;
    };
  };
}
