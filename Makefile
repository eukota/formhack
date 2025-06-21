# Variables
IMAGE_NAME = jupyter-n8n
CONTAINER_NAME = jupyter_n8n_dev
JUPYTER_PORT = 8888
N8N_PORT = 5678
N8N_VOLUME = n8n:/home/node/.n8n

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
		-p 8888:8888 \
		-p 5678:5678 \
		-p 7860:7860 \
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

run-app:
	docker exec -it $(CONTAINER_NAME) python /app/app.py

clean:
	@echo "Stopping and removing container $(CONTAINER_NAME) if it exists..."
	@docker stop $(CONTAINER_NAME) 2>/dev/null || true
	@docker rm $(CONTAINER_NAME) 2>/dev/null || true


##### SMALL IMAGE #####
make docker-build-small:
	docker build -t $(IMAGE_NAME)-small -f Dockerfile.small .

make docker-run-small:
	docker run -it --rm -p 7860:7860 -v $(PWD):/app $(IMAGE_NAME)-small
