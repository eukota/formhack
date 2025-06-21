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

# Create working dir
WORKDIR /app

# Copy requirements.txt into the image
COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip setuptools wheel \
 && pip install --prefer-binary numpy \
 && pip install --no-cache-dir -r requirements.txt

# Install JupyterLab
RUN pip install --no-cache-dir \
    jupyterlab \
    notebook \
    ipykernel \
    pandas \
    matplotlib \
    seaborn \
    requests

# Install n8n
RUN npm install -g n8n

# Expose both ports
EXPOSE ${N8N_PORT} ${JUPYTER_PORT}

# Copy App in
RUN mkdir -p /app
COPY app.py /app/app.py

# Create a mountable notebooks directory
RUN mkdir -p /app/notebooks


# Startup command: run both n8n and JupyterLab
CMD bash -c "n8n & jupyter lab --ip=0.0.0.0 --notebook-dir=/app/notebooks --port=${JUPYTER_PORT} --no-browser --allow-root --NotebookApp.token=''"
