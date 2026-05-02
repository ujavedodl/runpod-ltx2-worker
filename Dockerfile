FROM runpod/pytorch:2.7.0-py3.12-cuda12.8.1-devel-ubuntu22.04

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

RUN pip install --upgrade pip

RUN pip install runpod imageio imageio-ffmpeg huggingface_hub safetensors accelerate transformers

RUN git clone https://github.com/Lightricks/LTX-2.git /app/LTX-2

WORKDIR /app/LTX-2

RUN pip install -e packages/ltx-core
RUN pip install -e packages/ltx-pipelines

WORKDIR /app

COPY handler.py /app/handler.py

CMD ["python", "-u", "/app/handler.py"]
