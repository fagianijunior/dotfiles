{ config, pkgs, lib, ... }:

# Configuração de sincronização do Taskwarrior com servidor taskchampion-sync-server
# 
# As credenciais são definidas em home/default.nix como variáveis de ambiente
# e também injetadas diretamente no taskrc via Nix

let
  # Pegar valores das variáveis de ambiente definidas em home/default.nix
  clientId = config.home.sessionVariables.TASKCHAMPION_CLIENT_ID;
  encryptionSecret = config.home.sessionVariables.TASKCHAMPION_ENCRYPTION_SECRET;
  serverUrl = config.home.sessionVariables.TASKCHAMPION_SERVER_URL;
in
{
  # Sobrescrever a configuração do taskrc para adicionar sync
  xdg.configFile."task/taskrc".text = lib.mkForce ''
    # Taskwarrior 3 Configuration

    # Data location
    data.location=~/.local/share/task

    # News version (to avoid write errors)
    news.version=3.4.2

    # Default command
    default.command=next

    # Date format
    dateformat=Y-M-D H:N:S
    dateformat.report=Y-M-D
    dateformat.holiday=YMD
    dateformat.annotation=Y-M-D

    # Week starts on Monday
    weekstart=monday

    # Display settings
    displayweeknumber=yes
    list.all.projects=yes
    list.all.tags=yes

    # Colors (Catppuccin Macchiato theme)
    color.active=color13
    color.alternate=on color233
    color.blocked=white on red
    color.blocking=black on bright white
    color.burndown.done=on green
    color.burndown.pending=on red
    color.burndown.started=on yellow
    color.calendar.due=color0 on color13
    color.calendar.due.today=color15 on color13
    color.calendar.holiday=color0 on bright blue
    color.calendar.overdue=color0 on bright red
    color.calendar.today=color15 on bright blue
    color.calendar.weekend=on bright black
    color.calendar.weeknumber=bright blue
    color.completed=green
    color.debug=yellow
    color.deleted=color13
    color.due=color13
    color.due.today=color13
    color.error=white on red
    color.footnote=yellow
    color.header=color13
    color.history.add=color0 on color13
    color.history.delete=color0 on color13
    color.history.done=color0 on green
    color.keyword=color13 on yellow
    color.label=
    color.label.sort=
    color.overdue=color255 on red
    color.pri.H=color255
    color.pri.L=color245
    color.pri.M=color250
    color.pri.none=
    color.project.none=
    color.recurring=color13
    color.scheduled=on color13
    color.summary.background=white on black
    color.summary.bar=black on color13
    color.sync.added=green
    color.sync.changed=yellow
    color.sync.rejected=red
    color.tag.next=color13
    color.tag.none=
    color.tagged=color10
    color.undo.after=green
    color.undo.before=red
    color.until=
    color.warning=bold red

    # User Defined Attributes (UDA)
    uda.client.type=string
    uda.client.label=Client
    uda.client.values=

    # Urgency coefficients
    urgency.user.project.Inbox.coefficient=15.0
    urgency.user.project.Work.coefficient=10.0
    urgency.user.tag.next.coefficient=15.0
    urgency.user.tag.waiting.coefficient=-3.0
    urgency.due.coefficient=12.0
    urgency.blocking.coefficient=8.0
    urgency.priority.coefficient=6.0
    urgency.active.coefficient=4.0
    urgency.scheduled.coefficient=5.0
    urgency.age.coefficient=2.0
    urgency.annotations.coefficient=1.0
    urgency.tags.coefficient=1.0
    urgency.project.coefficient=1.0

    # Reports
    report.next.columns=id,start.age,entry.age,depends.indicator,priority,project,tags.count,recur.indicator,scheduled.countdown,due.relative,until.remaining,description.count,client,urgency
    report.next.labels=ID,Active,Age,D,P,Project,Tags,R,S,Due,Until,Description,Client,Urg
    report.next.sort=urgency-
    report.next.filter=status:pending
    
    report.all.columns=id,status.short,uuid.short,start.age,entry.age,end.age,depends.indicator,priority,project,tags.count,recur.indicator,due,description.count,client
    report.all.labels=ID,St,UUID,A,Age,Done,D,P,Project,Tags,R,Due,Description,Client
    report.all.description=All tasks
    report.all.sort=entry-

    # Custom reports
    report.inbox.description=Inbox tasks
    report.inbox.columns=id,description.count,client
    report.inbox.sort=entry+
    report.inbox.filter=status:pending project:Inbox

    report.waiting.description=Waiting tasks
    report.waiting.columns=id,description.count,project,tags.count,client
    report.waiting.sort=entry+
    report.waiting.filter=status:waiting

    # Aliases
    alias.burndown=burndown.weekly
    alias.ghistory=ghistory.monthly
    alias.history=history.monthly
    alias.rm=delete

    # Context definitions
    context.work=project:Work or +work
    context.personal=project:Personal or +personal

    # Configuração de sincronização com taskchampion-sync-server
    sync.server.url=${serverUrl}
    sync.server.client_id=${clientId}
    sync.encryption_secret=${encryptionSecret}
  '';

  # Script helper para sincronização
  home.packages = [
    (pkgs.writeShellScriptBin "task-sync-init" ''
      #!/usr/bin/env bash
      # Inicializar sincronização pela primeira vez
      echo "🔄 Inicializando sincronização com $TASKCHAMPION_SERVER_URL..."
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
      echo "Servidor: $TASKCHAMPION_SERVER_URL"
      echo "Client ID: $TASKCHAMPION_CLIENT_ID"
      echo "Encryption Secret: ''${TASKCHAMPION_ENCRYPTION_SECRET:0:8}... (configurado)"
      echo ""
      echo "Testando conexão com servidor..."
      if curl -s -o /dev/null -w "%{http_code}" "$TASKCHAMPION_SERVER_URL" | grep -q "200\|404"; then
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
