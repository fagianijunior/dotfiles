# ArchiSteamFarm - Valores de Configuração

Este documento lista os valores numéricos corretos para as configurações do ASF.

## FarmingOrders (Ordem de Farm)

Valores numéricos que definem a ordem de farming:

| Valor | Nome | Descrição |
|-------|------|-----------|
| 0 | Unplayed | Prioriza jogos não jogados |
| 1 | HoursAscending | Jogos com menos horas primeiro |
| 2 | HoursDescending | Jogos com mais horas primeiro |
| 3 | MarketableAscending | Jogos com menos cartas vendáveis primeiro |
| 4 | MarketableDescending | Jogos com mais cartas vendáveis primeiro |
| 5 | Random | Ordem aleatória |
| 6 | BadgeLevelAscending | Badges com menor nível primeiro |
| 7 | BadgeLevelDescending | Badges com maior nível primeiro |
| 8 | RedeemDateTimesAscending | Jogos resgatados mais recentemente primeiro |
| 9 | RedeemDateTimesDescending | Jogos resgatados há mais tempo primeiro |

**Exemplo de uso:**
```json
"FarmingOrders": [0, 1]
```
Isso fará o ASF priorizar jogos não jogados, e dentro deles, começar pelos com menos horas.

## OnlineStatus (Status Online)

| Valor | Nome | Descrição |
|-------|------|-----------|
| 0 | Offline | Aparece como offline |
| 1 | Online | Aparece como online |
| 2 | Busy | Aparece como ocupado |
| 3 | Away | Aparece como ausente |
| 4 | Snooze | Aparece como sonolento |
| 5 | LookingToTrade | Procurando trocar |
| 6 | LookingToPlay | Procurando jogar |
| 7 | Invisible | Invisível |

## FarmingPreferences (Preferências de Farm)

| Valor | Nome | Descrição |
|-------|------|-----------|
| 0 | None | Sem preferências especiais |
| 1 | FarmingPausedByDefault | Farm pausado por padrão |
| 2 | ShutdownOnFarmingFinished | Desligar quando terminar |
| 4 | SendOnFarmingFinished | Enviar itens quando terminar |
| 8 | FarmPriorityQueueOnly | Farm apenas fila prioritária |
| 16 | SkipRefundableGames | Pular jogos reembolsáveis |
| 32 | SkipUnplayedGames | Pular jogos não jogados |
| 64 | EnableRiskyCardsDiscovery | Habilitar descoberta arriscada |

**Nota:** Valores podem ser combinados somando-os.

## BotBehaviour (Comportamento do Bot)

| Valor | Nome | Descrição |
|-------|------|-----------|
| 0 | None | Comportamento padrão |
| 1 | RejectInvalidFriendInvites | Rejeitar convites inválidos |
| 2 | RejectInvalidTrades | Rejeitar trocas inválidas |
| 4 | RejectInvalidGroupInvites | Rejeitar convites de grupo inválidos |
| 8 | DismissInventoryNotifications | Dispensar notificações de inventário |
| 16 | MarkReceivedMessagesAsRead | Marcar mensagens como lidas |
| 32 | MarkBotMessagesAsRead | Marcar mensagens do bot como lidas |

**Nota:** Valores podem ser combinados somando-os.

## PasswordFormat (Formato da Senha)

| Valor | Nome | Descrição |
|-------|------|-----------|
| 0 | PlainText | Texto plano (padrão) |
| 1 | AES | Criptografado com AES |
| 2 | ProtectedDataForCurrentUser | Protegido para usuário atual (Windows) |

## TradingPreferences (Preferências de Troca)

| Valor | Nome | Descrição |
|-------|------|-----------|
| 0 | None | Sem preferências |
| 1 | AcceptDonations | Aceitar doações |
| 2 | SteamTradeMatcher | Usar STM |
| 4 | MatchEverything | Combinar tudo |
| 8 | DontAcceptBotTrades | Não aceitar trocas de bots |
| 16 | MatchActively | Combinar ativamente |

## RedeemingPreferences (Preferências de Resgate)

| Valor | Nome | Descrição |
|-------|------|-----------|
| 0 | None | Sem preferências |
| 1 | Forwarding | Encaminhar keys não usadas |
| 2 | Distributing | Distribuir keys |
| 4 | KeepMissingGames | Manter jogos faltantes |
| 8 | AssumeWalletKeyOnBadActivationCode | Assumir key de carteira em código ruim |

## LootableTypes / TransferableTypes / MatchableTypes

Tipos de itens para diferentes operações:

| Valor | Nome | Descrição |
|-------|------|-----------|
| 0 | Unknown | Desconhecido |
| 1 | BoosterPack | Pacotes de reforço |
| 2 | Emoticon | Emoticons |
| 3 | FoilTradingCard | Cartas brilhantes |
| 4 | ProfileBackground | Fundos de perfil |
| 5 | TradingCard | Cartas normais |
| 6 | SteamGems | Gemas Steam |
| 7 | SaleItem | Itens de venda |
| 8 | Consumable | Consumíveis |
| 9 | ProfileModifier | Modificadores de perfil |
| 10 | Sticker | Adesivos |
| 11 | ChatEffect | Efeitos de chat |
| 12 | MiniProfileBackground | Fundos de mini perfil |
| 13 | AvatarProfileFrame | Molduras de avatar |
| 14 | AnimatedAvatar | Avatares animados |
| 15 | KeyboardSkin | Skins de teclado |
| 16 | StartupVideo | Vídeos de inicialização |

**Exemplo comum:**
```json
"LootableTypes": [1, 3, 5]
```
Isso permite enviar: Pacotes de reforço, Cartas brilhantes e Cartas normais.

## Referências

- [Documentação oficial de configuração](https://github.com/JustArchiNET/ArchiSteamFarm/wiki/Configuration)
- [Schema JSON completo](https://raw.githubusercontent.com/JustArchiNET/ArchiSteamFarm/main/ArchiSteamFarm/config/Bot.schema.json)
