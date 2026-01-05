{ pkgs, ... }:
{

  virtualisation.docker = {
    enable = true;
  };

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
    keyMap = "br-abnt2";
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "kvantum";
  };

  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  services = {
    fwupd.enable = true;

    usbguard = {
      enable = true; # Enable USBGuard service for USB device control.
      dbus.enable = true; # Enable D-Bus interface for USBGuard.
      implicitPolicyTarget = "block"; # Set implicit policy target to block all USB devices by default.

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
        allow id 13d3:3570 # IMC Networks Bluetooth Radio

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
        allow id 8888:5678 # MV-SILICON mvsilicon B1 usb audio
        allow id 048d:04d2 # Integrated Technology Express, Inc. UDisk
        allow id 21c4:0cd1 # Lexar USB Flash Drive
      '';
    };

    fail2ban.enable = true;

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
    fstrim.enable = true;

    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
    tumbler.enable = true;
  };

  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    jetbrains-mono
    powerline-fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    pciutils
    usbutils
    pyprland
    hyprls
    kiro

    hyprpicker
    hyprcursor
    hyprpolkitagent
    wezterm
    yazi
    rofi
    wofi
    brightnessctl

    # Miscellaneous
    grim
    avizo
    psmisc
    cliphist
    libnotify
    playerctl
    psi-notify
    at-spi2-atk
    poweralertd
    wl-clipboard
    qt6.qtwayland
    wl-clip-persist

    # Theme
    catppuccin-gtk
    colloid-icon-theme
    catppuccin-kvantum
    numix-icon-theme-circle
    catppuccin-cursors.macchiatoTeal

    # chat
    slack
    clickup
    telegram-desktop

    # Multimidea
    cava
    slurp
    swappy
    pamixer
    gifsicle
    pavucontrol
    imagemagick
    wl-screenrec
    ffmpeg_6-full

    # Utilities
    xh
    sd
    fd
    jq
    gh
    fmt
    lsd
    viu
    duf
    acpi
    ncdu
    wget
    curl
    tmux
    htop
    tree
    lsof
    just
    noti
    wrk2
    aria2
    ouch
    gnupg
    wtype
    hexyl
    gping
    rewrk
    procs
    wlrctl
    zoxide
    #mdcat
    pandoc
    zellij
    ripgrep
    dust
    usbutils
    progress
    topgrade
    tealdeer
    monolith
    xdg-utils
    trash-cli
    tre-command
    process-compose

    # Version Control
    delta
    lazygit
    gitleaks
    git-ignore
    git-secrets
    pass-git-helper
    license-generator

    qtcreator
    imv
    nchat
    shotcut
    grc
    bc
    icu
    lm_sensors
    quickshell
    ueberzugpp
    imagemagick
    qt5.qtwayland
    qt6.qtwayland
    adwaita-icon-theme

    # Development
    gcc
    bash
    dbus
    zlib
    bison
    kdePackages.qtdeclarative
    devenv
    libffi
    # awscli2
    gnumake
    openssl
    ruby-lsp
    autoconf
    automake
    pkg-config
    gobject-introspection
    ssm-session-manager-plugin
    typescript-language-server
    lua-language-server
    (python3.withPackages (
      python-pkgs: with python-pkgs; [
        # select Python packages here
        hidapi
        psutil
        pydbus
        textual
        requests
        dbus-next
        pygobject3
        tkinter
        google-api-python-client
        google-auth-oauthlib
        google-auth
        gssapi

        # System
        zip
        vorta
        unzip
        biber
        wezterm
        gparted
        mldonkey
        f2fs-tools

        # Appearance
        wofi
        chafa
        cmatrix
        rsclock
        pipes-rs
        tree-sitter

        tokei
        figlet
      ]
    ))
  ];
}
