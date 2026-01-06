# Melhorias no Quickshell

## Problemas Corrigidos

### 1. Detecção Dinâmica de Discos
**Problema**: Os gráficos de disco eram fixos para `/`, `/home` e `/boot`, causando erros em sistemas onde `/home` não é um ponto de montagem separado.

**Solução**: 
- Implementado sistema dinâmico usando `Repeater` e `ListModel`
- Detecta automaticamente pontos de montagem relevantes
- Suporta até 5 discos com cores diferentes
- Filtra apenas pontos importantes: `/`, `/home`, `/boot`, `/var`, `/tmp`

**Comando usado**:
```bash
df -h | grep -E '^/dev/' | awk '{print $6 ":" $5}' | sed 's/%//' | sort
```

### 2. Correção do Layout das Notificações
**Problema**: Texto das notificações ultrapassava os limites da caixa, causando sobreposição visual.

**Solução**:
- Adicionado `clip: true` nos containers
- Melhorado o layout com `Layout.maximumWidth`
- Reorganizado cabeçalho com `Column` para timestamp e app
- Ajustados tamanhos de fonte responsivos
- Limitado número de linhas para título (2) e corpo (4)

### 3. Melhorias no PieChart
- Ajustado tamanho e proporções
- Melhorada legibilidade dos labels
- Adicionado `elide: Text.ElideMiddle` para labels longos
- Fonte responsiva baseada no tamanho do componente

## Como Testar

Execute o script de teste:
```bash
./home/quickshell/config/test_disk_detection.sh
```

## Estrutura dos Arquivos Modificados

- `shell.qml`: Lógica principal com detecção dinâmica de discos e layout de notificações
- `PieChart.qml`: Componente melhorado para gráficos de disco
- `test_disk_detection.sh`: Script para testar as mudanças

## Compatibilidade

As mudanças são compatíveis com:
- ✅ Desktop "Nobita" (/, /home, /boot)
- ✅ Notebook "Doraemon" (apenas /, /boot)
- ✅ Qualquer sistema com pontos de montagem diferentes

## Próximas Melhorias Sugeridas

1. Cache de configurações de disco para evitar re-detecção constante
2. Configuração de cores personalizáveis via arquivo
3. Suporte a mais tipos de sistemas de arquivos
4. Filtros configuráveis para notificações por aplicativo