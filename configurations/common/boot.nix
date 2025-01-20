{ pkgs, ... }:
{

  # "plymouth.enable=0"
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernelParams = [
      "splash"
      "quiet"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "kernel.modules_disabled=1"
      "lsm=landlock,lockdown,yama,integrity,apparmor,bpf,tomoyo,selinux"
      "usbcore.autosuspend=-1"
      "video4linux"
      "security=selinux"
    ];

    consoleLogLevel = 3; # 0 = panic; 1 = dmesg; 2 = kmsg; 3 = info; 4 = debug; 5 = trace

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 20;    
      };
      efi.canTouchEfiVariables = true; 
      timeout = 2;
    };
    initrd = {
      enable = true;
      verbose = false;
      systemd.enable = true;
    };

    plymouth = {
      enable = true;
      font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
      themePackages = [ pkgs.catppuccin-plymouth ];
      theme = "catppuccin-macchiato";
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