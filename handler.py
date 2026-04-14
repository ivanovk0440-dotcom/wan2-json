import runpod
import subprocess
import time
import requests

# Запускаем ComfyUI как фоновый процесс
comfy_process = None

def start_comfy():
    global comfy_process
    if comfy_process is None:
        comfy_process = subprocess.Popen(
            ["python", "/comfyui/main.py", "--listen", "0.0.0.0", "--port", "8188"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )
        # Ждём запуска ComfyUI
        for _ in range(30):
            try:
                requests.get("http://localhost:8188", timeout=2)
                break
            except:
                time.sleep(1)

def handler(job):
    """
    Хендлер для RunPod Serverless
    """
    # Убеждаемся что ComfyUI запущен
    if comfy_process is None:
        start_comfy()
    
    # Получаем входные данные
    job_input = job.get("input", {})
    workflow = job_input.get("workflow")
    images = job_input.get("images", [])
    
    # Здесь твоя логика отправки в ComfyUI и получения результата
    # ...
    
    return {"status": "completed", "output": "..."}

# Запускаем серверлес-воркер
if __name__ == "__main__":
    start_comfy()  # Предварительный запуск
    runpod.serverless.start({"handler": handler})