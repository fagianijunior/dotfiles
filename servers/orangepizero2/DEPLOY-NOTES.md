# Notas de Deploy - Orange Pi Zero 2

## ⚠️ Mudança Importante

O NixOS já possui um módulo oficial para `taskchampion-sync-server`, então removemos nosso módulo customizado e estamos usando o oficial.

## 📝 Mudanças na Configuração

### Antes (módulo customizado)
```nix
services.taskchampion-sync-server = {
  enable = true;
  port = 8080;
  address = "0.0.0.0";
  openFirewall = true;
};
```

### Agora (módulo oficial)
```nix
services.taskchampion-sync-server = {
  enable = true;
  host = "0.0.0.0";      # Era "address"
  port = 8080;
  openFirewall = true;
  dataDir = "/var/lib/taskchampion-sync-server";
  snapshot = {
    versions = 100;
    days = 14;
  };
};
```

## 🚀 Como Fazer o Deploy

### Opção 1: Deploy Remoto (do seu desktop)

```bash
# Do diretório dotfiles
sudo nixos-rebuild switch --flake .#orangepizero2 --target-host root@orangepizero2
```

### Opção 2: Deploy Local (no Orange Pi)

```bash
# SSH no Orange Pi
ssh orangepizero2

# Navegar para o diretório
cd /root/dotfiles  # ou onde estiver o dotfiles

# Fazer pull das mudanças
git pull

# Aplicar
sudo nixos-rebuild switch --flake .#orangepizero2
```

### Opção 3: Usando o Makefile

```bash
# Do diretório orangepizero2/
make deploy
```

## ✅ Verificar Após Deploy

```bash
# Verificar se o serviço está rodando
ssh orangepizero2 'sudo systemctl status taskchampion-sync-server'

# Verificar Tailscale
ssh orangepizero2 'sudo systemctl status tailscaled'

# Executar script de teste
ssh orangepizero2 'bash -s' < scripts/test-taskchampion.sh

# Ou usar Makefile
make test
```

## 🔧 Configurar Tailscale (Primeira Vez)

```bash
# SSH no Orange Pi
ssh orangepizero2

# Iniciar Tailscale
sudo tailscale up

# Copiar a URL mostrada e abrir no navegador
# Exemplo: https://login.tailscale.com/a/xxxxxxxxxxxxx

# Fazer login e autorizar o dispositivo
```

## 📊 Opções do Módulo Oficial

O módulo oficial suporta:

- `enable` - Habilitar/desabilitar serviço
- `package` - Pacote a usar (padrão: pkgs.taskchampion-sync-server)
- `user` - Usuário do sistema (padrão: "taskchampion")
- `group` - Grupo do sistema (padrão: "taskchampion")
- `host` - Endereço para escutar (padrão: "127.0.0.1")
- `port` - Porta (padrão: 10222, mudamos para 8080)
- `openFirewall` - Abrir porta no firewall
- `dataDir` - Diretório de dados
- `snapshot.versions` - Versões entre snapshots (padrão: 100)
- `snapshot.days` - Dias entre snapshots (padrão: 14)
- `allowClientIds` - Lista de client IDs permitidos (vazio = todos)

## 🔐 Segurança Adicional (Opcional)

Se quiser restringir acesso apenas a clientes específicos:

```nix
services.taskchampion-sync-server = {
  enable = true;
  host = "0.0.0.0";
  port = 8080;
  openFirewall = true;
  allowClientIds = [
    "uuid-do-desktop"
    "uuid-do-laptop"
  ];
};
```

## 📚 Documentação

Toda a documentação criada continua válida:

- [QUICKSTART.md](./QUICKSTART.md) - Primeiros passos
- [TASKWARRIOR-SETUP.md](./TASKWARRIOR-SETUP.md) - Setup completo
- [docs/tailscale-setup.md](./docs/tailscale-setup.md) - Guia do Tailscale
- [docs/taskwarrior-security.md](./docs/taskwarrior-security.md) - Segurança
- [docs/taskwarrior-troubleshooting.md](./docs/taskwarrior-troubleshooting.md) - Problemas

## 🐛 Se Algo Der Errado

### Erro: Porta já em uso

```bash
# Verificar o que está usando a porta 8080
ssh orangepizero2 'sudo ss -tlnp | grep :8080'

# Se necessário, mudar a porta na configuração
```

### Erro: Serviço não inicia

```bash
# Ver logs
ssh orangepizero2 'sudo journalctl -u taskchampion-sync-server -n 50'

# Verificar permissões
ssh orangepizero2 'sudo ls -la /var/lib/taskchampion-sync-server/'
```

### Erro: Tailscale não conecta

```bash
# Verificar status
ssh orangepizero2 'sudo tailscale status'

# Reconectar
ssh orangepizero2 'sudo tailscale up'
```

## 📝 Checklist de Deploy

- [ ] Commit das mudanças no git
- [ ] Push para o repositório (se aplicável)
- [ ] Deploy realizado com sucesso
- [ ] Serviço taskchampion-sync-server rodando
- [ ] Serviço tailscaled rodando
- [ ] Tailscale autenticado
- [ ] Porta 8080 acessível
- [ ] Script de teste executado com sucesso
- [ ] Cliente configurado e testado

## 🎉 Pronto!

Após o deploy, siga o [QUICKSTART.md](./QUICKSTART.md) para configurar o Tailscale e o cliente Taskwarrior.
