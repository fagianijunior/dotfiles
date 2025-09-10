{ lib, config, pkgs, ... }:
{
  # Configurações específicas para nobita
  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableRedistributableFirmware = true;
  };

  networking.hostName = "nobita";
  powerManagement.cpuFreqGovernor = "performance";
  
  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
      #kernelModules = [ "radeon" ];
    };
    # Parâmetros em comum devem ser configurados em configurations/common/boot.nix
    # Adicione aqui parâmtros específicos para essa máquina
    kernelParams = [
      "amdgpu.si_support=1"
    #  "radeon.cik_support=0"
      "radeon.si_support=0"
    ];
    # blacklistedKernelModules = [ "radeon" ];
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
    "/home" = {
      device = "/dev/disk/by-uuid/d24c93e7-4461-4fbe-878e-430a8f20ce4d";
      fsType = "ext4";
    };
  };

  swapDevices = [{
    device = "/dev/disk/by-uuid/336bdc5c-2367-4569-a0c3-965923750214";
  }];

  environment = {
    systemPackages = with pkgs; [
      legendary-gl
      openrgb-with-all-plugins
      playonlinux
      heroic

      # Drivers gráficos AMD (geralmente já inclusos, mas explicitando)
      mesa # Drivers abertos para AMD
      libva-vdpau-driver # Para aceleração de vídeo, se precisar
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
    
    udev.extraRules = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0xaa88", ATTRS{idProduct}=="0x8666", MODE="0666"
    '';

    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
    };
    ollama = {
      enable = true;
      package = pkgs.ollama;
    };
  };
}
