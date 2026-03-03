#!/usr/bin/env bash

# Script para validar se os dados do Taskwarrior foram escritos no servidor
# Uso: ./validate-taskwarrior-sync.sh

set -e

echo "🔍 Validação de Sincronização do Taskwarrior"
echo "=============================================="
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função para verificar status
check_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ OK${NC}"
    else
        echo -e "${RED}❌ FALHOU${NC}"
    fi
}

# 1. Verificar se o serviço está rodando
echo "1️⃣  Verificando serviço no servidor..."
ssh orangepizero2 'sudo systemctl is-active taskchampion-sync-server' > /dev/null 2>&1
check_status

# 2. Verificar se a porta está aberta
echo "2️⃣  Verificando porta 8080..."
ssh orangepizero2 'sudo ss -tlnp | grep :8080' > /dev/null 2>&1
check_status

# 3. Verificar se o servidor responde
echo "3️⃣  Testando conexão HTTP..."
curl -s -o /dev/null -w "%{http_code}" http://orangepizero2:8080 | grep -q "200\|404"
check_status

# 4. Verificar diretório de dados no servidor
echo "4️⃣  Verificando diretório de dados no servidor..."
echo ""
echo "📁 Conteúdo de /var/lib/taskchampion-sync-server/:"
ssh orangepizero2 'sudo ls -lah /var/lib/taskchampion-sync-server/ 2>/dev/null || echo "Diretório não existe ou está vazio"'
echo ""

# 5. Verificar tamanho dos dados
echo "5️⃣  Verificando tamanho dos dados armazenados..."
DATA_SIZE=$(ssh orangepizero2 'sudo du -sh /var/lib/taskchampion-sync-server/ 2>/dev/null | cut -f1' || echo "0")
echo "   Tamanho total: $DATA_SIZE"
echo ""

# 6. Verificar logs recentes do servidor
echo "6️⃣  Últimas 20 linhas dos logs do servidor:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ssh orangepizero2 'sudo journalctl -u taskchampion-sync-server -n 20 --no-pager'
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 7. Verificar configuração local do cliente
echo "7️⃣  Verificando configuração local do cliente..."
echo ""
echo "Configurações de sync:"
task show | grep sync
echo ""

# 8. Verificar última sincronização
echo "8️⃣  Informações da última sincronização:"
echo ""
task sync rc.verbose=on 2>&1 | tail -10
echo ""

# 9. Contar tarefas locais
echo "9️⃣  Estatísticas locais:"
PENDING=$(task status:pending count 2>/dev/null || echo "0")
COMPLETED=$(task status:completed count 2>/dev/null || echo "0")
echo "   Tarefas pendentes: $PENDING"
echo "   Tarefas completadas: $COMPLETED"
echo "   Total: $((PENDING + COMPLETED))"
echo ""

# 10. Verificar clientes conectados (se possível)
echo "🔟 Verificando clientes no servidor..."
echo ""
ssh orangepizero2 'sudo find /var/lib/taskchampion-sync-server -type f -name "*.db" -o -name "client_*" 2>/dev/null | head -10'
echo ""

echo "=============================================="
echo "✨ Validação concluída!"
echo ""
echo "💡 Dicas para diagnóstico:"
echo ""
echo "   • Se o diretório está vazio, o servidor nunca recebeu dados"
echo "   • Verifique os logs para erros de conexão ou autenticação"
echo "   • Execute 'task sync init' se for a primeira vez"
echo "   • Use 'task sync rc.verbose=on' para ver detalhes"
echo ""
