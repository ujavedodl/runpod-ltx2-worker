FROM runpod/pytorch:1.0.2-cu1281-torch280-ubuntu2404

ENV PYTHONUNBUFFERED=1
ENV HF_HOME=/runpod-volume/huggingface
ENV TRANSFORMERS_CACHE=/runpod-volume/huggingface
ENV TORCH_HOME=/runpod-volume/torch

WORKDIR /app

RUN apt-get update && apt-get install -y \
    git \
    git-lfs \
    ffmpeg \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

RUN python -m pip install --upgrade pip setuptools wheel

RUN pip install --no-cache-dir \
    runpod \
    imageio \
    imageio-ffmpeg \
    huggingface_hub \
    safetensors \
    accelerate \
    transformers \
    opencv-python \
    pillow \
    numpy

RUN git clone https://github.com/Lightricks/LTX-2.git /app/LTX-2

WORKDIR /app/LTX-2

RUN pip install --no-cache-dir -e packages/ltx-core
RUN pip install --no-cache-dir -e packages/ltx-pipelines

RUN python -c "from ltx_pipelines.ti2vid_one_stage import TI2VidOneStagePipeline; print('ltx_pipelines import OK')"

WORKDIR /app

COPY handler.py /app/handler.py

CMD ["python", "-u", "/app/handler.py"]
