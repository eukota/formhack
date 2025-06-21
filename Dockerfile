# Base image with Python 3.12
FROM python:3.12-slim

# Environment setup
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    N8N_PORT=5678 \
    JUPYTER_PORT=8888

# Install system dependencies and Node.js 20.x
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    build-essential \
    git \
    libssl-dev \
    libffi-dev \
    wget \
    ca-certificates \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install JupyterLab and Python tools
RUN pip install --no-cache-dir \
    jupyterlab \
    notebook \
    ipykernel \
    pandas \
    numpy \
    matplotlib \
    seaborn \
    requests

# Install n8n
RUN npm install -g n8n

# Expose both ports
EXPOSE ${N8N_PORT} ${JUPYTER_PORT}

# Create working dir
WORKDIR /app

# Startup command: run both n8n and JupyterLab
CMD bash -c "n8n & jupyter lab --ip=0.0.0.0 --port=${JUPYTER_PORT} --no-browser --allow-root --NotebookApp.token=''"
