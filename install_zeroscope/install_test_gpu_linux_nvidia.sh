#!/bin/bash

set -e

ENV_NAME=zeroscope
PYTHON_VERSION=3.11
SCRIPT_NAME=generate_zeroscope.py

echo "🧱 Criando ambiente Conda '$ENV_NAME' com Python $PYTHON_VERSION..."
conda create -n $ENV_NAME python=$PYTHON_VERSION -y

echo "🔁 Ativando ambiente..."
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate $ENV_NAME

echo "🚀 Instalando PyTorch com suporte CUDA (para GPU NVIDIA)..."
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

echo "📦 Instalando diffusers e dependências..."
pip install diffusers accelerate transformers scipy imageio

echo "📝 Criando script Python '$SCRIPT_NAME'..."

cat <<EOF > $SCRIPT_NAME
from diffusers import DiffusionPipeline, DPMSolverMultistepScheduler
import torch
import os

device = "cuda" if torch.cuda.is_available() else "cpu"
print(f"🧠 Usando dispositivo: {device.upper()}")

prompt = "Um gato robô dançando breakdance em uma cidade futurista"

print("🔄 Carregando modelo Zeroscope...")
pipe = DiffusionPipeline.from_pretrained(
    "cerspense/zeroscope_v2_576w",
    torch_dtype=torch.float16 if device == "cuda" else torch.float32
)
pipe.scheduler = DPMSolverMultistepScheduler.from_config(pipe.scheduler.config)
pipe.to(device)

print("🎥 Gerando vídeo...")
result = pipe(prompt, num_inference_steps=40, height=320, width=576, num_frames=24)
frames = result.frames

print("💾 Salvando frames como PNG...")
os.makedirs("output_frames", exist_ok=True)
for i, frame in enumerate(frames):
    frame.save(f"output_frames/frame_{i:03}.png")

print("✅ Pronto! Use 'ffmpeg' para gerar o vídeo final.")
EOF

echo "✅ Tudo pronto!"
echo ""
echo "Execute agora com:"
echo "conda activate $ENV_NAME && python $SCRIPT_NAME"
