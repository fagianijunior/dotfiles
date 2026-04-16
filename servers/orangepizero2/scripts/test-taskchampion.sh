#!/usr/bin/env bash
# Script para testar a instalação do taskchampion-sync-server

# Não usar 'set -e' aqui porque queremos tratar falhas individuais
# (ex.: serviço inativo) e mostrar mensagens informativas ao usuário.

echo "🧪 Testando Taskchampion Sync Server no Orange Pi Zero 2"
echo "=========================================================="
echo ""

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função para verificar status
check_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ $1${NC}"
    else
        echo -e "${RED}❌ $1${NC}"
        return 1
    fi
}

# 1. Verificar se o serviço está rodando
echo "1️⃣  Verificando status do serviço..."
sudo systemctl is-active --quiet taskchampion-sync-server
check_status "Serviço está ativo"
echo ""

# 2. Verificar se a porta está escutando
echo "2️⃣  Verificando se a porta 8080 está escutando..."
sudo ss -tlnp | grep -q ":8080"
check_status "Porta 8080 está aberta"
echo ""

# 3. Verificar se o diretório de dados existe
echo "3️⃣  Verificando diretório de dados..."
if [ -d "/var/lib/taskchampion-sync-server" ]; then
    echo -e "${GREEN}✅ Diretório existe${NC}"
    ls -la /var/lib/taskchampion-sync-server/ | head -5
else
    echo -e "${RED}❌ Diretório não existe${NC}"
fi
echo ""

# 4. Verificar permissões
echo "4️⃣  Verificando permissões..."
OWNER=$(stat -c '%U:%G' /var/lib/taskchampion-sync-server)
if [ "$OWNER" = "taskchampion:taskchampion" ]; then
    echo -e "${GREEN}✅ Permissões corretas (taskchampion:taskchampion)${NC}"
else
    echo -e "${YELLOW}⚠️  Permissões: $OWNER (esperado: taskchampion:taskchampion)${NC}"
fi
echo ""

# 5. Testar conexão HTTP
echo "5️⃣  Testando conexão HTTP..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 || echo "000")
if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "404" ]; then
    echo -e "${GREEN}✅ Servidor responde (HTTP $HTTP_CODE)${NC}"
else
    echo -e "${RED}❌ Servidor não responde (HTTP $HTTP_CODE)${NC}"
fi
echo ""

# 6. Verificar logs recentes
echo "6️⃣  Últimas 10 linhas do log:"
echo "----------------------------"
sudo journalctl -u taskchampion-sync-server -n 10 --no-pager
echo ""

# 7. Verificar firewall
echo "7️⃣  Verificando configuração do firewall..."
if sudo iptables -L -n | grep -q "8080"; then
    echo -e "${GREEN}✅ Porta 8080 está aberta no firewall${NC}"
else
    echo -e "${YELLOW}⚠️  Porta 8080 pode não estar aberta no firewall${NC}"
fi
echo ""

# 8. Informações do sistema
echo "8️⃣  Informações do sistema:"
echo "----------------------------"
echo "Hostname: $(hostname)"
echo "IP: $(hostname -I | awk '{print $1}')"
echo "Arquitetura: $(uname -m)"
echo "Kernel: $(uname -r)"
echo ""

# 9. Teste de sincronização (se taskwarrior estiver instalado)
echo "9️⃣  Teste de sincronização (opcional):"
if command -v task &> /dev/null; then
    echo -e "${YELLOW}ℹ️  Taskwarrior encontrado. Para testar sincronização:${NC}"
    echo ""
    echo "  1. Configure o cliente:"
    echo "     task config sync.server.origin http://$(hostname):8080"
    echo "     task config sync.server.client_id \$(uuidgen)"
    echo ""
    echo "  2. Inicialize:"
    echo "     task sync init"
    echo ""
    echo "  3. Sincronize:"
    echo "     task sync"
else
    echo -e "${YELLOW}ℹ️  Taskwarrior não instalado neste sistema${NC}"
fi
echo ""

# Resumo final
echo "=========================================================="
echo "✨ Teste concluído!"
echo ""
echo "Para conectar de outro dispositivo:"
echo "  sync.server.origin=http://$(hostname):8080"
echo "  sync.server.client_id=<seu-uuid-unico>"
echo ""
echo "Documentação completa em:"
echo "  servers/orangepizero2/docs/taskwarrior-sync-setup.md"
echo "=========================================================="
