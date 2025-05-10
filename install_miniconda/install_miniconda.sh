#!/bin/bash

set -e  # Encerra em caso de erro
set -u  # Erro se usar variável não definida

# Caminho de instalação
INSTALL_DIR="$HOME/miniconda3"
INSTALLER="Miniconda3-latest-MacOSX-arm64.sh"
URL="https://repo.anaconda.com/miniconda/$INSTALLER"

echo "🔍 Baixando Miniconda para Mac ARM64..."
curl -fsSL -o "$INSTALLER" "$URL"

echo "🛡️ Tornando instalador executável..."
chmod +x "$INSTALLER"

echo "🚀 Executando instalador..."
./"$INSTALLER" -b -p "$INSTALL_DIR"

echo "✅ Miniconda instalado em: $INSTALL_DIR"

# Adicionando conda ao PATH
SHELL_RC="$HOME/.zshrc"
echo "" >> "$SHELL_RC"
echo "# >>> conda initialize >>>" >> "$SHELL_RC"
echo "export PATH=\"$INSTALL_DIR/bin:\$PATH\"" >> "$SHELL_RC"
echo "# <<< conda initialize <<<" >> "$SHELL_RC"

echo "🔁 Atualize seu terminal ou execute:"
echo "source $SHELL_RC"

echo "♻️ Limpando instalador..."
rm "$INSTALLER"

echo "✅ Finalizado! Agora você pode usar 'conda'."
