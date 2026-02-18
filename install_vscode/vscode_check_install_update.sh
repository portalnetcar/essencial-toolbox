#!/usr/bin/env bash
#
# Script de Instalação do VSCode
# Otimizado para macOS (Apple Silicon/Intel) e Linux (Debian/Ubuntu)
# Seguro para execução via curl: curl -fsSL <url> | bash

# Strict mode: Falha em erros, variáveis não definidas e falhas em pipes
set -euo pipefail

# Constantes de Cores para output no terminal
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_err() { echo -e "${RED}[ERROR]${NC} $1" >&2; }

install_macos() {
    if ! command -v brew >/dev/null 2>&1; then
        log_err "Homebrew não encontrado. O gerenciamento via brew é requerido no macOS."
        exit 1
    fi
    log_info "Instalando Visual Studio Code via Homebrew (Binário Universal)..."
    brew install --cask visual-studio-code
}

install_linux() {
    if ! command -v apt-get >/dev/null 2>&1; then
        log_err "Este script suporta apenas distribuições baseadas em Debian/Ubuntu."
        log_err "Visite https://code.visualstudio.com/download para outras plataformas."
        exit 1
    fi

    log_info "Atualizando repositórios e instalando dependências básicas..."
    sudo apt-get update
    sudo apt-get install -y wget gpg apt-transport-https

    log_info "Adicionando chave GPG e repositório oficial da Microsoft..."
    # Proteção: cria um subshell para lidar com o pipe com segurança
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/packages.microsoft.gpg >/dev/null
    sudo chmod 644 /etc/apt/keyrings/packages.microsoft.gpg
    
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null

    log_info "Instalando o VSCode..."
    sudo apt-get update
    sudo apt-get install -y code
}

main() {
    log_info "Iniciando verificação do VSCode..."

    if command -v code >/dev/null 2>&1; then
        log_warn "VSCode já está instalado."
        log_info "No macOS, recomendamos deixar o próprio VSCode gerenciar suas atualizações nativamente."
        log_info "No Linux, o VSCode será atualizado automaticamente através do 'apt upgrade' rotineiro do sistema."
        exit 0
    fi

    log_info "VSCode não encontrado. Iniciando instalação..."
    
    local os_name
    os_name=$(uname -s)

    case "${os_name}" in
        Darwin)
            install_macos
            ;;
        Linux)
            install_linux
            ;;
        *)
            log_err "Sistema Operacional não suportado por este script: ${os_name}"
            exit 1
            ;;
    esac

    log_info "Instalação finalizada com sucesso!"
}

# A chamada da função main no final garante que o script só execute 
# se for baixado de forma integral pelo curl.
main "$@"
