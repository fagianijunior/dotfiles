{ pkgs, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    consoleLogLevel = 3; # 0 = panic; 1 = dmesg; 2 = kmsg; 3 = info; 4 = debug; 5 = trace

    kernelParams = [
      "boot.shell_on_fail"
      "rd.debug"
      "udev.log_priority=3"
      "lsm=landlock,lockdown,yama,integrity,apparmor,bpf,tomoyo,selinux"
      "usbcore.autosuspend=-1"
    ];

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 20;    
        memtest86.enable = true;
      };
      efi.canTouchEfiVariables = true; 
      timeout = 2;
    };
    initrd = {
      enable = true;
      verbose = true;
      systemd.enable = true;
    };
  };

  security = {
    tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
    apparmor = {
      enable = true;
      packages = with pkgs; [
        apparmor-utils
        apparmor-profiles
      ];
    };
    pam.services.hyprlock = {};
    polkit.enable = true;
  };

  systemd = {
    package = pkgs.systemd.override { withSelinux = true; };
  };
}
