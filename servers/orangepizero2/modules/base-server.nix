{ pkgs, ... }:

{
  imports = [
    ../../modules/base/nix.nix
    ../../modules/base/users.nix
    ../../modules/base/locale.nix
    ../../modules/base/keyboard.nix
  ];

  # Usar cache binário para evitar compilações
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # Boot configuration para ARM (Orange Pi Zero 2)
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  # Kernel para Allwinner H616
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  # Otimizações para Cortex-A53
  boot.kernelParams = [
    "console=ttyS0,115200"
    "console=tty1"
  ];

  # Configurações de sistema para servidor
  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxRetentionSec=7day
  '';

  # Otimizações para build em hardware limitado
  nix.settings = {
    max-jobs = 2;
    cores = 2;
  };

  # Timezone e configurações básicas
  time.timeZone = "America/Fortaleza";

  # Habilitar fish shell
  programs.fish.enable = true;

  # Pacotes essenciais para servidor
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    htop
    tmux
    rsync
  ];
}
