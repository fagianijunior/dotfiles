# Troubleshooting - Taskchampion Sync Server

Guia de resolução de problemas para o servidor de sincronização do Taskwarrior.

## Problemas Comuns

### 1. Serviço não inicia

**Sintoma**: `systemctl status taskchampion-sync-server` mostra "failed"

**Diagnóstico**:
```bash
# Ver erro específico
sudo journalctl -u taskchampion-sync-server -n 50

# Verificar se o binário existe
which taskchampion-sync-server

# Testar manualmente
sudo -u taskchampion taskchampion-sync-server --help
```

**Soluções**:

1. Verificar se o pacote está instalado:
```bash
nix-env -q | grep taskchampion
```

2. Reconstruir configuração:
```bash
sudo nixos-rebuild switch --flake .#orangepizero2
```

3. Verificar permissões do diretório:
```bash
sudo ls -la /var/lib/taskchampion-sync-server/
sudo chown -R taskchampion:taskchampion /var/lib/taskchampion-sync-server/
```

### 2. Porta já em uso

**Sintoma**: Erro "Address already in use"

**Diagnóstico**:
```bash
# Ver o que está usando a porta 8080
sudo ss -tlnp | grep :8080
sudo lsof -i :8080
```

**Soluções**:

1. Mudar a porta no módulo:
```nix
services.taskchampion-sync-server = {
  enable = true;
  port = 8081;  # Usar porta diferente
  # ...
};
```

2. Ou parar o serviço conflitante:
```bash
sudo systemctl stop <servico-conflitante>
```

### 3. Cliente não consegue conectar

**Sintoma**: `task sync` retorna erro de conexão

**Diagnóstico**:
```bash
# Do cliente, testar conectividade
ping orangepizero2
curl -v http://orangepizero2:8080

# Verificar DNS
nslookup orangepizero2

# Verificar rota
traceroute orangepizero2

# No servidor, verificar se está escutando
sudo ss -tlnp | grep :8080
```

**Soluções**:

1. Verificar firewall no servidor:
```bash
# Ver regras
sudo iptables -L -n -v | grep 8080

# Se não estiver aberto
sudo iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
```

2. Verificar se o serviço está rodando:
```bash
sudo systemctl status taskchampion-sync-server
```

3. Usar IP ao invés de hostname:
```bash
# Descobrir IP do servidor
ip addr show end0

# No cliente
task config sync.server.origin http://192.168.1.100:8080
```

4. Verificar se está escutando em 0.0.0.0:
```bash
sudo ss -tlnp | grep :8080
# Deve mostrar: 0.0.0.0:8080 (não 127.0.0.1:8080)
```

### 4. Erro "sync init" falha

**Sintoma**: `task sync init` retorna erro

**Diagnóstico**:
```bash
# Ver erro detalhado
task sync init rc.verbose=on

# Verificar configuração
task show | grep sync
```

**Soluções**:

1. Verificar configuração do cliente:
```bash
# Deve ter estas linhas
task config sync.server.origin http://orangepizero2:8080
task config sync.server.client_id $(uuidgen)
```

2. Verificar se o UUID é válido:
```bash
# Deve ser formato: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
task show | grep client_id
```

3. Limpar e tentar novamente:
```bash
# Backup primeiro!
task export > backup.json

# Limpar configuração de sync
task config sync.server.origin ""
task config sync.server.client_id ""

# Reconfigurar
task config sync.server.origin http://orangepizero2:8080
task config sync.server.client_id $(uuidgen)
task sync init
```

### 5. Conflitos de sincronização

**Sintoma**: Tarefas duplicadas ou perdidas após sync

**Diagnóstico**:
```bash
# Ver tarefas duplicadas
task export | jq '.[] | .uuid' | sort | uniq -d

# Comparar com servidor
ssh orangepizero2 'sudo cat /var/lib/taskchampion-sync-server/data.json'
```

**Soluções**:

1. Usar o mesmo client_id em todos os syncs do mesmo dispositivo
2. Não usar `sync init` múltiplas vezes
3. Se houver conflito, escolher uma fonte de verdade:

```bash
# Opção A: Servidor como verdade (CUIDADO: sobrescreve local)
task export > backup-local.json
rm -rf ~/.local/share/task/*
task sync

# Opção B: Local como verdade (CUIDADO: sobrescreve servidor)
task sync init
```

### 6. Sincronização lenta

**Sintoma**: `task sync` demora muito

**Diagnóstico**:
```bash
# Medir tempo
time task sync

# Ver tamanho dos dados
du -sh ~/.local/share/task/
ssh orangepizero2 'sudo du -sh /var/lib/taskchampion-sync-server/'

# Ver número de tarefas
task count
```

**Soluções**:

1. Limpar tarefas antigas:
```bash
# Deletar tarefas completadas há mais de 6 meses
task status:completed end.before:now-6months delete

# Ou exportar e arquivar
task status:completed export > archive-$(date +%Y).json
task status:completed delete
```

2. Verificar latência de rede:
```bash
ping -c 10 orangepizero2
```

3. Verificar carga do servidor:
```bash
ssh orangepizero2 'top -bn1 | head -20'
```

### 7. Dados corrompidos

**Sintoma**: Erro ao ler dados do servidor

**Diagnóstico**:
```bash
# No servidor, verificar integridade
ssh orangepizero2 'sudo cat /var/lib/taskchampion-sync-server/data.json | jq .'

# Ver logs de erro
ssh orangepizero2 'sudo journalctl -u taskchampion-sync-server -p err'
```

**Soluções**:

1. Restaurar do backup:
```bash
# No servidor
sudo systemctl stop taskchampion-sync-server
sudo tar -xzf /var/backup/taskchampion/taskchampion-YYYYMMDD.tar.gz -C /var/lib/taskchampion-sync-server/
sudo chown -R taskchampion:taskchampion /var/lib/taskchampion-sync-server/
sudo systemctl start taskchampion-sync-server
```

2. Reinicializar do cliente:
```bash
# No servidor, limpar dados
ssh orangepizero2 'sudo systemctl stop taskchampion-sync-server'
ssh orangepizero2 'sudo rm -rf /var/lib/taskchampion-sync-server/*'
ssh orangepizero2 'sudo systemctl start taskchampion-sync-server'

# No cliente, reinicializar
task sync init
```

### 8. Permissões incorretas

**Sintoma**: Erro de permissão nos logs

**Diagnóstico**:
```bash
# Verificar permissões
ssh orangepizero2 'sudo ls -la /var/lib/taskchampion-sync-server/'

# Verificar usuário do serviço
ssh orangepizero2 'sudo systemctl show taskchampion-sync-server | grep User'
```

**Soluções**:
```bash
# Corrigir permissões
ssh orangepizero2 'sudo chown -R taskchampion:taskchampion /var/lib/taskchampion-sync-server/'
ssh orangepizero2 'sudo chmod 750 /var/lib/taskchampion-sync-server/'
ssh orangepizero2 'sudo systemctl restart taskchampion-sync-server'
```

## Comandos Úteis

### Diagnóstico Rápido

```bash
# Script de diagnóstico completo
./nixos-orangepizero2/scripts/test-taskchampion.sh
```

### Logs

```bash
# Logs em tempo real
ssh orangepizero2 'sudo journalctl -u taskchampion-sync-server -f'

# Últimas 100 linhas
ssh orangepizero2 'sudo journalctl -u taskchampion-sync-server -n 100'

# Apenas erros
ssh orangepizero2 'sudo journalctl -u taskchampion-sync-server -p err'

# Logs de hoje
ssh orangepizero2 'sudo journalctl -u taskchampion-sync-server --since today'
```

### Reiniciar Serviço

```bash
# Reiniciar
ssh orangepizero2 'sudo systemctl restart taskchampion-sync-server'

# Parar
ssh orangepizero2 'sudo systemctl stop taskchampion-sync-server'

# Iniciar
ssh orangepizero2 'sudo systemctl start taskchampion-sync-server'

# Status
ssh orangepizero2 'sudo systemctl status taskchampion-sync-server'
```

### Verificar Conectividade

```bash
# Ping
ping orangepizero2

# Porta aberta
nmap -p 8080 orangepizero2

# HTTP
curl -v http://orangepizero2:8080

# Telnet
telnet orangepizero2 8080
```

### Backup Manual

```bash
# Criar backup
ssh orangepizero2 'sudo tar -czf /tmp/taskchampion-backup.tar.gz -C /var/lib/taskchampion-sync-server .'

# Copiar para local
scp orangepizero2:/tmp/taskchampion-backup.tar.gz ./

# Restaurar
scp taskchampion-backup.tar.gz orangepizero2:/tmp/
ssh orangepizero2 'sudo systemctl stop taskchampion-sync-server'
ssh orangepizero2 'sudo tar -xzf /tmp/taskchampion-backup.tar.gz -C /var/lib/taskchampion-sync-server/'
ssh orangepizero2 'sudo chown -R taskchampion:taskchampion /var/lib/taskchampion-sync-server/'
ssh orangepizero2 'sudo systemctl start taskchampion-sync-server'
```

## Modo Debug

### Habilitar logs verbosos

Edite o módulo para adicionar flags de debug:

```nix
systemd.services.taskchampion-sync-server = {
  # ...
  serviceConfig = {
    # ...
    Environment = "RUST_LOG=debug";
  };
};
```

Aplique e reinicie:
```bash
sudo nixos-rebuild switch --flake .#orangepizero2
ssh orangepizero2 'sudo systemctl restart taskchampion-sync-server'
```

### Executar manualmente

```bash
# Parar serviço
ssh orangepizero2 'sudo systemctl stop taskchampion-sync-server'

# Executar manualmente com debug
ssh orangepizero2 'sudo -u taskchampion RUST_LOG=debug taskchampion-sync-server --port 8080 --address 0.0.0.0 --data-dir /var/lib/taskchampion-sync-server'

# Ctrl+C para parar

# Reiniciar serviço
ssh orangepizero2 'sudo systemctl start taskchampion-sync-server'
```

## Resetar Tudo

Se nada funcionar, reset completo:

```bash
# 1. Backup dos dados
task export > backup-$(date +%Y%m%d).json

# 2. No servidor, limpar tudo
ssh orangepizero2 'sudo systemctl stop taskchampion-sync-server'
ssh orangepizero2 'sudo rm -rf /var/lib/taskchampion-sync-server/*'

# 3. Reconstruir configuração
sudo nixos-rebuild switch --flake .#orangepizero2

# 4. Verificar serviço
ssh orangepizero2 'sudo systemctl status taskchampion-sync-server'

# 5. No cliente, limpar configuração de sync
task config sync.server.origin ""
task config sync.server.client_id ""

# 6. Reconfigurar
task config sync.server.origin http://orangepizero2:8080
task config sync.server.client_id $(uuidgen)

# 7. Inicializar
task sync init

# 8. Verificar
task sync
```

## Obter Ajuda

Se o problema persistir:

1. Verifique os logs completos:
```bash
ssh orangepizero2 'sudo journalctl -u taskchampion-sync-server --no-pager' > logs.txt
```

2. Exporte configuração:
```bash
task show > task-config.txt
```

3. Documente o problema:
   - O que você estava tentando fazer?
   - O que aconteceu?
   - Mensagens de erro exatas
   - Logs relevantes

4. Recursos:
   - [Taskwarrior Forum](https://github.com/GothenburgBitFactory/taskwarrior/discussions)
   - [Taskchampion Issues](https://github.com/GothenburgBitFactory/taskchampion-sync-server/issues)
   - [NixOS Discourse](https://discourse.nixos.org/)

## Checklist de Troubleshooting

Antes de pedir ajuda, verifique:

- [ ] Serviço está rodando: `systemctl status taskchampion-sync-server`
- [ ] Porta está aberta: `ss -tlnp | grep 8080`
- [ ] Firewall permite conexões: `iptables -L -n | grep 8080`
- [ ] Cliente consegue pingar servidor: `ping orangepizero2`
- [ ] Cliente consegue acessar porta: `curl http://orangepizero2:8080`
- [ ] Configuração do cliente está correta: `task show | grep sync`
- [ ] UUID do cliente é válido: formato correto
- [ ] Logs não mostram erros: `journalctl -u taskchampion-sync-server -p err`
- [ ] Permissões estão corretas: `ls -la /var/lib/taskchampion-sync-server/`
- [ ] Backup existe: `ls -la /var/backup/taskchampion/`
