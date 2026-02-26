# Taskwarrior Sync - Configuração Compartilhada

## 📋 Visão Geral

A sincronização do Taskwarrior usa variáveis de ambiente para compartilhar credenciais entre todos os dispositivos do usuário `terabytes`.

## 🔑 Variáveis de Ambiente

Definidas em `home/default.nix`:

- `TASKCHAMPION_CLIENT_ID`: ID único compartilhado entre todos os dispositivos
- `TASKCHAMPION_ENCRYPTION_SECRET`: Chave de criptografia compartilhada
- `TASKCHAMPION_SERVER_URL`: URL do servidor (orangepizero2:8080)

## 📁 Estrutura de Arquivos

```
home/taskwarrior/
├── default.nix              # Configuração principal
├── sync-config.nix          # Configuração de sincronização
├── systemd-services.nix     # Serviços systemd
├── migrate-to-shared-sync.sh # Script de migração
└── SYNC-README.md           # Este arquivo
```

## 🚀 Setup Inicial

### 1. Aplicar Configuração

```bash
home-manager switch
```

### 2. Verificar Variáveis de Ambiente

```bash
echo $TASKCHAMPION_CLIENT_ID
echo $TASKCHAMPION_SERVER_URL
```

Se não aparecerem, faça logout/login ou:

```bash
source ~/.profile
```

### 3. Migrar Dados Existentes

```bash
cd ~/dotfiles/home/taskwarrior
./migrate-to-shared-sync.sh
```

Este script vai:
- ✅ Fazer backup das tarefas atuais
- ✅ Limpar dados locais
- ✅ Reinicializar com client_id compartilhado
- ✅ Baixar tarefas do servidor

## 🔄 Uso Diário

### Sincronizar

```bash
task sync
```

### Verificar Status

```bash
task-sync-status
```

### Sincronização Automática

Para habilitar sync automático a cada 15 minutos, edite `sync-config.nix` e descomente a seção do systemd timer.

## 🖥️ Adicionar Novo Dispositivo

1. Clone o dotfiles no novo dispositivo
2. Aplique a configuração: `home-manager switch`
3. Inicialize: `task sync init`
4. Sincronize: `task sync`

Todas as tarefas serão compartilhadas automaticamente!

## 🔧 Troubleshooting

### Variáveis não estão definidas

```bash
# Recarregar perfil
source ~/.profile

# Ou fazer logout/login
```

### Tarefas não sincronizam

```bash
# Verificar configuração
task show | grep sync

# Sincronizar com verbose
task sync rc.verbose=on

# Ver logs do servidor
ssh orangepizero2 'sudo journalctl -u taskchampion-sync-server -f'
```

### Resetar sincronização

```bash
# Backup primeiro!
task export > backup.json

# Limpar e reinicializar
rm -rf ~/.local/share/task/*
task sync init
task sync
```

## 🔒 Segurança

As credenciais estão em `env.nix` que é commitado no git. Para produção, considere:

1. Usar `sops-nix` ou `agenix` para criptografar secrets
2. Usar variáveis de ambiente do sistema
3. Configurar HTTPS no servidor

## 📚 Referências

- [TASKWARRIOR-SETUP.md](../../nixos-orangepizero2/TASKWARRIOR-SETUP.md)
- [VALIDAR-SYNC.md](../../nixos-orangepizero2/VALIDAR-SYNC.md)
- [Taskwarrior Docs](https://taskwarrior.org/docs/)
