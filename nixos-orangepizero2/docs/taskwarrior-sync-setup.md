# Configuração do Taskwarrior Sync

Este guia explica como configurar a sincronização do Taskwarrior 3 com o servidor taskchampion-sync-server rodando no Orange Pi Zero 2.

## Servidor (Orange Pi Zero 2)

O servidor já está configurado e rodando automaticamente via systemd.

### Verificar status

```bash
sudo systemctl status taskchampion-sync-server
```

### Ver logs

```bash
sudo journalctl -u taskchampion-sync-server -f
```

### Configuração do servidor

- Porta: 8080
- Endereço: 0.0.0.0 (aceita conexões de qualquer interface)
- Diretório de dados: `/var/lib/taskchampion-sync-server/`
- Firewall: Porta 8080 aberta automaticamente

## Cliente (Desktop/Laptop)

### 1. Gerar UUID único para o cliente

Cada dispositivo precisa de um UUID único:

```bash
uuidgen
```

Exemplo de saída: `a1b2c3d4-e5f6-7890-abcd-ef1234567890`

### 2. Configurar o taskrc

Edite `~/.config/task/taskrc` e adicione:

```bash
# Configuração de sincronização
sync.server.origin=http://orangepizero2:8080
sync.server.client_id=a1b2c3d4-e5f6-7890-abcd-ef1234567890

# Opcional: configurar certificado SSL se usar HTTPS no futuro
# sync.server.certificate=/path/to/cert.pem
```

Se preferir usar o IP direto ao invés do hostname:

```bash
sync.server.origin=http://192.168.1.100:8080
```

### 3. Inicializar sincronização

Na primeira vez, inicialize a sincronização:

```bash
task sync init
```

Isso enviará todas as suas tarefas locais para o servidor.

### 4. Sincronizar regularmente

Para sincronizar suas tarefas:

```bash
task sync
```

Você pode adicionar isso ao seu workflow:

```bash
# Sincronizar antes de trabalhar
task sync

# Fazer suas modificações
task add "Nova tarefa"
task 1 done

# Sincronizar depois
task sync
```

## Sincronização Automática

### Opção 1: Hook do Taskwarrior

Crie um hook para sincronizar automaticamente após cada comando:

```bash
mkdir -p ~/.config/task/hooks
```

Crie o arquivo `~/.config/task/hooks/on-exit-sync.sh`:

```bash
#!/bin/bash
task sync 2>&1 | logger -t taskwarrior-sync
exit 0
```

Torne-o executável:

```bash
chmod +x ~/.config/task/hooks/on-exit-sync.sh
```

### Opção 2: Systemd Timer (Linux)

Crie `~/.config/systemd/user/taskwarrior-sync.service`:

```ini
[Unit]
Description=Taskwarrior Sync

[Service]
Type=oneshot
ExecStart=/usr/bin/task sync
```

Crie `~/.config/systemd/user/taskwarrior-sync.timer`:

```ini
[Unit]
Description=Taskwarrior Sync Timer

[Timer]
OnBootSec=5min
OnUnitActiveSec=15min

[Install]
WantedBy=timers.target
```

Habilite o timer:

```bash
systemctl --user enable --now taskwarrior-sync.timer
```

### Opção 3: Cron

Adicione ao crontab:

```bash
crontab -e
```

```cron
# Sincronizar a cada 15 minutos
*/15 * * * * /usr/bin/task sync >/dev/null 2>&1
```

## Múltiplos Clientes

Você pode sincronizar vários dispositivos com o mesmo servidor:

1. Cada dispositivo deve ter seu próprio `client_id` único
2. Configure o mesmo `sync.server.origin` em todos
3. Execute `task sync init` no primeiro dispositivo
4. Execute `task sync` nos demais dispositivos (não use `init`)

### Exemplo com 2 dispositivos

Desktop:
```bash
sync.server.origin=http://orangepizero2:8080
sync.server.client_id=11111111-1111-1111-1111-111111111111
```

Laptop:
```bash
sync.server.origin=http://orangepizero2:8080
sync.server.client_id=22222222-2222-2222-2222-222222222222
```

## Troubleshooting

### Erro de conexão

```bash
# Verificar se o servidor está acessível
curl http://orangepizero2:8080

# Verificar se a porta está aberta
nmap -p 8080 orangepizero2
```

### Conflitos de sincronização

Se houver conflitos, o Taskwarrior geralmente resolve automaticamente. Em casos raros:

```bash
# Forçar push das tarefas locais
task sync init

# Ou forçar pull do servidor (CUIDADO: sobrescreve local)
# Faça backup antes!
task export > backup.json
task sync
```

### Ver logs detalhados

```bash
# Cliente
task sync rc.verbose=on

# Servidor (no Orange Pi)
sudo journalctl -u taskchampion-sync-server -n 100
```

## Backup

### Backup do servidor

```bash
# No Orange Pi
sudo tar -czf taskchampion-backup-$(date +%Y%m%d).tar.gz /var/lib/taskchampion-sync-server/
```

### Backup do cliente

```bash
# Exportar tarefas
task export > taskwarrior-backup-$(date +%Y%m%d).json

# Ou copiar diretório completo
tar -czf task-backup-$(date +%Y%m%d).tar.gz ~/.local/share/task/
```

## Segurança

### Recomendações

1. Use o servidor apenas em rede local confiável
2. Para acesso externo, configure um reverse proxy com HTTPS (nginx/caddy)
3. Configure firewall para limitar acesso apenas aos IPs necessários
4. Faça backups regulares

### Exemplo com Caddy (HTTPS)

Se quiser expor o servidor com HTTPS:

```bash
# Instalar Caddy no Orange Pi
# Adicionar ao Caddyfile:

sync.seudominio.com {
    reverse_proxy localhost:8080
}
```

Então configure o cliente:

```bash
sync.server.origin=https://sync.seudominio.com
```

## Referências

- [Taskwarrior 3 Sync Documentation](https://taskwarrior.org/docs/sync/)
- [Taskchampion Sync Server GitHub](https://github.com/GothenburgBitFactory/taskchampion-sync-server)
