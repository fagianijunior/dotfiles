{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/base-server.nix
    ./modules/server-profile.nix
    ./modules/taskchampion-sync-server.nix
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

  # Taskchampion Sync Server para Taskwarrior 3
  services.taskchampion-sync-server = {
    enable = true;
    port = 8080;
    address = "0.0.0.0";
    openFirewall = true;
  };

  # Tailscale VPN
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";  # Permite que o Orange Pi seja um exit node
  };

  # Abrir porta do Tailscale no firewall
  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  system.stateVersion = "25.11";
}
