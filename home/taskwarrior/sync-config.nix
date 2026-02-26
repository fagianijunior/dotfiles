{ config, pkgs, lib, ... }:

# Configuração de sincronização do Taskwarrior com servidor taskchampion-sync-server
# 
# Para usar:
# 1. Importe este arquivo no seu home/taskwarrior/default.nix
# 2. Gere um UUID único: uuidgen
# 3. Substitua o client_id abaixo pelo UUID gerado
# 4. Ajuste o endereço do servidor se necessário

let
  # IMPORTANTE: Gere um UUID único para cada dispositivo com: uuidgen
  # Cada cliente (desktop, laptop, etc) deve ter um UUID diferente
  clientId = "SUBSTITUA-PELO-SEU-UUID-UNICO";
  
  # Endereço do servidor (ajuste conforme sua rede)
  serverOrigin = "http://orangepizero2:8080";
  # Alternativa com IP: "http://192.168.1.100:8080"
in
{
  # Adicionar configuração de sync ao taskrc
  xdg.configFile."task/taskrc".text = lib.mkAfter ''
    
    # Configuração de sincronização com taskchampion-sync-server
    sync.server.origin=${serverOrigin}
    sync.server.client_id=${clientId}
    
    # Opcional: sincronizar automaticamente após cada comando
    # sync.auto=on
  '';

  # Script helper para sincronização
  home.packages = [
    (pkgs.writeShellScriptBin "task-sync-init" ''
      #!/usr/bin/env bash
      # Inicializar sincronização pela primeira vez
      echo "🔄 Inicializando sincronização com ${serverOrigin}..."
      task sync init
      echo "✅ Sincronização inicializada!"
      echo ""
      echo "Agora você pode usar 'task sync' para sincronizar suas tarefas."
    '')
    
    (pkgs.writeShellScriptBin "task-sync-status" ''
      #!/usr/bin/env bash
      # Verificar status da sincronização
      echo "📊 Status da sincronização:"
      echo ""
      echo "Servidor: ${serverOrigin}"
      echo "Client ID: ${clientId}"
      echo ""
      echo "Testando conexão com servidor..."
      if curl -s -o /dev/null -w "%{http_code}" ${serverOrigin} | grep -q "200\|404"; then
        echo "✅ Servidor acessível"
      else
        echo "❌ Servidor não acessível"
        echo ""
        echo "Verifique:"
        echo "  1. O Orange Pi está ligado?"
        echo "  2. Você está na mesma rede?"
        echo "  3. O serviço está rodando? (ssh orangepizero2 'sudo systemctl status taskchampion-sync-server')"
      fi
      echo ""
      echo "Última sincronização:"
      task sync rc.verbose=on 2>&1 | tail -5
    '')
  ];

  # Opcional: Systemd timer para sincronização automática
  # Descomente para habilitar sincronização a cada 15 minutos
  # systemd.user.services.taskwarrior-sync = {
  #   Unit = {
  #     Description = "Taskwarrior Sync";
  #   };
  #   Service = {
  #     Type = "oneshot";
  #     ExecStart = "${pkgs.taskwarrior3}/bin/task sync";
  #   };
  # };

  # systemd.user.timers.taskwarrior-sync = {
  #   Unit = {
  #     Description = "Taskwarrior Sync Timer";
  #   };
  #   Timer = {
  #     OnBootSec = "5min";
  #     OnUnitActiveSec = "15min";
  #   };
  #   Install = {
  #     WantedBy = [ "timers.target" ];
  #   };
  # };
}
