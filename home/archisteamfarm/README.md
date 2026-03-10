# ArchiSteamFarm - Configuração

Este módulo configura o ArchiSteamFarm apenas no host **nobita**.

## Arquitetura

- **Pacote**: Instalado via `modules/profiles/gaming.nix` (nível sistema)
- **Configuração**: Gerenciada via `home/archisteamfarm/default.nix` (nível usuário)
- **Serviço**: systemd user service (roda como usuário, não como root)

## Estrutura de Arquivos

```
~/.config/ArchiSteamFarm/
├── config/
│   ├── ASF.json          # Configuração global (gerenciada pelo Nix)
│   └── BotName.json      # Configuração de cada bot (você cria manualmente)
├── logs/                 # Logs do ASF
└── database/             # Dados persistentes
```

## Configurando suas Contas Steam

### 1. Criar arquivo de configuração do bot

Crie um arquivo para cada conta Steam em `~/.config/ArchiSteamFarm/config/`:

```bash
nano ~/.config/ArchiSteamFarm/config/MeuBot.json
```

### 2. Configuração básica do bot (sem MFA)

```json
{
  "Enabled": true,
  "SteamLogin": "seu_usuario_steam",
  "SteamPassword": "sua_senha_steam",
  "FarmingOrders": [
    "Unplayed",
    "HoursAscending"
  ],
  "AutoSteamSaleEvent": true,
  "SendTradePeriod": 0,
  "AcceptGifts": true,
  "BotBehaviour": 0,
  "CustomGamePlayedWhileFarming": "",
  "CustomGamePlayedWhileIdle": "",
  "FarmingPreferences": 0,
  "GamesPlayedWhileIdle": [],
  "HoursUntilCardDrops": 3,
  "LootableTypes": [
    1,
    3,
    5
  ],
  "MatchableTypes": [
    5
  ],
  "OnlineStatus": 1,
  "PasswordFormat": 0,
  "RedeemingPreferences": 0,
  "SendOnFarmingFinished": false,
  "ShutdownOnFarmingFinished": false,
  "SteamMasterClanID": 0,
  "SteamParentalCode": "",
  "SteamTradeToken": "",
  "SteamUserPermissions": {},
  "TradingPreferences": 0,
  "TransferableTypes": [
    1,
    3,
    5
  ],
  "UseLoginKeys": true
}
```

### 3. Gerenciar o serviço

```bash
# Iniciar o serviço
systemctl --user start archisteamfarm

# Parar o serviço
systemctl --user stop archisteamfarm

# Ver status
systemctl --user status archisteamfarm

# Ver logs
journalctl --user -u archisteamfarm -f

# Habilitar para iniciar automaticamente
systemctl --user enable archisteamfarm

# Desabilitar início automático
systemctl --user disable archisteamfarm
```

### 4. Interface Web (IPC)

Após iniciar o serviço, acesse a interface web em:

```
http://localhost:1242
```

## Configurações Importantes

### Farming Orders (Ordem de Farm)

- `Unplayed`: Prioriza jogos não jogados
- `HoursAscending`: Jogos com menos horas primeiro
- `HoursDescending`: Jogos com mais horas primeiro

### Farming Preferences

- `0`: Padrão (farm todos os jogos)
- `1`: Farm apenas jogos com drops restantes
- `2`: Farm apenas jogos com mais de X horas

### Online Status

- `0`: Offline
- `1`: Online
- `2`: Busy
- `3`: Away
- `4`: Snooze
- `5`: LookingToTrade
- `6`: LookingToPlay
- `7`: Invisible

## Segurança

⚠️ **IMPORTANTE**: 
- Nunca compartilhe seus arquivos de configuração (contêm suas credenciais)
- O arquivo `.gitignore` já está configurado para ignorar `~/.config/ArchiSteamFarm/config/*.json`
- Considere usar `PasswordFormat` com hash se preferir não armazenar senha em texto plano

## Recursos Adicionais

- [Valores de Configuração](./CONFIG_VALUES.md) - Referência de valores numéricos
- [Documentação Oficial](https://github.com/JustArchiNET/ArchiSteamFarm/wiki)
- [Configuração de Bots](https://github.com/JustArchiNET/ArchiSteamFarm/wiki/Configuration#bot-config)
- [Comandos](https://github.com/JustArchiNET/ArchiSteamFarm/wiki/Commands)

## Troubleshooting

### Bot não conecta

1. Verifique suas credenciais no arquivo de configuração
2. Certifique-se de que o MFA está desabilitado
3. Verifique os logs: `journalctl --user -u archisteamfarm -f`

### Interface web não abre

1. Verifique se o serviço está rodando: `systemctl --user status archisteamfarm`
2. Verifique se a porta 1242 está livre: `ss -tlnp | grep 1242`
3. Tente acessar: `http://127.0.0.1:1242`

### Permissões

Se tiver problemas de permissão, verifique:
```bash
ls -la ~/.config/ArchiSteamFarm/
```

Todos os arquivos devem pertencer ao seu usuário.
