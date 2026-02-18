import os
os.environ["PYTORCH_CUDA_ALLOC_CONF"] = "expandable_segments:True"

from diffusers import DiffusionPipeline, DPMSolverMultistepScheduler
import torch
import numpy as np

torch.cuda.empty_cache()
torch.backends.cuda.matmul.allow_tf32 = True

prompt = """
a fluffy grey kitten riding a red toy car on a green grassy road, digital painting, pixar style, sharp focus, cinematic lighting
"""
model_path = "./models/zeroscope_v2_576w"
device = "cuda" if torch.cuda.is_available() else "cpu"
dtype = torch.float16 if device == "cuda" else torch.float32

print(f"🧠 Dispositivo: {device.upper()}")

print("🔄 Carregando modelo base...")
pipe = DiffusionPipeline.from_pretrained(
    model_path,
    torch_dtype=dtype,
    use_safetensors=False
)
pipe.scheduler = DPMSolverMultistepScheduler.from_config(pipe.scheduler.config)
pipe.to(device)

print("🎥 Gerando vídeo base (32 frames @ 448x256)...")
result = pipe(
    prompt=prompt,
    num_inference_steps=40,
    height=256,
    width=448,
    num_frames=32
)

print("💾 Salvando frames em formato .npy...")
os.makedirs("video_cache", exist_ok=True)
frames = result.frames
if isinstance(frames, torch.Tensor):
    frames = frames.detach().cpu().numpy()
np.save("video_cache/base_frames.npy", frames)

print("✅ Frames salvos em 'video_cache/base_frames.npy'")

