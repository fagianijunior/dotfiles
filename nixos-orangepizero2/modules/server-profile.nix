{ config, pkgs, ... }:

{
  # Habilitar Docker
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # Habilitar containerd para Docker
  virtualisation.containerd.enable = true;

  # Ferramentas úteis para servidor
  environment.systemPackages = with pkgs; [
    docker-compose
    lazydocker
  ];

  # Configurações de rede para Docker
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "docker0" ];
  };
}
