{ config, pkgs, ... }:

{
  # Taskwarrior configuration
  xdg.configFile."task/taskrc".text = ''
    # Taskwarrior 3 Configuration
    
    # Data location
    data.location=~/.local/share/task
    
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
    color.active=rgb013
    color.alternate=on_rgb233
    color.blocked=white on_red
    color.blocking=black on_bright_white
    color.burndown.done=on_green
    color.burndown.pending=on_red
    color.burndown.started=on_yellow
    color.calendar.due=color0 on_rgb013
    color.calendar.due.today=color15 on_rgb013
    color.calendar.holiday=color0 on_bright_blue
    color.calendar.overdue=color0 on_bright_red
    color.calendar.today=color15 on_bright_blue
    color.calendar.weekend=on_bright_black
    color.calendar.weeknumber=bright_blue
    color.completed=green
    color.debug=yellow
    color.deleted=rgb013
    color.due=rgb013
    color.due.today=rgb013
    color.error=white on_red
    color.footnote=yellow
    color.header=rgb013
    color.history.add=color0 on_rgb013
    color.history.delete=color0 on_rgb013
    color.history.done=color0 on_green
    color.keyword=rgb013 on_yellow
    color.label=
    color.label.sort=
    color.overdue=color255 on_red
    color.pri.H=color255
    color.pri.L=color245
    color.pri.M=color250
    color.pri.none=
    color.project.none=
    color.recurring=rgb013
    color.scheduled=on_rgb013
    color.summary.background=white on_black
    color.summary.bar=black on_rgb013
    color.sync.added=green
    color.sync.changed=yellow
    color.sync.rejected=red
    color.tag.next=rgb013
    color.tag.none=
    color.tagged=rgb010
    color.undo.after=green
    color.undo.before=red
    color.until=
    color.warning=bold red
    
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
    report.next.columns=id,start.age,entry.age,depends,priority,project,tag,recur,scheduled.countdown,due.relative,until.remaining,description,urgency
    report.next.labels=ID,Active,Age,Deps,P,Project,Tag,Recur,S,Due,Until,Description,Urg
    report.next.sort=urgency-
    report.next.filter=status:pending limit:page
    
    # Custom reports
    report.inbox.description=Inbox tasks
    report.inbox.columns=id,description
    report.inbox.sort=entry+
    report.inbox.filter=status:pending project:Inbox
    
    report.waiting.description=Waiting tasks
    report.waiting.columns=id,description,project,tag
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
    
    # Sync settings (uncomment and configure if using sync)
    # taskd.certificate=~/.task/private.certificate.pem
    # taskd.key=~/.task/private.key.pem
    # taskd.ca=~/.task/ca.cert.pem
    # taskd.server=host.domain:53589
    # taskd.credentials=Org/First Last/cf31f287-ee9e-43a8-843e-e8bbd5de4294
    
    # Include system taskrc if it exists
    include /etc/taskrc
  '';
  
  # Create data directory
  home.file.".local/share/task/.keep".text = "";
}