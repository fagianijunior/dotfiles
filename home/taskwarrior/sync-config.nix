{ config, pkgs, lib, hostName, ... }:

# Configuração de sincronização do Taskwarrior com servidor taskchampion-sync-server
# 
# CLIENT_IDs únicos por host:
# - nobita: 9dc04b7e-40dc-49f7-8a57-49fc7b9f6ea9
# - doraemon: 222ff46b-60ac-4972-b100-aca1683dd784

let
  # Mapear hostname para CLIENT_ID único
  clientIds = {
    nobita = "9dc04b7e-40dc-49f7-8a57-49fc7b9f6ea9";
    doraemon = "222ff46b-60ac-4972-b100-aca1683dd784";
  };
  
  # Obter CLIENT_ID baseado no hostname do sistema
  clientId = clientIds.${hostName} or (throw "CLIENT_ID não configurado para host: ${hostName}");
  
  # Chave de criptografia compartilhada entre todos os dispositivos
  # IMPORTANTE: Esta chave deve ser a MESMA em todos os dispositivos que sincronizam
  # Gerada com: uuidgen ou openssl rand -hex 32
  encryptionSecret = "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6a7b8c9d0e1f2";
  
  # Endereço do servidor
  serverUrl = "http://orangepizero2:8080";
in
{
  # Adicionar configuração de sync ao taskrc
  xdg.configFile."task/taskrc".text = lib.mkAfter ''
    
    # Configuração de sincronização com taskchampion-sync-server
    sync.server.url=${serverUrl}
    sync.server.client_id=${clientId}
    sync.encryption_secret=${encryptionSecret}
    
    # Opcional: sincronizar automaticamente após cada comando
    # sync.auto=on
  '';

  # Script helper para sincronização
  home.packages = [
    (pkgs.writeShellScriptBin "task-sync-init" ''
      #!/usr/bin/env bash
      # Inicializar sincronização pela primeira vez
      echo "🔄 Inicializando sincronização com ${serverUrl}..."
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
      echo "Servidor: ${serverUrl}"
      echo "Client ID: ${clientId}"
      echo "Encryption Secret: ${builtins.substring 0 8 encryptionSecret}... (configurado)"
      echo ""
      echo "Testando conexão com servidor..."
      if curl -s -o /dev/null -w "%{http_code}" ${serverUrl} | grep -q "200\|404"; then
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
