# ArchiSteamFarm - Guia Rápido

## Instalação

A instalação é automática ao fazer rebuild do sistema no host **nobita**:

```bash
sudo nixos-rebuild switch --flake .#nobita
```

## Configuração Rápida

### Opção 1: Script Automático (Recomendado)

```bash
cd ~/Workspace/fagianijunior/dotfiles/home/archisteamfarm
./setup-bot.sh
```

O script irá solicitar:
- Nome do bot
- Usuário Steam
- Senha Steam

### Opção 2: Manual

1. Copie o template:
```bash
cp ~/Workspace/fagianijunior/dotfiles/home/archisteamfarm/bot-template.json \
   ~/.config/ArchiSteamFarm/config/MeuBot.json
```

2. Edite o arquivo:
```bash
nano ~/.config/ArchiSteamFarm/config/MeuBot.json
```

3. Substitua:
   - `SEU_USUARIO_STEAM` → seu usuário
   - `SUA_SENHA_STEAM` → sua senha

## Iniciar o Serviço

```bash
# Iniciar
systemctl --user start archisteamfarm

# Habilitar para iniciar automaticamente
systemctl --user enable archisteamfarm

# Ver logs em tempo real
journalctl --user -u archisteamfarm -f
```

## Acessar Interface Web

A interface web (ASF-ui) não está incluída no pacote NixOS. Você pode gerenciar o ASF através de:

**API REST:**
```bash
# Ver status
curl http://localhost:1242/Api/ASF

# Ver bots
curl http://localhost:1242/Api/Bot/FarmCard
```

**Logs em tempo real:**
```bash
journalctl --user -u archisteamfarm -f
```

Se realmente precisar da interface web, você pode baixá-la manualmente do [repositório oficial](https://github.com/JustArchiNET/ASF-ui) e extrair em `~/.config/ArchiSteamFarm/www/`.

## Comandos Úteis

### Gerenciar Serviço
```bash
systemctl --user status archisteamfarm   # Ver status
systemctl --user stop archisteamfarm     # Parar
systemctl --user restart archisteamfarm  # Reiniciar
```

### Ver Logs
```bash
# Logs em tempo real
journalctl --user -u archisteamfarm -f

# Últimas 100 linhas
journalctl --user -u archisteamfarm -n 100

# Logs de hoje
journalctl --user -u archisteamfarm --since today
```

### Verificar Configuração
```bash
# Listar bots configurados
ls -la ~/.config/ArchiSteamFarm/config/*.json

# Ver configuração de um bot
cat ~/.config/ArchiSteamFarm/config/MeuBot.json
```

## Múltiplas Contas

Para adicionar mais contas Steam:

1. Crie um novo arquivo de configuração para cada conta:
```bash
./setup-bot.sh  # Execute novamente com outro nome
```

Ou manualmente:
```bash
cp ~/.config/ArchiSteamFarm/config/Bot1.json \
   ~/.config/ArchiSteamFarm/config/Bot2.json
```

2. Edite as credenciais do novo bot

3. Reinicie o serviço:
```bash
systemctl --user restart archisteamfarm
```

## Troubleshooting

### Bot não conecta
- Verifique se o MFA está desabilitado
- Confirme usuário e senha no arquivo de configuração
- Veja os logs: `journalctl --user -u archisteamfarm -f`

### Interface web não abre
- Verifique se o serviço está rodando: `systemctl --user status archisteamfarm`
- Tente: `http://127.0.0.1:1242`

### Erro de permissão
```bash
chmod 600 ~/.config/ArchiSteamFarm/config/*.json
```

## Recursos

- [README completo](./README.md) - Documentação detalhada
- [Documentação oficial](https://github.com/JustArchiNET/ArchiSteamFarm/wiki)
- [Comandos ASF](https://github.com/JustArchiNET/ArchiSteamFarm/wiki/Commands)
