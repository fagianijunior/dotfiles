#!/usr/bin/env bash
# Script para configurar um novo bot do ArchiSteamFarm

set -e

CONFIG_DIR="$HOME/.config/ArchiSteamFarm/config"
TEMPLATE_FILE="$(dirname "$0")/bot-template.json"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Configuração de Bot ArchiSteamFarm ===${NC}\n"

# Verificar se o diretório existe
if [ ! -d "$CONFIG_DIR" ]; then
    echo -e "${YELLOW}Criando diretório de configuração...${NC}"
    mkdir -p "$CONFIG_DIR"
fi

# Solicitar informações
read -p "Nome do bot (ex: MeuBot): " BOT_NAME
read -p "Usuário Steam: " STEAM_LOGIN
read -sp "Senha Steam: " STEAM_PASSWORD
echo

# Validar entrada
if [ -z "$BOT_NAME" ] || [ -z "$STEAM_LOGIN" ] || [ -z "$STEAM_PASSWORD" ]; then
    echo -e "${RED}Erro: Todos os campos são obrigatórios!${NC}"
    exit 1
fi

BOT_FILE="$CONFIG_DIR/${BOT_NAME}.json"

# Verificar se já existe
if [ -f "$BOT_FILE" ]; then
    read -p "Bot '$BOT_NAME' já existe. Sobrescrever? (s/N): " OVERWRITE
    if [ "$OVERWRITE" != "s" ] && [ "$OVERWRITE" != "S" ]; then
        echo -e "${YELLOW}Operação cancelada.${NC}"
        exit 0
    fi
fi

# Criar arquivo de configuração
echo -e "${YELLOW}Criando configuração do bot...${NC}"

if [ -f "$TEMPLATE_FILE" ]; then
    # Usar template
    sed -e "s/SEU_USUARIO_STEAM/$STEAM_LOGIN/g" \
        -e "s/SUA_SENHA_STEAM/$STEAM_PASSWORD/g" \
        "$TEMPLATE_FILE" > "$BOT_FILE"
else
    # Criar manualmente se template não existir
    # FarmingOrders: 0 = Unplayed, 1 = HoursAscending, 2 = HoursDescending, etc.
    cat > "$BOT_FILE" << EOF
{
  "Enabled": true,
  "SteamLogin": "$STEAM_LOGIN",
  "SteamPassword": "$STEAM_PASSWORD",
  "FarmingOrders": [0, 1],
  "AutoSteamSaleEvent": true,
  "OnlineStatus": 1,
  "UseLoginKeys": true
}
EOF
fi

chmod 600 "$BOT_FILE"

echo -e "${GREEN}✓ Bot '$BOT_NAME' configurado com sucesso!${NC}"
echo -e "\nArquivo criado em: ${YELLOW}$BOT_FILE${NC}"
echo -e "\nPróximos passos:"
echo -e "  1. Reinicie o serviço: ${YELLOW}systemctl --user restart archisteamfarm${NC}"
echo -e "  2. Veja os logs: ${YELLOW}journalctl --user -u archisteamfarm -f${NC}"
echo -e "  3. Acesse a interface web: ${YELLOW}http://localhost:1242${NC}"
echo -e "\n${YELLOW}Nota:${NC} Certifique-se de que o MFA está desabilitado na sua conta Steam!"
