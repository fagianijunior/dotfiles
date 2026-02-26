# Taskchampion Sync - Referência Rápida

Comandos e configurações essenciais para uso diário.

## Setup Inicial

### Servidor (Orange Pi)

```bash
# Já está configurado! Apenas verifique:
sudo systemctl status taskchampion-sync-server
```

### Cliente (Desktop/Laptop)

```bash
# 1. Gerar UUID
CLIENT_ID=$(uuidgen)

# 2. Configurar
task config sync.server.origin http://orangepizero2:8080
task config sync.server.client_id $CLIENT_ID

# 3. Inicializar (apenas primeira vez)
task sync init

# 4. Sincronizar
task sync
```

## Comandos Diários

```bash
# Sincronizar tarefas
task sync

# Adicionar tarefa e sincronizar
task add "Nova tarefa" && task sync

# Completar tarefa e sincronizar
task 1 done && task sync

# Ver tarefas
task next
```

## Comandos do Servidor

```bash
# Status
ssh orangepizero2 'sudo systemctl status taskchampion-sync-server'

# Logs
ssh orangepizero2 'sudo journalctl -u taskchampion-sync-server -f'

# Reiniciar
ssh orangepizero2 'sudo systemctl restart taskchampion-sync-server'

# Backup
ssh orangepizero2 'sudo tar -czf /tmp/backup.tar.gz -C /var/lib/taskchampion-sync-server .'
```

## Configuração

### Arquivo: ~/.config/task/taskrc

```ini
# Sincronização
sync.server.origin=http://orangepizero2:8080
sync.server.client_id=seu-uuid-aqui

# Opcional: sincronizar automaticamente
sync.auto=on
```

### Arquivo: nixos-orangepizero2/orangepizero2.nix

```nix
services.taskchampion-sync-server = {
  enable = true;
  port = 8080;
  address = "0.0.0.0";
  openFirewall = true;
};
```

## Troubleshooting Rápido

```bash
# Servidor não responde?
ping orangepizero2
curl http://orangepizero2:8080

# Erro de sincronização?
task sync rc.verbose=on

# Resetar configuração?
task config sync.server.origin ""
task config sync.server.client_id ""
```

## Múltiplos Dispositivos

```bash
# Desktop
task config sync.server.client_id $(uuidgen)  # UUID 1
task sync init

# Laptop
task config sync.server.client_id $(uuidgen)  # UUID 2 (diferente!)
task sync  # Sem init!
```

## Backup

```bash
# Cliente
task export > backup-$(date +%Y%m%d).json

# Servidor
ssh orangepizero2 'sudo tar -czf /tmp/backup.tar.gz -C /var/lib/taskchampion-sync-server .'
scp orangepizero2:/tmp/backup.tar.gz ./
```

## Portas e Endereços

| Serviço | Porta | Protocolo |
|---------|-------|-----------|
| Taskchampion Sync | 8080 | HTTP |
| SSH | 22 | SSH |

## Arquivos Importantes

### Servidor (Orange Pi)
- Dados: `/var/lib/taskchampion-sync-server/`
- Logs: `journalctl -u taskchampion-sync-server`
- Config: `/etc/nixos/orangepizero2.nix`

### Cliente
- Config: `~/.config/task/taskrc`
- Dados: `~/.local/share/task/`
- Backups: `~/.local/share/task/backups/`

## Scripts Úteis

```bash
# Testar servidor
./nixos-orangepizero2/scripts/test-taskchampion.sh

# Sincronizar com verbose
task sync rc.verbose=on

# Ver configuração
task show | grep sync

# Exportar tarefas
task export | jq .
```

## Sincronização Automática

### Opção 1: Hook do Taskwarrior

```bash
# ~/.config/task/hooks/on-exit-sync.sh
#!/bin/bash
task sync 2>&1 | logger -t taskwarrior-sync
exit 0
```

### Opção 2: Systemd Timer

```bash
# Habilitar timer
systemctl --user enable --now taskwarrior-sync.timer

# Ver status
systemctl --user status taskwarrior-sync.timer
```

### Opção 3: Cron

```cron
# Sincronizar a cada 15 minutos
*/15 * * * * /usr/bin/task sync >/dev/null 2>&1
```

## Segurança

### Rede Local (Padrão)
```nix
address = "0.0.0.0";
openFirewall = true;
```

### Apenas Localhost + SSH Tunnel
```nix
address = "127.0.0.1";
openFirewall = false;
```

```bash
# Cliente: criar túnel
ssh -L 8080:localhost:8080 -N -f orangepizero2
task config sync.server.origin http://localhost:8080
```

### Com VPN (Tailscale)
```nix
address = "100.x.x.x";  # IP do Tailscale
networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 8080 ];
```

## Monitoramento

```bash
# Status do serviço
watch -n 5 'ssh orangepizero2 sudo systemctl status taskchampion-sync-server'

# Conexões ativas
ssh orangepizero2 'sudo ss -tnp | grep :8080'

# Uso de disco
ssh orangepizero2 'sudo du -sh /var/lib/taskchampion-sync-server/'
```

## Erros Comuns

| Erro | Solução |
|------|---------|
| Connection refused | Verificar se serviço está rodando |
| Address already in use | Mudar porta ou parar serviço conflitante |
| Permission denied | Corrigir permissões: `chown taskchampion:taskchampion` |
| Invalid UUID | Gerar novo UUID com `uuidgen` |
| Sync conflict | Usar `task sync init` para forçar |

## Recursos

- [Setup Completo](./taskwarrior-sync-setup.md)
- [Segurança](./taskwarrior-security.md)
- [Troubleshooting](./taskwarrior-troubleshooting.md)
- [Taskwarrior Docs](https://taskwarrior.org/docs/)

## Atalhos Úteis

```bash
# Aliases para ~/.bashrc ou ~/.zshrc
alias ts='task sync'
alias tsi='task sync init'
alias tss='task-sync-status'
alias tl='ssh orangepizero2 sudo journalctl -u taskchampion-sync-server -f'
```

## Workflow Recomendado

```bash
# Manhã: sincronizar antes de começar
task sync

# Durante o dia: trabalhar normalmente
task add "Fazer X"
task 1 done

# Noite: sincronizar antes de desligar
task sync
```

## Dicas

1. Use `task sync` regularmente (ou configure automático)
2. Cada dispositivo precisa de UUID único
3. Faça backups regulares
4. Use apenas em rede confiável (ou com VPN/SSH)
5. Monitore os logs ocasionalmente
6. Teste a restauração de backup periodicamente

## Contatos de Emergência

Se algo der errado:

1. Backup imediato: `task export > emergency-backup.json`
2. Ver logs: `ssh orangepizero2 sudo journalctl -u taskchampion-sync-server`
3. Consultar: [Troubleshooting Guide](./taskwarrior-troubleshooting.md)
