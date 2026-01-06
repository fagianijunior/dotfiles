{ pkgs, ... }:
{
  # Console configuration
  console = {
    enable = true;
    earlySetup = true;
    colors = [
      "24273a"
      "ed8796"
      "a6da95"
      "eed49f"
      "8aadf4"
      "f5bde6"
      "8bd5ca"
      "cad3f5"
      "5b6078"
      "ed8796"
      "a6da95"
      "eed49f"
      "8aadf4"
      "f5bde6"
      "8bd5ca"
      "a5adcb"
    ];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-118b.psf.gz";
    packages = with pkgs; [ terminus_font ];
  };

  # Qt configuration
  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "kvantum";
  };

  # XDG portals
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  # System services
  services = {
    fwupd.enable = true;
    fail2ban.enable = true;
    fstrim.enable = true;
    tumbler.enable = true;

    # SSH configuration
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = true;
        AllowUsers = [ "terabytes" ];
        PubkeyAuthentication = true;
        ChallengeResponseAuthentication = false;
        UsePAM = true;
        X11Forwarding = true;
        AllowTcpForwarding = true;
        PrintMotd = true;
      };
    };

    # Tailscale VPN
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };

    # USB security
    usbguard = {
      enable = true;
      dbus.enable = true;
      implicitPolicyTarget = "block";
      rules = ''
        # Common
        allow id 1d6b:0002 # Linux Foundation 2.0 root hub
        allow id 1d6b:0003 # Linux Foundation 3.0 root hub

        # Doraemon
        allow id 2109:0103 # VIA Labs, Inc. USB 2.0 BILLBOARD
        allow id 27c6:538d # Shenzhen Goodix Technology Co.,Ltd. FingerPrint
        allow id 13d3:54bf # IMC Networks Integrated Camera
        allow id 0bda:4853 # Realtek Semiconductor Corp. Bluetooth Radio

        # Nobita
        allow id 1c4f:0202 # SiGma Micro Usb KeyBoard
        allow id 1908:2310 # GEMBIRD USB2.0 PC CAMERA
        allow id 189a:2019 # USB Microphone
        allow id 13d3:3570 # IMC Networks Bluetooth Radio

        # Dongles
        allow id 0a12:0001 # Cambridge Silicon Radio, Ltd Bluetooth Dongle (HCI mode)
        allow id 046d:c548 # Logitech, Inc. Logi Bolt Receiver
        allow id 046d:c542 # Logitech, Inc. M185 compact wireless mouse
        allow id 046d:c52b # Logitech, Inc. Unifying Receiver
        allow id 0bda:1a2b # Realtek Semiconductor Corp. RTL8188GU 802.11n WLAN Adapter

        # Storage devices
        allow id 0781:5567 # SanDisk Corp. Cruzer Blade
        allow id 14cd:1212 # Super Top microSD card reader (SY-T18)
        allow id 8888:5678 # MV-SILICON mvsilicon B1 usb audio
        allow id 048d:04d2 # Integrated Technology Express, Inc. UDisk
        allow id 21c4:0cd1 # Lexar USB Flash Drive
      '';
    };
  };

  # Fonts
  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      jetbrains-mono
      powerline-fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      nerd-fonts.jetbrains-mono
    ];
  };

  # Core system packages
  environment.systemPackages = with pkgs; [
    # Core Hyprland ecosystem
    pyprland
    hyprls
    hyprpicker
    hyprcursor
    hyprpolkitagent

    # Terminal and shell
    wezterm
    vim

    # Wayland tools
    rofi
    wofi
    brightnessctl
    avizo
    psmisc
    cliphist
    libnotify
    playerctl
    psi-notify
    at-spi2-atk
    poweralertd
    wl-clipboard
    wl-clip-persist
    qt6.qtwayland
    qt5.qtwayland

    # Theme packages
    catppuccin-gtk
    colloid-icon-theme
    catppuccin-kvantum
    numix-icon-theme-circle
    catppuccin-cursors.macchiatoTeal
    adwaita-icon-theme

    # Essential tools
    kiro
    quickshell
    ueberzugpp
    qtcreator
    vorta
    mldonkey
    biber
  ];
}
