# Instalação do ArchiSteamFarm no Nobita

## Passo 1: Rebuild do Sistema

Execute o rebuild do NixOS no host Nobita:

```bash
cd ~/Workspace/fagianijunior/dotfiles
sudo nixos-rebuild switch --flake .#nobita
```

Isso irá:
- Instalar o pacote ArchiSteamFarm (via modules/profiles/gaming.nix)
- Criar o serviço systemd user
- Configurar a estrutura de diretórios em `~/.config/ArchiSteamFarm`

## Passo 2: Configurar Bot

### Opção A: Script Automático (Recomendado)

```bash
cd ~/Workspace/fagianijunior/dotfiles/home/archisteamfarm
./setup-bot.sh
```

### Opção B: Manual

```bash
# Copiar template
cp ~/Workspace/fagianijunior/dotfiles/home/archisteamfarm/bot-template.json \
   ~/.config/ArchiSteamFarm/config/MeuBot.json

# Editar configuração
nano ~/.config/ArchiSteamFarm/config/MeuBot.json
```

Substitua:
- `SEU_USUARIO_STEAM` → seu usuário Steam
- `SUA_SENHA_STEAM` → sua senha Steam

## Passo 3: Iniciar Serviço

```bash
# Iniciar o serviço
systemctl --user start archisteamfarm

# Habilitar para iniciar automaticamente no boot
systemctl --user enable archisteamfarm

# Verificar status
systemctl --user status archisteamfarm

# Ver logs
journalctl --user -u archisteamfarm -f
```

## Passo 4: Acessar Interface Web

Abra no navegador:
```
http://localhost:1242
```

## Verificação

Para verificar se tudo está funcionando:

1. **Serviço rodando:**
```bash
systemctl --user status archisteamfarm
```

Deve mostrar: `Active: active (running)`

2. **Logs sem erros:**
```bash
journalctl --user -u archisteamfarm -n 50
```

3. **Interface web acessível:**
- Abra `http://localhost:1242`
- Você deve ver o dashboard do ASF

4. **Bot conectado:**
- Na interface web, vá para "Bots"
- Seu bot deve aparecer como "Online"

## Troubleshooting

### Serviço não inicia

```bash
# Ver logs detalhados
journalctl --user -u archisteamfarm -xe

# Verificar se o diretório existe
ls -la ~/.config/ArchiSteamFarm/

# Verificar permissões
chmod 700 ~/.config/ArchiSteamFarm/
chmod 600 ~/.config/ArchiSteamFarm/config/*.json
```

### Bot não conecta ao Steam

1. Verifique as credenciais no arquivo de configuração
2. Certifique-se de que o MFA está desabilitado
3. Tente fazer login manualmente no Steam para verificar se há algum bloqueio

### Interface web não abre

```bash
# Verificar se a porta está em uso
ss -tlnp | grep 1242

# Tentar acessar via localhost
curl http://localhost:1242
```

## Próximos Passos

Após a instalação bem-sucedida:

1. Leia o [QUICKSTART.md](./QUICKSTART.md) para uso básico
2. Consulte [README.md](./README.md) para configurações avançadas
3. Veja [COMMANDS.md](./COMMANDS.md) para comandos úteis

## Desinstalação

Se precisar remover o ArchiSteamFarm:

1. Parar e desabilitar o serviço:
```bash
systemctl --user stop archisteamfarm
systemctl --user disable archisteamfarm
```

2. Remover dados (opcional):
```bash
rm -rf ~/.config/ArchiSteamFarm/
```

3. Remover do flake (comentar ou remover a linha no `home/default.nix`):
```nix
# ./archisteamfarm
```

4. Rebuild:
```bash
sudo nixos-rebuild switch --flake .#nobita
```
