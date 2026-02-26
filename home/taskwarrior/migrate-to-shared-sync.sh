#!/usr/bin/env bash

# Script para migrar para sincronização compartilhada
# Uso: ./migrate-to-shared-sync.sh

set -e

echo "🔄 Migração para Sincronização Compartilhada"
echo "============================================"
echo ""

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Verificar se as variáveis de ambiente estão definidas
if [ -z "$TASKCHAMPION_CLIENT_ID" ]; then
    echo -e "${RED}❌ TASKCHAMPION_CLIENT_ID não está definida${NC}"
    echo "Execute: home-manager switch"
    exit 1
fi

echo -e "${GREEN}✅ Variáveis de ambiente configuradas${NC}"
echo "   Client ID: $TASKCHAMPION_CLIENT_ID"
echo "   Server: $TASKCHAMPION_SERVER_URL"
echo ""

# Fazer backup
BACKUP_FILE="$HOME/taskwarrior-backup-$(date +%Y%m%d-%H%M%S).json"
echo "📦 Fazendo backup das tarefas atuais..."
task export > "$BACKUP_FILE"
echo -e "${GREEN}✅ Backup salvo em: $BACKUP_FILE${NC}"
echo ""

# Perguntar confirmação
echo -e "${YELLOW}⚠️  ATENÇÃO:${NC}"
echo "   Este script vai:"
echo "   1. Limpar os dados locais do Taskwarrior"
echo "   2. Reinicializar a sincronização com o client_id compartilhado"
echo "   3. Baixar todas as tarefas do servidor"
echo ""
read -p "Deseja continuar? (s/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Operação cancelada."
    exit 0
fi

# Limpar dados locais
echo ""
echo "🗑️  Limpando dados locais..."
rm -rf ~/.local/share/task/*
echo -e "${GREEN}✅ Dados locais limpos${NC}"
echo ""

# Reinicializar sincronização
echo "🔄 Inicializando sincronização..."
task sync init
echo ""

# Sincronizar
echo "⬇️  Baixando tarefas do servidor..."
task sync
echo ""

# Mostrar resultado
TASK_COUNT=$(task count)
echo "============================================"
echo -e "${GREEN}✅ Migração concluída!${NC}"
echo ""
echo "📊 Estatísticas:"
echo "   Tarefas sincronizadas: $TASK_COUNT"
echo "   Backup disponível em: $BACKUP_FILE"
echo ""
echo "💡 Próximos passos:"
echo "   • Verifique suas tarefas: task list"
echo "   • Sincronize regularmente: task sync"
echo "   • Configure outros dispositivos com o mesmo CLIENT_ID"
echo ""
