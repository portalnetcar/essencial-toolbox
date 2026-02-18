#!/bin/bash

set -e

ENV_NAME=zeroscope
FRAME_CACHE="video_cache/base_frames.npy"
OUTPUT_DIR="output_frames"
VIDEO_FILE="output_final.mp4"

echo "🎬 Iniciando pipeline Zeroscope..."

# Ativa o conda
echo "📦 Ativando ambiente Conda: $ENV_NAME"
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate "$ENV_NAME"

# Etapa 1 - geração de vídeo base
if [ ! -f "$FRAME_CACHE" ]; then
  echo "🎥 Gerando vídeo base (576w)..."
  python generate_base.py
else
  echo "✅ Frames base já existem em '$FRAME_CACHE'. Pulando geração."
fi

# Etapa 2 - upscale
echo "🔼 Aplicando upscale com modelo XL..."
python generate_upscale.py

# Etapa 3 - gerar vídeo com ffmpeg
echo "🎞️ Gerando vídeo final com ffmpeg..."
ffmpeg -y -framerate 8 -i "$OUTPUT_DIR/frame_%03d.png" -c:v libx264 -pix_fmt yuv420p "$VIDEO_FILE"

echo "✅ Pipeline finalizada com sucesso!"
echo "📁 Arquivo gerado: $VIDEO_FILE"

