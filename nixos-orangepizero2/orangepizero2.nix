{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/base-server.nix
    ./modules/server-profile.nix
  ];

  networking.hostName = "orangepizero2";

  # Configuração de rede via cabo (sem WiFi)
  # Interface: end0 (Ethernet)
  networking = {
    enableIPv6 = false;
    useNetworkd = true;
    useDHCP = false;
    interfaces.end0.useDHCP = true;
  };

  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    dnsovertls = "opportunistic";
  };

  # Habilitar SSH para acesso remoto
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };

  system.stateVersion = "25.11";
}
