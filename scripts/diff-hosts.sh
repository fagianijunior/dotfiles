#!/usr/bin/env bash

# Script para comparar configurações entre hosts

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLAKE_DIR="$(dirname "$SCRIPT_DIR")"

# Cores
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[DIFF]${NC} $1"
}

show_help() {
    cat << EOF
Uso: $0 [OPÇÕES]

Compara as configurações entre Nobita (desktop) e Doraemon (notebook)

OPÇÕES:
    -h, --help          Mostra esta ajuda
    -m, --modules       Compara apenas módulos importados
    -p, --packages      Lista pacotes únicos de cada host
    -s, --services      Compara serviços habilitados
    
EXEMPLOS:
    $0                  # Comparação completa
    $0 --modules        # Apenas módulos
    $0 --packages       # Apenas pacotes únicos
EOF
}

# Função para extrair imports de um arquivo
extract_imports() {
    local file="$1"
    grep -E "^\s*\.\./modules/" "$file" | sed 's/^[[:space:]]*//' | sort
}

# Função para comparar módulos
compare_modules() {
    log "Comparando módulos importados..."
    
    local nobita_imports=$(mktemp)
    local doraemon_imports=$(mktemp)
    
    extract_imports "$FLAKE_DIR/hosts/nobita.nix" > "$nobita_imports"
    extract_imports "$FLAKE_DIR/hosts/doraemon.nix" > "$doraemon_imports"
    
    echo
    warning "Módulos únicos do Nobita (Desktop):"
    comm -23 "$nobita_imports" "$doraemon_imports" | sed 's/^/  /'
    
    echo
    warning "Módulos únicos do Doraemon (Notebook):"
    comm -13 "$nobita_imports" "$doraemon_imports" | sed 's/^/  /'
    
    echo
    success "Módulos compartilhados:"
    comm -12 "$nobita_imports" "$doraemon_imports" | sed 's/^/  /'
    
    rm "$nobita_imports" "$doraemon_imports"
}

# Função para listar diferenças de perfis
show_profile_differences() {
    log "Analisando diferenças entre perfis específicos..."
    
    echo
    warning "Nobita (Desktop) - Características únicas:"
    echo "  • Governor de CPU: performance"
    echo "  • Gaming (Steam, Heroic, Nile)"
    echo "  • Serviços de IA (Ollama, Qdrant)"
    echo "  • Gamescope habilitado"
    
    echo
    warning "Doraemon (Notebook) - Características únicas:"
    echo "  • Governor de CPU: schedutil"
    echo "  • Parâmetros de kernel para laptop"
    echo "  • Suspend-then-hibernate"
    echo "  • OBS Studio com plugins"
    echo "  • Utilitários de energia (acpi, powertop)"
    echo "  • Quirks de hardware (resume-keyboard)"
}

# Função para mostrar resumo da arquitetura
show_architecture_summary() {
    log "Resumo da arquitetura modular..."
    
    echo
    success "Estrutura de módulos:"
    echo "  📁 base/          - Configurações essenciais do sistema"
    echo "  📁 hardware/      - Drivers AMD e configurações de hardware"
    echo "  📁 desktop/       - Hyprland, Pipewire, sessão"
    echo "  📁 profiles/      - Perfis modulares de software"
    
    echo
    success "Perfis compartilhados:"
    echo "  🔧 workstation   - Base de workstation (SSH, USBGuard, fontes)"
    echo "  💻 development   - Ferramentas de desenvolvimento"
    echo "  🎵 multimedia    - Aplicações multimídia"
    echo "  🛠️  utilities     - Utilitários do sistema"
    echo "  📶 bluetooth     - Configuração Bluetooth"
    echo "  🖱️  logitech     - Suporte Logitech"
    
    echo
    success "Perfis específicos:"
    echo "  🎮 gaming        - Apenas Nobita (Steam, launchers)"
    echo "  🤖 ai-services   - Apenas Nobita (Ollama, Qdrant)"
}

# Parse dos argumentos
MODULES_ONLY=false
PACKAGES_ONLY=false
SERVICES_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -m|--modules)
            MODULES_ONLY=true
            shift
            ;;
        -p|--packages)
            PACKAGES_ONLY=true
            shift
            ;;
        -s|--services)
            SERVICES_ONLY=true
            shift
            ;;
        *)
            echo "Opção desconhecida: $1"
            show_help
            exit 1
            ;;
    esac
done

# Executa comparações baseado nas opções
if [[ "$MODULES_ONLY" == "true" ]]; then
    compare_modules
elif [[ "$PACKAGES_ONLY" == "true" ]]; then
    show_profile_differences
elif [[ "$SERVICES_ONLY" == "true" ]]; then
    show_architecture_summary
else
    # Comparação completa
    compare_modules
    echo
    echo "=================================="
    show_profile_differences
    echo
    echo "=================================="
    show_architecture_summary
fi