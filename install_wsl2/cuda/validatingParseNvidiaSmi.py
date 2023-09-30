import subprocess
import re

def get_gpu_temperature():
    try:
        result = subprocess.run(['nvidia-smi'], stdout=subprocess.PIPE, text=True)
        output = result.stdout
        # Regular expression to match the temperature information (e.g., "39C")
        temp_match = re.search(r'(\d+)C', output)
        if temp_match:
            temperature = int(temp_match.group(1))
            return temperature
        else:
            print("Temperature information not found.")
            return None
    except Exception as e:
        print(f"An error occurred: {e}")
        return None

# Get the GPU temperature
gpu_temperature = get_gpu_temperature()
if gpu_temperature is not None:
    print(f'GPU temperature: {gpu_temperature}°C')