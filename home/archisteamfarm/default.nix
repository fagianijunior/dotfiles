{ config, pkgs, lib, hostName ? "", ... }:

let
  # ArchiSteamFarm só deve ser configurado no host nobita
  isNobita = hostName == "nobita";
  
  asfConfigDir = "${config.home.homeDirectory}/.config/ArchiSteamFarm";
in
{
  config = lib.mkIf isNobita {
    # Criar estrutura de diretórios
    home.file."${asfConfigDir}/config/.keep".text = "";
    
    # Configuração global do ASF
    # AutoRestart: permite reiniciar automaticamente
    # UpdateChannel: 1 = Stable, 0 = Experimental
    # OptimizationMode: 0 = MaxPerformance, 1 = MinMemoryUsage
    # IPC: habilita interface web
    # Headless: modo sem interface gráfica
    home.file."${asfConfigDir}/config/ASF.json".text = builtins.toJSON {
      AutoRestart = true;
      UpdateChannel = 1;
      UpdatePeriod = 24;
      OptimizationMode = 0;
      IPC = true;
      IPCPassword = null;
      ConnectionTimeout = 90;
      MaxFarmingTime = 10;
      Debug = false;
      Headless = true;
    };

    # Serviço systemd para rodar o ASF
    systemd.user.services.archisteamfarm = {
      Unit = {
        Description = "ArchiSteamFarm - Steam farming service";
        After = [ "network-online.target" ];
        Wants = [ "network-online.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.ArchiSteamFarm}/bin/ArchiSteamFarm --path=${asfConfigDir}";
        Restart = "on-failure";
        RestartSec = "30s";
        
        # Segurança
        PrivateTmp = true;
        NoNewPrivileges = true;
        
        # Diretórios
        WorkingDirectory = asfConfigDir;
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
