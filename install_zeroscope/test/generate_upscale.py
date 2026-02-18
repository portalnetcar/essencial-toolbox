import os
os.environ["PYTORCH_CUDA_ALLOC_CONF"] = "expandable_segments:True"

from diffusers import DiffusionPipeline
import torch
import numpy as np
from PIL import Image

torch.cuda.empty_cache()
torch.backends.cuda.matmul.allow_tf32 = True

model_path = "./models/zeroscope_v2_XL"
frames_path = "video_cache/base_frames.npy"
output_dir = "output_frames"
prompt = "Um gato robô dançando breakdance em uma cidade futurista"

device = "cuda" if torch.cuda.is_available() else "cpu"
dtype = torch.float16 if device == "cuda" else torch.float32

print(f"🧠 Dispositivo: {device.upper()}")
print(f"📦 Carregando frames salvos: {frames_path}")
frames = np.load(frames_path)

print("🔼 Carregando modelo de upscale XL...")
pipe = DiffusionPipeline.from_pretrained(
    model_path,
    torch_dtype=dtype,
    use_safetensors=False
)
pipe.to(device)

print("🚀 Aplicando upscale...")
#result = pipe(
#    prompt=prompt,
#    image_sequence=frames
#)

#result = pipe(
#    frames,
#    prompt=prompt
#)

result = pipe(
    prompt=prompt,
    video=frames
)

print("💾 Salvando frames upscale como PNG...")
os.makedirs(output_dir, exist_ok=True)
video = result.frames

if isinstance(video, torch.Tensor):
    video = video.detach().cpu().numpy()

video = np.squeeze(video)

for i, frame in enumerate(video):
    while frame.ndim > 3:
        frame = frame[0]
    if frame.dtype != np.uint8:
        frame = np.clip(frame * 255, 0, 255).astype(np.uint8)
    if frame.ndim == 3 and frame.shape[0] == 3:
        frame = np.transpose(frame, (1, 2, 0))  # CHW → HWC
    img = Image.fromarray(frame)
    img.save(f"{output_dir}/frame_{i:03}.png")

print(f"✅ Todos os frames upscale salvos em '{output_dir}'")

