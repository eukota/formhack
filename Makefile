# Variables
IMAGE_NAME = jupyter-n8n
CONTAINER_NAME = jupyter_n8n_dev
JUPYTER_PORT = 8888
N8N_PORT = 5678
N8N_VOLUME = ~/.n8n:/home/node/.n8n

# n8n basic auth credentials
N8N_USER = admin
N8N_PASS = changeme

.PHONY: build run stop rm logs

# Build the Docker image
build:
	docker build -t $(IMAGE_NAME) .

# Run the container
run:
	docker run -it \
		--name $(CONTAINER_NAME) \
		-p $(JUPYTER_PORT):8888 \
		-p $(N8N_PORT):5678 \
		-v $(N8N_VOLUME) \
		-e N8N_BASIC_AUTH_ACTIVE=true \
		-e N8N_BASIC_AUTH_USER=$(N8N_USER) \
		-e N8N_BASIC_AUTH_PASSWORD=$(N8N_PASS) \
		$(IMAGE_NAME)

# Stop the container (only needed for detached mode)
stop:
	docker stop $(CONTAINER_NAME)

# Remove the container
rm:
	docker rm $(CONTAINER_NAME)

# View logs
logs:
	docker logs -f $(CONTAINER_NAME)

start:
	docker start -ai $(CONTAINER_NAME)
