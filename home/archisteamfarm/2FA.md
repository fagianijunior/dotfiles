# ArchiSteamFarm - 2FA (Autenticação de Dois Fatores)

## ✅ Status: 2FA Ativado!

O ASF 2FA foi configurado com sucesso para o bot **FarmCard**.

## 🔑 Informações Importantes

**⚠️ GUARDE ISSO EM LOCAL SEGURO:**

- **Revocation Code:** `R44563`
- **Arquivo:** `~/.config/ArchiSteamFarm/config/FarmCard.maFile.NEW`

O **Revocation Code** é necessário para remover o 2FA se você perder acesso. Anote em um lugar seguro!

## 📱 Como Usar

### Gerar Código 2FA

Quando você precisar de um código de autenticação (para login no Steam, por exemplo):

```bash
# Via API
curl -X POST http://127.0.0.1:1242/Api/Command \
  -H "Content-Type: application/json" \
  -d '{"Command":"2fa FarmCard"}'

# Ou via logs (se estiver rodando)
journalctl --user -u archisteamfarm -f
```

O código muda a cada 30 segundos (padrão TOTP).

### Confirmar Trocas/Vendas Automaticamente

O ASF pode confirmar automaticamente suas trocas e vendas no mercado. Para isso, adicione ao seu bot:

```json
{
  "TradingPreferences": 1,
  "AcceptConfirmations": true
}
```

## 🎯 Benefícios do ASF 2FA

✅ **Sem hold de 15 dias** - Venda cartas instantaneamente  
✅ **Trocas instantâneas** - Sem espera de 15 dias  
✅ **Confirmações automáticas** - ASF confirma trocas/vendas sozinho  
✅ **Códigos sempre disponíveis** - Gere códigos via comando  
✅ **Backup seguro** - Arquivo .maFile pode ser copiado  

## 🔄 Comandos Úteis

### Ver status do 2FA
```bash
curl -X POST http://127.0.0.1:1242/Api/Command \
  -H "Content-Type: application/json" \
  -d '{"Command":"2fastatus FarmCard"}'
```

### Gerar código
```bash
curl -X POST http://127.0.0.1:1242/Api/Command \
  -H "Content-Type: application/json" \
  -d '{"Command":"2fa FarmCard"}'
```

### Confirmar todas as pendências
```bash
curl -X POST http://127.0.0.1:1242/Api/Command \
  -H "Content-Type: application/json" \
  -d '{"Command":"2faok FarmCard"}'
```

## 📦 Backup do 2FA

**IMPORTANTE:** Faça backup do arquivo `.maFile`:

```bash
# Copiar para backup
cp ~/.config/ArchiSteamFarm/config/FarmCard.maFile.NEW ~/backup-2fa.maFile

# Ou visualizar o conteúdo
cat ~/.config/ArchiSteamFarm/config/FarmCard.maFile.NEW
```

Se você perder esse arquivo, precisará usar o **Revocation Code** para remover o 2FA e configurar novamente.

## 🔐 Segurança

- O arquivo `.maFile` contém as chaves secretas do seu autenticador
- **Nunca compartilhe** esse arquivo ou o Revocation Code
- Mantenha backup em local seguro
- O arquivo está protegido no `.gitignore`

## 🚨 Remover 2FA (Se Necessário)

Se precisar remover o 2FA:

```bash
curl -X POST http://127.0.0.1:1242/Api/Command \
  -H "Content-Type: application/json" \
  -d '{"Command":"2fano FarmCard"}'
```

Você precisará do **Revocation Code: R44563**

## 📱 Usar em Outro Dispositivo

Você pode importar o `.maFile` para outros aplicativos compatíveis:

1. **Steam Desktop Authenticator (SDA)** - Windows
2. **WinAuth** - Windows
3. Qualquer app que suporte importação de TOTP

O arquivo contém tudo que é necessário para gerar os códigos.

## ✨ Próximos Passos

Agora você pode:

1. ✅ Vender cartas no Mercado Steam **sem hold de 15 dias**
2. ✅ Fazer trocas **instantâneas**
3. ✅ Gerar códigos 2FA quando precisar fazer login
4. ✅ Deixar o ASF confirmar trocas/vendas automaticamente

## 📚 Referências

- [ASF 2FA Wiki](https://github.com/JustArchiNET/ArchiSteamFarm/wiki/Two-factor-authentication)
- [Comandos 2FA](https://github.com/JustArchiNET/ArchiSteamFarm/wiki/Commands#2fa-commands)
