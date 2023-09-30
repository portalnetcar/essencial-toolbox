import psutil
import subprocess

def get_gpu_temp():
    result = subprocess.run(['nvidia-smi'], stdout=subprocess.PIPE)
    output = result.stdout.decode()

    for line in output.split('\n'):
        if 'Temp' in line:
            return int(line.split()[2][:-1])

    return 0

try:
    gpu_temp = psutil.sensors_temperatures()['nvidia_smi']['gpu_temp']
    print(f"Nvidia GPU temp: {gpu_temp}")
except KeyError:
    pass 

try: 
    gpu_temp = psutil.sensors_temperatures()['gpu_thermal']['temp1']
    print(f"GPU thermal temp: {gpu_temp}")
except KeyError:
    pass

try:
    gpu_temp = psutil.sensors_temperatures()['core_thermal']['temp1']
    print(f"Core thermal temp: {gpu_temp}")
except KeyError:
    pass  

try:
    sensors = psutil.sensors_temperatures()
    print(sensors.keys())
    for name in sensors.keys():
        print(name)
        print(sensors[name])
except KeyError:
    pass  

try:
    gpu_temp = get_gpu_temp()
    print(f"GPU temp: {gpu_temp}C")
except KeyError:
    pass

try:
    gpu_temp = psutil.sensors_temperatures()['gpu']['gpu_temp']
    print(f"GPU temp: {gpu_temp}") 
except KeyError:
    print("Unable to get GPU temperature")




