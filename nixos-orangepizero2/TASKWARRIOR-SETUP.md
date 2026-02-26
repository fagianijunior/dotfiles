# Taskchampion Sync Server - Guia Completo de Instalação

Este documento resume todo o processo de instalação e configuração do taskchampion-sync-server no Orange Pi Zero 2.

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Instalação no Servidor](#instalação-no-servidor)
3. [Configuração do Cliente](#configuração-do-cliente)
4. [Verificação](#verificação)
5. [Documentação Adicional](#documentação-adicional)

## 🎯 Visão Geral

O taskchampion-sync-server é o servidor de sincronização oficial para Taskwarrior 3. Ele permite sincronizar suas tarefas entre múltiplos dispositivos de forma simples e eficiente.

### Características

- ✅ Leve e eficiente (perfeito para ARM)
- ✅ Sem necessidade de banco de dados externo
- ✅ Suporta múltiplos clientes
- ✅ Integração nativa com Taskwarrior 3
- ✅ Configuração via NixOS (declarativa e reproduzível)

### Arquitetura

```
┌─────────────┐         ┌─────────────┐         ┌─────────────┐
│   Desktop   │         │  Orange Pi  │         │   Laptop    │
│             │◄───────►│             │◄───────►│             │
│ Taskwarrior │  HTTP   │ Sync Server │  HTTP   │ Taskwarrior │
│   Client    │  8080   │   (8080)    │  8080   │   Client    │
└─────────────┘         └─────────────┘         └─────────────┘
```

## 🖥️ Instalação no Servidor

### 1. Configuração já está pronta!

O módulo já foi criado e configurado em:
- `nixos-orangepizero2/modules/taskchampion-sync-server.nix`
- `nixos-orangepizero2/orangepizero2.nix`

### 2. Build e Deploy

#### Opção A: Build local no Orange Pi (recomendado)

```bash
# SSH no Orange Pi
ssh orangepizero2

# Navegar para o diretório do dotfiles
cd /caminho/para/dotfiles

# Build e aplicar
sudo nixos-rebuild switch --flake .#orangepizero2
```

#### Opção B: Build remoto do seu desktop

```bash
# Do seu desktop
nixos-rebuild switch --flake .#orangepizero2 --target-host root@orangepizero2
```

### 3. Verificar instalação

```bash
# Copiar e executar script de teste
scp nixos-orangepizero2/scripts/test-taskchampion.sh orangepizero2:/tmp/
ssh orangepizero2 'bash /tmp/test-taskchampion.sh'
```

Ou localmente no Orange Pi:

```bash
./nixos-orangepizero2/scripts/test-taskchampion.sh
```

### 4. Verificar serviço

```bash
# Status
ssh orangepizero2 'sudo systemctl status taskchampion-sync-server'

# Logs
ssh orangepizero2 'sudo journalctl -u taskchampion-sync-server -f'

# Porta aberta
ssh orangepizero2 'sudo ss -tlnp | grep :8080'
```

## 💻 Configuração do Cliente

### Opção 1: Configuração Manual (Simples)

```bash
# 1. Gerar UUID único
CLIENT_ID=$(uuidgen)
echo "Seu UUID: $CLIENT_ID"

# 2. Configurar Taskwarrior
task config sync.server.origin http://orangepizero2:8080
task config sync.server.client_id $CLIENT_ID

# 3. Inicializar sincronização (primeira vez)
task sync init

# 4. Sincronizar
task sync
```

### Opção 2: Configuração via Home-Manager (Recomendado)

#### Passo 1: Configurar sync-config.nix

```bash
# Gerar UUID
uuidgen

# Editar arquivo
vim home/taskwarrior/sync-config.nix
```

Substitua:
```nix
clientId = "SUBSTITUA-PELO-SEU-UUID-UNICO";
```

#### Passo 2: Importar no default.nix

Edite `home/taskwarrior/default.nix`:

```nix
{
  imports = [
    ./systemd-services.nix
    ./sync-config.nix  # <-- Adicione
  ];
  
  # ... resto da configuração
}
```

#### Passo 3: Aplicar configuração

```bash
# Se usar home-manager standalone
home-manager switch

# Se usar home-manager como módulo do NixOS
sudo nixos-rebuild switch
```

#### Passo 4: Inicializar

```bash
# Verificar configuração
task show | grep sync

# Inicializar
task-sync-init

# Verificar status
task-sync-status
```

### Opção 3: Com Sincronização Automática (Avançado)

Para habilitar sincronização automática a cada 15 minutos:

1. Edite `home/taskwarrior/sync-services.nix`:
```nix
syncEnabled = true;  # Mudar para true
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
task-sync-services
```

## ✅ Verificação

### Checklist de Instalação

- [ ] Servidor está rodando: `systemctl status taskchampion-sync-server`
- [ ] Porta 8080 está aberta: `ss -tlnp | grep :8080`
- [ ] Firewall permite conexões: `iptables -L -n | grep 8080`
- [ ] Cliente consegue pingar: `ping orangepizero2`
- [ ] Cliente consegue acessar: `curl http://orangepizero2:8080`
- [ ] Configuração do cliente está correta: `task show | grep sync`
- [ ] Primeira sincronização funcionou: `task sync init`
- [ ] Sincronizações subsequentes funcionam: `task sync`

### Teste Completo

```bash
# 1. No cliente, adicionar tarefa
task add "Teste de sincronização"

# 2. Sincronizar
task sync

# 3. Em outro dispositivo, sincronizar
task sync

# 4. Verificar se a tarefa aparece
task list
```

## 📚 Documentação Adicional

### Guias Detalhados

- [📖 Setup Completo](./docs/taskwarrior-sync-setup.md) - Configuração detalhada e casos de uso
- [🔒 Segurança](./docs/taskwarrior-security.md) - Boas práticas, VPN, túnel SSH, HTTPS
- [🔧 Troubleshooting](./docs/taskwarrior-troubleshooting.md) - Resolução de problemas comuns
- [⚡ Referência Rápida](./docs/taskwarrior-quick-reference.md) - Comandos essenciais

### Configuração Home-Manager

- [SYNC-README.md](../home/taskwarrior/SYNC-README.md) - Guia de configuração do cliente
- [sync-config.nix](../home/taskwarrior/sync-config.nix) - Configuração básica
- [sync-services.nix](../home/taskwarrior/sync-services.nix) - Serviços automáticos

## 🚀 Próximos Passos

### Básico
1. ✅ Instalar servidor no Orange Pi
2. ✅ Configurar cliente no desktop
3. ✅ Testar sincronização
4. ⏭️ Configurar segundo dispositivo (laptop)

### Intermediário
5. ⏭️ Habilitar sincronização automática
6. ⏭️ Configurar backups automáticos
7. ⏭️ Adicionar monitoramento

### Avançado
8. ⏭️ Configurar túnel SSH ou VPN
9. ⏭️ Adicionar HTTPS com Caddy
10. ⏭️ Integrar com outros serviços

## 🆘 Suporte

### Problemas Comuns

1. **Servidor não responde**
   ```bash
   ssh orangepizero2 'sudo systemctl restart taskchampion-sync-server'
   ```

2. **Erro de sincronização**
   ```bash
   task sync rc.verbose=on
   ```

3. **Conflitos de dados**
   ```bash
   task export > backup.json
   task sync init
   ```

### Obter Ajuda

- Consulte o [Troubleshooting Guide](./docs/taskwarrior-troubleshooting.md)
- Veja os logs: `journalctl -u taskchampion-sync-server`
- Execute o script de teste: `./scripts/test-taskchampion.sh`

## 📝 Notas

### Segurança

- Por padrão, o servidor aceita conexões de qualquer IP na rede local
- Para uso em rede não confiável, configure túnel SSH ou VPN
- Consulte o [Guia de Segurança](./docs/taskwarrior-security.md)

### Backup

- Dados do servidor: `/var/lib/taskchampion-sync-server/`
- Backup manual: `tar -czf backup.tar.gz /var/lib/taskchampion-sync-server/`
- Backup automático: Configure via `sync-services.nix`

### Performance

- O servidor é leve e roda bem no Orange Pi Zero 2
- Sincronização é rápida mesmo com centenas de tarefas
- Não há limite de clientes conectados

## 🎉 Conclusão

Você agora tem um servidor de sincronização do Taskwarrior rodando no seu Orange Pi Zero 2!

Para começar a usar:

```bash
# No cliente
task add "Minha primeira tarefa sincronizada"
task sync
```

Aproveite! 🚀
