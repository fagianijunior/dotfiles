{ pkgs, lib, ... }:
{
  services = {
    fail2ban.enable = true;
    fwupd.enable = true;

    # Enable USB Guard
    usbguard = {
      enable = false;
      dbus.enable = true;
      implicitPolicyTarget = "block";
      # FIXME: set yours pref USB devices (change {id} to your trusted USB device), use `lsusb` command (from usbutils package) to get list of all connected USB devices including integrated devices like camera, bluetooth, wifi, etc. with their IDs or just disable `usbguard`
      rules = ''
        # Common
        allow id 1d6b:0002 # Linux Foundation 2.0 root hub
        allow id 1d6b:0003 # Linux Foundation 3.0 root hub

        # Doraemon
        allow id 2109:0103 # VIA Labs, Inc. USB 2.0 BILLBOARD
        allow id 27c6:538d # Shenzhen Goodix Technology Co.,Ltd. FingerPrint
        allow id 0bda:565a # Realtek Semiconductor Corp. Integrated_Webcam_HD
        allow id 8087:0aaa # Intel Corp. Bluetooth 9460/9560 Jefferson Peak (JfP)
        
        # Nobita
        allow id 1c4f:0202 # SiGma Micro Usb KeyBoard
        allow id 1908:2310 # GEMBIRD USB2.0 PC CAMERA
        allow id 189a:2019 # USB Microphone

        # Dongle
        allow id 0a12:0001 # Cambridge Silicon Radio, Ltd Bluetooth Dongle (HCI mode)
        allow id 046d:c548 # Logitech, Inc. Logi Bolt Receiver
        allow id 046d:c542 # Logitech, Inc. M185 compact wireless mouse
        allow id 046d:c52b # Logitech, Inc. Unifying Receiver
        allow id 0bda:1a2b # Realtek Semiconductor Corp. RTL8188GU 802.11n WLAN Adapter (Driver CDROM Mode)
        
        # Pendrive
        allow id 0781:5567 # SanDisk Corp. Cruzer Blade
        allow id 14cd:1212 # Super Top microSD card reader (SY-T18)        
        # MX-8T Mesa de som
        allow id 8888:5678 MV-SILICON mvsilicon B1 usb audio
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
