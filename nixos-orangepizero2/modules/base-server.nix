{ pkgs, ... }:

{
  imports = [
    ../../modules/base/nix.nix
    ../../modules/base/users.nix
    ../../modules/base/locale.nix
    ../../modules/base/keyboard.nix
  ];

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
