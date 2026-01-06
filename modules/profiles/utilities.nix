{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # System utilities
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
    zoxide
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
    
    # System monitoring
    pciutils
    usbutils
    lm_sensors
    
    # File management
    yazi
    
    # Terminal enhancements
    grc
    bc
    icu
    
    # Archive tools
    zip
    unzip
    
    # System tools
    f2fs-tools
    gparted
    
    # Appearance
    chafa
    cmatrix
    rsclock
    pipes-rs
    tree-sitter
    tokei
    figlet
  ];
}