{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.taskchampion-sync-server;
  dataDir = "/var/lib/taskchampion-sync-server";
in
{
  options.services.taskchampion-sync-server = {
    enable = mkEnableOption "Taskchampion Sync Server for Taskwarrior 3";

    port = mkOption {
      type = types.port;
      default = 8080;
      description = "Port to listen on";
    };

    address = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "Address to bind to";
    };

    dataDir = mkOption {
      type = types.path;
      default = dataDir;
      description = "Directory to store sync data";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Open firewall port for the sync server";
    };
  };

  config = mkIf cfg.enable {
    # Criar usuário e grupo para o serviço
    users.users.taskchampion = {
      isSystemUser = true;
      group = "taskchampion";
      home = cfg.dataDir;
      createHome = true;
      description = "Taskchampion Sync Server user";
    };

    users.groups.taskchampion = {};

    # Configurar o serviço systemd
    systemd.services.taskchampion-sync-server = {
      description = "Taskchampion Sync Server for Taskwarrior 3";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = "taskchampion";
        Group = "taskchampion";
        WorkingDirectory = cfg.dataDir;
        
        ExecStart = "${pkgs.taskchampion-sync-server}/bin/taskchampion-sync-server --port ${toString cfg.port} --address ${cfg.address} --data-dir ${cfg.dataDir}";
        
        # Segurança
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [ cfg.dataDir ];
        
        # Restart automático
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };

    # Abrir porta no firewall se solicitado
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

    # Garantir que o diretório de dados existe com permissões corretas
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 taskchampion taskchampion -"
    ];
  };
}
