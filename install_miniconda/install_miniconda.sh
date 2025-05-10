#!/bin/bash

set -e  # Encerra em caso de erro
set -u  # Erro se usar variável não definida

echo "🧠 Detectando sistema operacional e arquitetura..."

OS=$(uname -s)
ARCH=$(uname -m)

INSTALL_DIR="$HOME/miniconda3"
INSTALLER=""
URL=""

# Detectar plataforma
if [[ "$OS" == "Darwin" && "$ARCH" == "arm64" ]]; then
    INSTALLER="Miniconda3-latest-MacOSX-arm64.sh"
elif [[ "$OS" == "Linux" && "$ARCH" == "x86_64" ]]; then
    INSTALLER="Miniconda3-latest-Linux-x86_64.sh"
else
    echo "❌ Sistema não suportado: $OS $ARCH"
    exit 1
fi

URL="https://repo.anaconda.com/miniconda/$INSTALLER"

echo "📦 Baixando instalador: $INSTALLER"
curl -fsSL -o "$INSTALLER" "$URL"

echo "🛡️ Tornando instalador executável..."
chmod +x "$INSTALLER"

echo "🚀 Instalando Miniconda em: $INSTALL_DIR"
./"$INSTALLER" -b -p "$INSTALL_DIR"

echo "🧩 Detectando shell atual..."
SHELL_NAME=$(basename "$SHELL")

# Define arquivo de inicialização do shell
if [[ "$SHELL_NAME" == "zsh" ]]; then
    SHELL_RC="$HOME/.zshrc"
elif [[ "$SHELL_NAME" == "bash" ]]; then
    SHELL_RC="$HOME/.bashrc"
else
    SHELL_RC="$HOME/.profile"
fi

echo "🔧 Configurando PATH no $SHELL_RC"
echo "" >> "$SHELL_RC"
echo "# >>> conda initialize >>>" >> "$SHELL_RC"
echo "export PATH=\"$INSTALL_DIR/bin:\$PATH\"" >> "$SHELL_RC"
echo "# <<< conda initialize <<<" >> "$SHELL_RC"

echo "♻️ Limpando instalador..."
rm "$INSTALLER"

echo "✅ Miniconda instalado com sucesso!"
echo ""
echo "🔁 Reinicie seu terminal ou execute:"
echo "source $SHELL_RC"
echo ""
echo "ℹ️ Para ativar o conda agora, use:"
echo "source $INSTALL_DIR/bin/activate"
