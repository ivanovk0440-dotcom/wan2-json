FROM runpod/worker-comfyui:5.5.1-base

# Установка git и других зависимостей
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Клонирование кастомных нод
WORKDIR /comfyui/custom_nodes
RUN git clone https://github.com/kijai/ComfyUI-WanVideoWrapper.git
RUN git clone https://github.com/fannovel16/ComfyUI-Frame-Interpolation.git
RUN git clone https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git
RUN git clone https://github.com/yolain/ComfyUI-Easy-Use.git
RUN git clone https://github.com/kijai/ComfyUI-KJNodes.git

# Установка всех необходимых Python-пакетов
RUN pip install --no-cache-dir opencv-python accelerate gguf runpod requests

# Скачивание моделей
WORKDIR /comfyui
RUN comfy model download --url "https://huggingface.co/jasonot/mycomfyui/resolve/main/rife47.pth?download=1" --relative-path models/rife --filename rife47.pth
RUN comfy model download --url "https://huggingface.co/FX-FeiHou/wan2.2-Remix/resolve/main/NSFW/Wan2.2_Remix_NSFW_i2v_14b_low_lighting_v2.0.safetensors?download=1" --relative-path models/diffusion_models --filename Wan2.2_Remix_NSFW_i2v_14b_low_lighting_v2.0.safetensors
RUN comfy model download --url "https://huggingface.co/NSFW-API/NSFW-Wan-UMT5-XXL/resolve/main/nsfw_wan_umt5-xxl_fp8_scaled.safetensors?download=1" --relative-path models/text_encoders --filename nsfw_wan_umt5-xxl_fp8_scaled.safetensors
RUN comfy model download --url "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors?download=1" --relative-path models/vae --filename wan_2.1_vae.safetensors

# Копирование workflow и хендлера
COPY Wan22-I2V-Remix.json /comfyui/workflow.json
COPY handler.py /handler.py

# Даем права на выполнение
RUN chmod +x /handler.py

# Запускаем хендлер (серверлес-воркер)
CMD ["python", "/handler.py"]
