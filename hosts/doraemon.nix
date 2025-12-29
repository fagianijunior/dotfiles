{ config, pkgs, lib, ... }:

{
  imports = [
    ./doraemon-hardware.nix
    ./quirks/resume-keyboard.nix
  ];

  ############################
  # Boot & hardware
  ############################

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
 
  boot.kernelParams = [
    "i8042.reset"
    "i8042.nomux"
    "i8042.nopnp"
    "i8042.kbdreset"
    "acpi_osi=Linux"
    "mem_sleep_default=deep"
  ];

  powerManagement.enable = true;
  powerManagement.resumeCommands = "${pkgs.kmod}/bin/rmmod atkbd; ${pkgs.kmod}/bin/modprobe atkbd reset=1";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.enableRedistributableFirmware = true;

  # AMD CPU (Ryzen 7000)
  hardware.cpu.amd.updateMicrocode = true;

  ############################
  # Graphics (AMD 680M)
  ############################

  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
    RADV_PERFTEST = "aco";
  };

  ############################
  # Wayland / Hyprland
  ############################

  security.pam.services.hyprlock = {};

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.xwayland.enable = true;
    programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

  programs.light.enable = true;

  systemd.sleep.extraConfig = ''
  HibernateDelaySec=10min
'';

  services = {
    logind = {
      settings = {
        Login = {
          HandleLidSwitchExternalPower = "suspend-then-hibernate";
          HandleLidSwitch = "suspend-then-hibernate";
        };
      };
    };
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a + %h | %F' --cmd Hyprland";
          user = "greeter";
        };
      };
    };
  };

  ############################
  # Input / teclado
  ############################

  services.xserver = {
    enable = false; # Wayland puro
    xkb = {
      layout = "br";
      variant = "abnt2";
    };
  };

  console.keyMap = "br-abnt2";

  ############################
  # Locale / timezone
  ############################

  time.timeZone = "America/Fortaleza";

  i18n = {
    defaultLocale = "pt_BR.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
    };
  };

  ############################
  # Display
  ############################

  environment.sessionVariables = {
    WLR_RENDERER = "vulkan";
    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";
  };

  ############################
  # Networking
  ############################

    networking = {
    enableIPv6 = false;
    useNetworkd = true;
    wireless.iwd = {
      enable = true;
      settings = {
        General = {
          EnableNetworkConfiguration = false; # iwd só cuida do Wi-Fi, o systemd-networkd cuida do resto
        };
      };
    };
  };

  services.resolved.enable = true; # usa systemd-resolved

  ############################
  # Audio (PipeWire)
  ############################

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
      extraConfig = {
        "10-bluez" = {
          "monitor.bluez.properties" = {
            "bluez5.enable-sbc-xq" = true;
            "bluez5.enable-msbc" = true;
            "bluez5.enable-hw-volume" = true;
          };
        };
        "11-bluetooth-policy" = {
          "wireplumber.settings.bluetooth.autoswitch-to-headset-profile" = false;
        };
      };
    };
  };

  ############################
  # Power management (notebook!)
  ############################

  services.power-profiles-daemon.enable = true;

  ############################
  # Users (mínimo)
  ############################

  users.users.terabytes = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
    ];
  };

  ############################
  # Nix
  ############################

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  ############################
  # System packages (mínimo)
  ############################

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    pciutils
    usbutils
    vscode
    pyprland
    hyprls
    hyprlock
    hypridle
    hyprpaper
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

    # Fonts
    jetbrains-mono
    powerline-fonts
    noto-fonts-color-emoji

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
    obs-studio

    # Utilities
    xh
    sd
    fd
    jq
    gh
    fmt
    fzf
    bat
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

    nile
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
    nil
    bash
    dbus
    zlib
    bison
    kdePackages.qtdeclarative
    devenv
    # vscode
    libffi
    # awscli2
    gnumake
    openssl
    ruby-lsp
    autoconf
    automake
    pkg-config
    terraform-ls
    gobject-introspection
    ssm-session-manager-plugin
    typescript-language-server
    lua-language-server
    (python3.withPackages (python-pkgs: with python-pkgs; [
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
      
      # Shell completion, neeed to be configured with your shell. https://github.com/starship/starship/
      starship
    ]))
  ];

  ############################
  # State version
  ############################

  system.stateVersion = "25.11";
}

