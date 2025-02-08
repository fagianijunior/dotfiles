{ pkgs, lib, ... }:
{
  services = {
    fail2ban.enable = true;
    fwupd.enable = true;

    # Enable USB Guard
    usbguard = {
      enable = true;
      dbus.enable = true;
      implicitPolicyTarget = "block";
      # FIXME: set yours pref USB devices (change {id} to your trusted USB device), use `lsusb` command (from usbutils package) to get list of all connected USB devices including integrated devices like camera, bluetooth, wifi, etc. with their IDs or just disable `usbguard`
      rules = ''
        allow id 1d6b:0002 # Linux Foundation 2.0 root hub
        allow id 0a12:0001 # Cambridge Silicon Radio, Ltd Bluetooth Dongle (HCI mode)
        allow id 0781:5567 # SanDisk Corp. Cruzer Blade
        allow id 1d6b:0003 # Linux Foundation 3.0 root hub
        allow id 046d:c548 # Logitech, Inc. Logi Bolt Receiver
        allow id 1c4f:0202 # SiGma Micro Usb KeyBoard
        allow id 046d:c542 # Logitech, Inc. M185 compact wireless mouse
        allow id 046d:c52b # Logitech, Inc. Unifying Receiver
      '';
    };

    dbus = {
      enable = true;
      implementation = "broker";
      packages = with pkgs; [
        xfce.xfconf
        gnome2.GConf
      ];
    };

    clamav = {
      daemon.enable = true;
      fangfrisch ={
        enable = true;
        interval = "daily";
      };
      updater = {
        enable = true;
        interval = "daily"; #man systemd.time
        frequency = 12;
      };
      scanner = {
        enable = true;
        interval = "Seg *-*-* 12:00:00";
      };
    };
  };
  programs = {
    firejail = {
      enable = true;
      wrappedBinaries = { 
        imv = {
          executable = "${lib.getBin pkgs.imv}/bin/imv";
          profile = "${pkgs.firejail}/etc/firejail/imv.profile";
        };
        zathura = {
          executable = "${lib.getBin pkgs.zathura}/bin/zathura";
          profile = "${pkgs.firejail}/etc/firejail/zathura.profile";
        };
        telegram-desktop = {
          executable = "${lib.getBin pkgs.tdesktop}/bin/telegram-desktop";
          profile = "${pkgs.firejail}/etc/firejail/telegram-desktop.profile";
        };
        firefox = {
          executable = "${lib.getBin pkgs.firefox}/bin/firefox";
          profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
        };
        thunar = {
          executable = "${lib.getBin pkgs.xfce.thunar}/bin/thunar";
          profile = "${pkgs.firejail}/etc/firejail/thunar.profile";
        };
        vscodium = {
          executable = "${lib.getBin pkgs.vscodium}/bin/vscodium";
          profile = "${pkgs.firejail}/etc/firejail/vscodium.profile";
        };
      };
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}