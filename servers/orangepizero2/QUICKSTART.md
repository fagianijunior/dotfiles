# Guia Rápido - Orange Pi Zero 2

Primeiros passos após instalar o NixOS no Orange Pi Zero 2.

## 🚀 Deploy Inicial

### 1. Build e Deploy

```bash
# Do seu desktop, fazer deploy remoto
cd ~/dotfiles
sudo nixos-rebuild switch --flake .#orangepizero2 --target-host root@orangepizero2

# Ou localmente no Orange Pi
ssh orangepizero2
cd /root/dotfiles
sudo nixos-rebuild switch --flake .#orangepizero2
```

### 2. Verificar Serviços

```bash
# Testar tudo de uma vez
ssh orangepizero2 'bash -s' < orangepizero2/scripts/test-taskchampion.sh

# Ou verificar individualmente
ssh orangepizero2 'sudo systemctl status taskchampion-sync-server'
ssh orangepizero2 'sudo systemctl status tailscaled'
```

## 🔐 Configurar Tailscale

### 1. Autenticar Orange Pi

```bash
# SSH no Orange Pi
ssh orangepizero2

# Iniciar Tailscale
sudo tailscale up

# Copiar a URL mostrada e abrir no navegador
# Exemplo: https://login.tailscale.com/a/xxxxxxxxxxxxx

# Fazer login e autorizar o dispositivo
```

### 2. Verificar Conexão

```bash
# Ver status
sudo tailscale status

# Ver IP
sudo tailscale ip -4
# Anote este IP! Exemplo: 100.64.0.1
```

### 3. Configurar Outros Dispositivos

```bash
# No seu desktop/laptop
# Instalar Tailscale (se ainda não tiver)
curl -fsSL https://tailscale.com/install.sh | sh

# Conectar
sudo tailscale up

# Verificar se vê o Orange Pi
tailscale status | grep orangepizero2
```

### 4. Habilitar MagicDNS (Recomendado)

1. Acesse https://login.tailscale.com/admin/dns
2. Clique em "Enable MagicDNS"
3. Agora você pode usar `orangepizero2` ao invés do IP

## 📝 Configurar Taskwarrior

### 1. No Cliente (Desktop/Laptop)

```bash
# Gerar UUID único
CLIENT_ID=$(uuidgen)
echo "UUID do cliente: $CLIENT_ID"
# Anote este UUID!

# Opção A: Com Tailscale (Recomendado)
task config sync.server.origin http://orangepizero2:8080
task config sync.server.client_id $CLIENT_ID

# Opção B: Sem Tailscale (apenas rede local)
task config sync.server.origin http://192.168.1.X:8080  # IP local do Orange Pi
task config sync.server.client_id $CLIENT_ID
```

### 2. Inicializar Sincronização

```bash
# Primeira vez (envia tarefas locais para servidor)
task sync init

# Verificar
task sync
```

### 3. Testar

```bash
# Adicionar tarefa
task add "Teste de sincronização"

# Sincronizar
task sync

# Em outro dispositivo, sincronizar
task sync

# Verificar se a tarefa aparece
task list
```

## 🏠 Configurar via Home-Manager (Opcional)

### 1. Editar Configuração

```bash
# Editar sync-config.nix
vim home/taskwarrior/sync-config.nix

# Substituir:
clientId = "SUBSTITUA-PELO-SEU-UUID-UNICO";

# Por:
clientId = "seu-uuid-aqui";  # UUID gerado anteriormente

# Se usar Tailscale:
serverOrigin = "http://orangepizero2:8080";

# Se não usar Tailscale:
serverOrigin = "http://192.168.1.X:8080";
```

### 2. Importar no default.nix

```bash
# Editar home/taskwarrior/default.nix
vim home/taskwarrior/default.nix

# Adicionar aos imports:
imports = [
  ./systemd-services.nix
  ./sync-config.nix  # <-- Adicionar esta linha
];
```

### 3. Aplicar

```bash
# Se usar home-manager standalone
home-manager switch

# Se usar home-manager como módulo do NixOS
sudo nixos-rebuild switch
```

### 4. Usar Scripts Helper

```bash
# Inicializar
task-sync-init

# Ver status
task-sync-status

# Sincronizar
task sync
```

## ✅ Checklist de Configuração

### Servidor
- [ ] NixOS instalado no Orange Pi
- [ ] Deploy realizado com sucesso
- [ ] Taskchampion-sync-server rodando
- [ ] Tailscale autenticado
- [ ] IP do Tailscale anotado

### Cliente
- [ ] Taskwarrior 3.x instalado
- [ ] UUID único gerado
- [ ] Configuração do sync feita
- [ ] Primeira sincronização (sync init) realizada
- [ ] Teste de sincronização funcionando

### Opcional
- [ ] MagicDNS habilitado
- [ ] Configuração via home-manager
- [ ] Sincronização automática configurada
- [ ] Outros dispositivos configurados

## 🎯 Próximos Passos

### Básico
1. ✅ Servidor configurado
2. ✅ Tailscale funcionando
3. ✅ Cliente sincronizando
4. ⏭️ Configurar segundo dispositivo (laptop)

### Intermediário
5. ⏭️ Habilitar sincronização automática
6. ⏭️ Configurar backups automáticos
7. ⏭️ Explorar recursos do Tailscale (exit node, subnet router)

### Avançado
8. ⏭️ Configurar ACLs no Tailscale
9. ⏭️ Adicionar monitoramento
10. ⏭️ Integrar com outros serviços

## 📚 Documentação

### Essencial
- [TASKWARRIOR-SETUP.md](./TASKWARRIOR-SETUP.md) - Setup completo do Taskwarrior
- [docs/tailscale-setup.md](./docs/tailscale-setup.md) - Guia completo do Tailscale

### Referência
- [docs/taskwarrior-quick-reference.md](./docs/taskwarrior-quick-reference.md) - Comandos rápidos
- [docs/taskwarrior-security.md](./docs/taskwarrior-security.md) - Segurança
- [docs/taskwarrior-troubleshooting.md](./docs/taskwarrior-troubleshooting.md) - Problemas

### Avançado
- [ARCHITECTURE.md](./ARCHITECTURE.md) - Arquitetura do sistema
- [Makefile](./Makefile) - Automação de tarefas

## 🛠️ Comandos Úteis

### Makefile (Recomendado)

```bash
cd orangepizero2/

make help              # Ver todos os comandos
make test              # Testar servidor
make status            # Ver status
make logs              # Ver logs
make tailscale-status  # Status do Tailscale
make tailscale-ip      # IP do Tailscale
```

### Manuais

```bash
# Servidor
ssh orangepizero2 'sudo systemctl status taskchampion-sync-server'
ssh orangepizero2 'sudo systemctl status tailscaled'
ssh orangepizero2 'sudo tailscale status'

# Cliente
task sync
task-sync-status  # Se configurou via home-manager
```

## 🐛 Problemas Comuns

### Servidor não responde

```bash
# Verificar se está rodando
ssh orangepizero2 'sudo systemctl status taskchampion-sync-server'

# Reiniciar
ssh orangepizero2 'sudo systemctl restart taskchampion-sync-server'

# Ver logs
ssh orangepizero2 'sudo journalctl -u taskchampion-sync-server -n 50'
```

### Tailscale não conecta

```bash
# Verificar status
ssh orangepizero2 'sudo tailscale status'

# Reconectar
ssh orangepizero2 'sudo tailscale up'

# Ver logs
ssh orangepizero2 'sudo journalctl -u tailscaled -n 50'
```

### Erro de sincronização

```bash
# Ver configuração
task show | grep sync

# Testar conectividade
ping orangepizero2  # Se usar Tailscale
curl http://orangepizero2:8080

# Sincronizar com verbose
task sync rc.verbose=on
```

## 💡 Dicas

1. **Use Tailscale**: Facilita muito o acesso remoto
2. **Habilite MagicDNS**: Use hostnames ao invés de IPs
3. **Configure home-manager**: Configuração declarativa é melhor
4. **Faça backups**: `make backup` regularmente
5. **Monitore logs**: `make logs` ocasionalmente

## 🎉 Pronto!

Seu Orange Pi Zero 2 está configurado e pronto para sincronizar suas tarefas do Taskwarrior de qualquer lugar!

Para mais detalhes, consulte a documentação completa em:
- [SUMMARY.md](./SUMMARY.md) - Resumo de tudo
- [README.md](./README.md) - README principal
