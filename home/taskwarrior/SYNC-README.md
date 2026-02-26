# Configuração de Sincronização do Taskwarrior

Este diretório contém a configuração para sincronizar o Taskwarrior com o servidor taskchampion-sync-server rodando no Orange Pi Zero 2.

## Arquivos

- `sync-config.nix` - Configuração básica de sincronização
- `sync-services.nix` - Serviços systemd para sincronização automática (opcional)
- `SYNC-README.md` - Este arquivo

## Setup Rápido

### 1. Gerar UUID único

Cada dispositivo precisa de um UUID único:

```bash
uuidgen
```

Exemplo: `a1b2c3d4-e5f6-7890-abcd-ef1234567890`

### 2. Configurar o sync-config.nix

Edite `home/taskwarrior/sync-config.nix` e substitua:

```nix
clientId = "SUBSTITUA-PELO-SEU-UUID-UNICO";
```

Por:

```nix
clientId = "a1b2c3d4-e5f6-7890-abcd-ef1234567890";
```

### 3. Importar no default.nix

Edite `home/taskwarrior/default.nix` e adicione aos imports:

```nix
{
  imports = [
    ./systemd-services.nix
    ./sync-config.nix  # <-- Adicione esta linha
    # ./sync-services.nix  # <-- Opcional: para sincronização automática
  ];
  
  # ... resto da configuração
}
```

### 4. Aplicar configuração

```bash
# Se usar home-manager standalone
home-manager switch

# Se usar home-manager como módulo do NixOS
sudo nixos-rebuild switch
```

### 5. Inicializar sincronização

```bash
# Primeira vez (envia tarefas locais para o servidor)
task-sync-init

# Verificar status
task-sync-status

# Sincronizações subsequentes
task sync
```

## Scripts Disponíveis

Após aplicar a configuração, você terá acesso a:

- `task-sync-init` - Inicializa a sincronização pela primeira vez
- `task-sync-status` - Verifica status da conexão e última sincronização
- `task sync` - Sincroniza tarefas (comando nativo do Taskwarrior)

## Sincronização Automática

Para habilitar sincronização automática a cada 15 minutos, descomente as seções do systemd timer no `sync-config.nix`:

```nix
systemd.user.services.taskwarrior-sync = {
  # ... (descomente)
};

systemd.user.timers.taskwarrior-sync = {
  # ... (descomente)
};
```

Depois aplique a configuração e verifique:

```bash
systemctl --user status taskwarrior-sync.timer
```

### Alternativa: sync-services.nix (Avançado)

Para recursos avançados (backup automático, verificação de conectividade, notificações), use o `sync-services.nix`:

1. Edite `sync-services.nix` e mude:
```nix
syncEnabled = true;  # Habilitar sincronização
useSshTunnel = false; # true se usar túnel SSH
```

2. Importe no `default.nix`:
```nix
imports = [
  ./systemd-services.nix
  ./sync-config.nix
  ./sync-services.nix  # <-- Adicione
];
```

3. Aplique e verifique:
```bash
home-manager switch
task-sync-services  # Ver status dos serviços
```

Scripts disponíveis com sync-services.nix:
- `task-sync-now` - Sincronizar manualmente com feedback
- `task-sync-services` - Ver status de todos os serviços
- `task-sync-toggle` - Habilitar/desabilitar sincronização automática

## Múltiplos Dispositivos

Se você tem múltiplos dispositivos (desktop, laptop, etc):

1. Cada um deve ter seu próprio UUID único
2. Todos devem apontar para o mesmo servidor
3. No primeiro dispositivo, use `task-sync-init`
4. Nos demais, use apenas `task sync` (sem init)

### Exemplo

Desktop (`clientId`):
```
11111111-1111-1111-1111-111111111111
```

Laptop (`clientId`):
```
22222222-2222-2222-2222-222222222222
```

## Troubleshooting

### Servidor não acessível

```bash
# Verificar se o Orange Pi está acessível
ping orangepizero2

# Verificar se a porta está aberta
nmap -p 8080 orangepizero2

# Verificar status do serviço no Orange Pi
ssh orangepizero2 'sudo systemctl status taskchampion-sync-server'
```

### Conflitos de sincronização

Raramente ocorrem, mas se acontecer:

```bash
# Backup primeiro
task export > backup-$(date +%Y%m%d).json

# Forçar sincronização
task sync init
```

### Ver logs detalhados

```bash
# Cliente
task sync rc.verbose=on

# Servidor (no Orange Pi)
ssh orangepizero2 'sudo journalctl -u taskchampion-sync-server -f'
```

## Configuração Avançada

### Usar IP ao invés de hostname

Se preferir usar o IP direto, edite `sync-config.nix`:

```nix
serverOrigin = "http://192.168.1.100:8080";
```

### Sincronização automática após cada comando

Adicione ao `taskrc` (já incluído no sync-config.nix, basta descomentar):

```bash
sync.auto=on
```

Isso sincroniza automaticamente após cada comando `task`.

### HTTPS com certificado

Se configurar HTTPS no servidor (via Caddy/nginx):

```nix
serverOrigin = "https://sync.seudominio.com";
```

## Referências

- [Documentação completa](../nixos-orangepizero2/docs/taskwarrior-sync-setup.md)
- [Taskwarrior Sync Docs](https://taskwarrior.org/docs/sync/)
- [Taskchampion GitHub](https://github.com/GothenburgBitFactory/taskchampion-sync-server)
