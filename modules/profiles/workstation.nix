{ pkgs, ...}:
{

  virtualisation.docker = {
    enable = true;
  };
  
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    pciutils
    usbutils
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
}