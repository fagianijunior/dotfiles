# ArchiSteamFarm - Comandos Úteis

## Comandos via Interface Web (IPC)

Acesse `http://localhost:1242` e use a aba "Console" para executar comandos.

## Comandos Básicos

### Status e Informação

```
status                    # Status de todos os bots
status <bot>             # Status de um bot específico
stats                    # Estatísticas gerais
version                  # Versão do ASF
```

### Controle de Bots

```
start <bot>              # Iniciar um bot
stop <bot>               # Parar um bot
pause <bot>              # Pausar farming
resume <bot>             # Retomar farming
restart                  # Reiniciar ASF
```

### Farming

```
farm <bot>               # Forçar início do farming
loot <bot>               # Enviar itens para bot master
loot^ <bot>              # Enviar itens para todos os bots
```

### Jogos e Cards

```
owns <bot> <appid>       # Verificar se possui um jogo
owns <bot> <nome>        # Buscar jogo por nome
addlicense <bot> <id>    # Adicionar licença gratuita
play <bot> <appid>       # Jogar um jogo específico
```

### Redeem (Ativar Keys)

```
redeem <bot> <key>       # Ativar uma key
redeem^ <key>            # Ativar key em todos os bots
```

### Informações de Conta

```
balance <bot>            # Saldo da carteira Steam
level <bot>              # Nível da conta
2fa <bot>                # Gerar código 2FA (se configurado)
```

## Comandos Avançados

### Trading

```
trade <bot>              # Aceitar todas as trocas pendentes
trade <bot> <tradeid>    # Aceitar troca específica
```

### Configuração

```
privacy <bot> <settings> # Alterar configurações de privacidade
nickname <bot> <name>    # Alterar nickname
```

### Atualização

```
update                   # Verificar atualizações
update [channel]         # Atualizar para canal específico
```

## Exemplos Práticos

### Iniciar farming em um bot específico
```
start MeuBot
farm MeuBot
```

### Verificar status de todos os bots
```
status
```

### Ativar uma key em todos os bots
```
redeem^ XXXXX-XXXXX-XXXXX
```

### Pausar farming temporariamente
```
pause MeuBot
# ... fazer algo ...
resume MeuBot
```

### Verificar se possui um jogo
```
owns MeuBot 730  # Counter-Strike 2
owns MeuBot dota # Dota 2
```

## Comandos via CLI (Terminal)

Você também pode executar comandos diretamente via terminal:

```bash
# Executar comando único
echo "status" | nc localhost 1242

# Ou usando curl (se IPC estiver habilitado)
curl -X POST http://localhost:1242/Api/Command \
  -H "Content-Type: application/json" \
  -d '{"Command":"status"}'
```

## Prefixos de Comandos

- Sem prefixo: executa no bot padrão
- `<bot>`: executa em um bot específico
- `^`: executa em todos os bots

Exemplos:
```
status              # Status do bot padrão
status MeuBot       # Status do MeuBot
status^             # Status de todos os bots
```

## Permissões

Para executar comandos, você precisa ter permissões adequadas configuradas em `SteamUserPermissions` no arquivo de configuração do bot.

Níveis de permissão:
- `0`: None
- `1`: FamilySharing
- `2`: Operator
- `3`: Master

Exemplo de configuração:
```json
{
  "SteamUserPermissions": {
    "76561198012345678": 3
  }
}
```

## Recursos

- [Lista completa de comandos](https://github.com/JustArchiNET/ArchiSteamFarm/wiki/Commands)
- [API IPC](https://github.com/JustArchiNET/ArchiSteamFarm/wiki/IPC)
