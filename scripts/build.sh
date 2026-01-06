#!/usr/bin/env bash

# Script para build e deploy da configuração NixOS

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLAKE_DIR="$(dirname "$SCRIPT_DIR")"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para logging
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Função de ajuda
show_help() {
    cat << EOF
Uso: $0 [OPÇÕES] [HOSTNAME]

HOSTNAME:
    nobita      Build para desktop
    doraemon    Build para notebook
    
OPÇÕES:
    -h, --help          Mostra esta ajuda
    -c, --check         Apenas verifica a configuração (dry-run)
    -u, --update        Atualiza o flake antes do build
    -b, --boot          Aplica na próxima inicialização
    --rollback          Faz rollback para geração anterior
    
EXEMPLOS:
    $0 nobita                    # Build normal para desktop
    $0 doraemon --check          # Verifica configuração do notebook
    $0 nobita --update           # Atualiza e faz build do desktop
    $0 --rollback                # Rollback do sistema atual
EOF
}

# Detecta hostname atual
detect_hostname() {
    hostname
}

# Função principal de build
build_system() {
    local target_host="$1"
    local check_only="${2:-false}"
    local update_flake="${3:-false}"
    local boot_only="${4:-false}"
    
    log "Iniciando build para: $target_host"
    
    # Atualiza flake se solicitado
    if [[ "$update_flake" == "true" ]]; then
        log "Atualizando flake..."
        nix flake update "$FLAKE_DIR"
        success "Flake atualizado"
    fi
    
    # Monta comando nixos-rebuild
    local cmd="sudo nixos-rebuild"
    
    if [[ "$check_only" == "true" ]]; then
        cmd+=" dry-build"
    elif [[ "$boot_only" == "true" ]]; then
        cmd+=" boot"
    else
        cmd+=" switch"
    fi
    
    cmd+=" --flake $FLAKE_DIR#$target_host"
    
    log "Executando: $cmd"
    
    if eval "$cmd"; then
        if [[ "$check_only" == "true" ]]; then
            success "Verificação concluída com sucesso"
        elif [[ "$boot_only" == "true" ]]; then
            success "Configuração aplicada para próxima inicialização"
        else
            success "Sistema atualizado com sucesso"
        fi
    else
        error "Falha no build"
        return 1
    fi
}

# Função de rollback
rollback_system() {
    log "Fazendo rollback do sistema..."
    
    if sudo nixos-rebuild switch --rollback; then
        success "Rollback realizado com sucesso"
    else
        error "Falha no rollback"
        return 1
    fi
}

# Parse dos argumentos
HOSTNAME=""
CHECK_ONLY=false
UPDATE_FLAKE=false
BOOT_ONLY=false
ROLLBACK=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -c|--check)
            CHECK_ONLY=true
            shift
            ;;
        -u|--update)
            UPDATE_FLAKE=true
            shift
            ;;
        -b|--boot)
            BOOT_ONLY=true
            shift
            ;;
        --rollback)
            ROLLBACK=true
            shift
            ;;
        nobita|doraemon)
            HOSTNAME="$1"
            shift
            ;;
        *)
            error "Opção desconhecida: $1"
            show_help
            exit 1
            ;;
    esac
done

# Executa rollback se solicitado
if [[ "$ROLLBACK" == "true" ]]; then
    rollback_system
    exit $?
fi

# Detecta hostname se não fornecido
if [[ -z "$HOSTNAME" ]]; then
    HOSTNAME=$(detect_hostname)
    warning "Hostname não especificado, usando hostname atual: $HOSTNAME"
fi

# Valida hostname
if [[ "$HOSTNAME" != "nobita" && "$HOSTNAME" != "doraemon" ]]; then
    error "Hostname inválido: $HOSTNAME"
    error "Hostnames válidos: nobita, doraemon"
    exit 1
fi

# Executa build
build_system "$HOSTNAME" "$CHECK_ONLY" "$UPDATE_FLAKE" "$BOOT_ONLY"