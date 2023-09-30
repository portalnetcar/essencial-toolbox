import torch
import psutil
import time
import subprocess
import re
import cpuinfo

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

TOTAL_VALUES = 30000

# Check CUDA availability
print(torch.cuda.is_available())
# If available, print CUDA device name
if torch.cuda.is_available():

    # Print CUDA device info 
    print(torch.cuda.device_count())
    print(torch.cuda.get_device_name(0))
    
    # Print system CPU usage
    print(f'CPU usage: {psutil.cpu_percent()}%')

    # Print system memory usage
    memory = psutil.virtual_memory()
    print(f'Memory usage: {memory.percent}%')
    
    print('-----------------')
    print('Starting GPU test')
    print('-----------------')

    # Get start CPU and GPU usage
    start_cpu = psutil.cpu_percent()
    # Get the GPU temperature
    gpu_temperature = get_gpu_temperature()
    if gpu_temperature is not None:
        print(f'GPU temperature: {gpu_temperature}°C')
    start_gpu = gpu_temperature

    start = time.time()  # Capture the start time

    # Run a CUDA tensor operation
    a = torch.cuda.FloatTensor(TOTAL_VALUES, TOTAL_VALUES).normal_()
    b = torch.cuda.FloatTensor(TOTAL_VALUES, TOTAL_VALUES).normal_() 
    c = torch.matmul(a, b)

    # Get end CPU and GPU usage
    end_cpu = psutil.cpu_percent()
    #TO DEBUG
    # print(psutil.sensors_temperatures())
    end_gpu = get_gpu_temperature()

    # Print usage statistics
    print(f'CPU usage change: {end_cpu - start_cpu}%') 
    print(f'GPU temperature change: {end_gpu - start_gpu}°C')

    # Print elapsed time
    print(f'Elapsed time: {(time.time() - start):.4f} sec')
    print()

    # Print CPU device info 
    # Get CPU count 
    cpu_count = psutil.cpu_count()

    # Get CPU frequency
    cpu_freq = psutil.cpu_freq()

    # Get CPU name
    cpu_name = cpuinfo.get_cpu_info()['brand_raw']

    print(f"CPU Name: {cpu_name}")
    print(f"CPU Count: {cpu_count}")
    print(f"CPU Frequency: {cpu_freq.max:.2f}Mhz")
    
    print('-----------------')
    print('Starting CPU test')
    print('-----------------')

    # Get start CPU and GPU usage
    start_cpu = psutil.cpu_percent()
    start_gpu = get_gpu_temperature()

    # CPU matmul
    start = time.time()

    a_cpu = torch.randn(TOTAL_VALUES, TOTAL_VALUES)
    b_cpu = torch.randn(TOTAL_VALUES, TOTAL_VALUES)
    
    c_cpu = torch.mm(a_cpu, b_cpu)
  
    # Get end CPU and GPU usage
    end_cpu = psutil.cpu_percent()
    end_gpu = get_gpu_temperature()

    # Print usage statistics
    print(f'CPU usage change: {end_cpu - start_cpu}%') 
    print(f'GPU temperature change: {end_gpu - start_gpu}°C')

    # Print elapsed time
    print(f'Elapsed time: {(time.time() - start):.4f} sec')