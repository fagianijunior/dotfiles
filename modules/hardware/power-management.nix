{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.powerManagement;
in
{
  options.hardware.powerManagement = {
    laptop = mkOption {
      type = types.bool;
      default = false;
      description = "Enable aggressive power management for laptops";
    };
  };

  config = {
    # NMI watchdog - desabilita para economizar energia
    boot.kernel.sysctl."kernel.nmi_watchdog" = 0;

    # VM writeback timeout - ajusta para melhor economia de energia
    boot.kernel.sysctl."vm.dirty_writeback_centisecs" = 1500;

    # Audio codec power management
    boot.extraModprobeConfig = ''
      options snd_hda_intel power_save=1
    '';

    # Runtime PM para dispositivos PCI
    services.udev.extraRules = ''
      # Enable runtime PM for all PCI devices
      ACTION=="add", SUBSYSTEM=="pci", ATTR{power/control}="auto"
      
      # Enable runtime PM for USB devices
      ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"
      
      # Enable runtime PM for SCSI devices (includes NVMe)
      ACTION=="add", SUBSYSTEM=="scsi", ATTR{power/control}="auto"
    '';

    # PowerTOP auto-tune service
    powerManagement.powertop.enable = true;
    powerManagement.enable = true;

    # Configurações específicas para laptop
    services.tlp = mkIf cfg.laptop {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "low-power";
        
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "on";
      };
    };
  };
}
