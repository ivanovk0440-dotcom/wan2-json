# Base image
FROM runpod/worker-comfyui:5.5.1-base

# Устанавливаем кастомные ноды
RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/kijai/ComfyUI-WanVideoWrapper.git && \
    git clone https://github.com/fannovel16/ComfyUI-Frame-Interpolation.git && \
    git clone https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git && \
    git clone https://github.com/yolain/ComfyUI-Easy-Use.git && \
    git clone https://github.com/kijai/ComfyUI-KJNodes.git

# Устанавливаем только необходимые пакеты (без sageattention и без requirements.txt нод)
RUN pip install --no-cache-dir opencv-python accelerate

# Скачиваем модели
RUN comfy model download --url https://huggingface.co/jasonot/mycomfyui/blob/main/rife47.pth --relative-path models/rife --filename rife47.pth
RUN comfy model download --url https://huggingface.co/FX-FeiHou/wan2.2-Remix/resolve/main/NSFW/Wan2.2_Remix_NSFW_i2v_14b_low_lighting_v2.0.safetensors --relative-path models/diffusion_models --filename Wan2.2_Remix_NSFW_i2v_14b_low_lighting_v2.0.safetensors
RUN comfy model download --url https://huggingface.co/NSFW-API/NSFW-Wan-UMT5-XXL/resolve/main/nsfw_wan_umt5-xxl_fp8_scaled.safetensors --relative-path models/text_encoders --filename nsfw_wan_umt5-xxl_fp8_scaled.safetensors
RUN comfy model download --url https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors --relative-path models/vae --filename wan_2.1_vae.safetensors

# Копируем workflow
COPY Wan22-I2V-Remix.json /comfyui/workflow.json
