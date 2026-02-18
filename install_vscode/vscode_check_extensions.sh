#!/usr/bin/env bash
#
# Script de Gerenciamento de Extensões do VSCode
# Otimizado para máxima eficiência de I/O e resiliência
# Seguro para execução via curl: curl -fsSL <url> | bash

set -euo pipefail

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_err() { echo -e "${RED}[ERROR]${NC} $1" >&2; }

# URL corrigida apontando para o subdiretório install_vscode/
readonly INSTALL_SCRIPT_URL="https://raw.githubusercontent.com/portalnetcar/essencial-toolbox/main/install_vscode/vscode_check_install_update.sh"

ensure_vscode_installed() {
    if command -v code >/dev/null 2>&1; then
        log_info "CLI do VSCode ('code') detectada."
        return 0
    fi

    log_warn "VSCode não está instalado. Iniciando instalação automatizada..."
    
    if ! curl -fsSL "${INSTALL_SCRIPT_URL}" | bash; then
        log_err "Falha catastrófica ao executar o script de instalação do VSCode."
        exit 1
    fi

    if ! command -v code >/dev/null 2>&1; then
        log_err "A instalação relatou sucesso, mas o binário 'code' não está no PATH."
        exit 1
    fi
    log_info "VSCode instalado e carregado no PATH com sucesso."
}

manage_extensions() {
    # Array consolidado com as extensões essenciais para Platform Engineering e AI
    local -a extensions=(
        "golang.go"
        "bierner.markdown-mermaid"
        "hashicorp.terraform"
        "augment.vscode-augment"   # AI Coding Assistant
        "rust-lang.rust-analyzer"  # Servidor de linguagem oficial e de alta performance para Rust
        # --- Platform Engineering / Devops / Cloud ---
        "amazonwebservices.aws-toolkit-vscode"
        "ms-kubernetes-tools.vscode-kubernetes-tools"
        "redhat.vscode-yaml" # Essencial para K8s, ArgoCD e Crossplane
        "ms-azuretools.vscode-docker"
        "github.vscode-github-actions"
    )

    log_info "Mapeando extensões atualmente instaladas (I/O único)..."
    local installed_extensions
    installed_extensions=$(code --list-extensions | tr '[:upper:]' '[:lower:]')

    for ext in "${extensions[@]}"; do
        if echo "${installed_extensions}" | grep -qi "^${ext}$"; then
            log_info "Extensão '${ext}' já está instalada."
        else
            log_warn "Extensão '${ext}' ausente. Instalando..."
            if code --install-extension "${ext}" --force; then
                log_info "Extensão '${ext}' instalada com sucesso!"
            else
                log_err "Falha ao instalar a extensão '${ext}'."
                exit 1
            fi
        fi
    done
}

main() {
    log_info "Iniciando verificação de ambiente do VSCode..."
    ensure_vscode_installed
    manage_extensions
    log_info "Provisionamento de extensões concluído."
}

main "$@"
