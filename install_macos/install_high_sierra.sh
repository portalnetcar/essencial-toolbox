#!/bin/bash

INSTALLER_PATH="/Applications/Install macOS High Sierra.app"
VOLUME_NAME="MyVolume"
DISK_NAME="/Volumes/$VOLUME_NAME"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}Verificando se o instalador do macOS High Sierra está presente...${NC}"
if [ ! -d "$INSTALLER_PATH" ]; then
  echo -e "${RED}❌ Instalador não encontrado em: $INSTALLER_PATH${NC}"
  echo "Baixe-o pela App Store ou via link oficial da Apple:"
  echo "https://support.apple.com/pt-br/HT211683"
  exit 1
fi

echo -e "${GREEN}✅ Instalador encontrado.${NC}"

# Confirmar com o usuário
echo ""
echo -e "${CYAN}AVISO: O volume \"$VOLUME_NAME\" será apagado completamente.${NC}"
read -p "Deseja continuar? (s/n): " confirm
if [[ "$confirm" != "s" && "$confirm" != "S" ]]; then
  echo "Cancelado pelo usuário."
  exit 0
fi

echo ""
echo -e "${CYAN}Apagando e formatando o volume $VOLUME_NAME...${NC}"
diskutil eraseDisk "Mac OS Extended (Journaled)" $VOLUME_NAME GPT $(diskutil list | grep "$VOLUME_NAME" | awk '{print $NF}') > /dev/null

if [ $? -ne 0 ]; then
  echo -e "${RED}❌ Falha ao apagar/formatar o volume.${NC}"
  exit 1
fi

echo -e "${GREEN}✅ Volume formatado com sucesso.${NC}"
echo ""
echo -e "${CYAN}Iniciando criação do pendrive bootável...${NC}"

sudo "$INSTALLER_PATH/Contents/Resources/createinstallmedia" --volume "$DISK_NAME" --nointeraction

if [ $? -eq 0 ]; then
  echo -e "${GREEN}🎉 Pendrive criado com sucesso! Pronto para instalar o macOS High Sierra.${NC}"
else
  echo -e "${RED}❌ Algo deu errado durante a criação do instalador.${NC}"
fi
