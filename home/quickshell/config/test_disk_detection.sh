#!/bin/bash

echo "=== Teste de Detecção Dinâmica de Discos ==="
echo "Pontos de montagem detectados:"
echo

# Comando usado no QML
df -h | grep -E '^/dev/' | awk '{print $6 ":" $5}' | sed 's/%//' | sort

echo
echo "=== Comparação com comando antigo ==="
echo "Comando antigo (fixo):"
df / /home /boot 2>/dev/null | tail -n +2 | awk '{print $6 ":" $5}' | sed 's/%//'

echo
echo "=== Teste de Notificações ==="
echo "Verificando se dunst está rodando:"
if pgrep -x dunst > /dev/null; then
    echo "✓ Dunst está rodando"
    echo "Histórico de notificações:"
    dunstctl history --json | jq '.data[0] | length' 2>/dev/null || echo "Erro ao acessar histórico"
else
    echo "✗ Dunst não está rodando"
fi