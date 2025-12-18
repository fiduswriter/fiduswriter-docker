.PHONY: help build up down restart logs shell test lint format clean prune

# Default target
help:
	@echo "Fiduswriter Docker - Available Commands"
	@echo "========================================"
	@echo ""
	@echo "Development:"
	@echo "  make build          - Build the Docker image"
	@echo "  make up             - Start the containers"
	@echo "  make down           - Stop the containers"
	@echo "  make restart        - Restart the containers"
	@echo "  make logs           - View container logs"
	@echo "  make shell          - Open a shell in the container"
	@echo ""
	@echo "Maintenance:"
	@echo "  make clean          - Remove stopped containers and volumes"
	@echo "  make prune          - Deep clean (removes images too)"
	@echo "  make setup-data     - Set up data directory with correct permissions"
	@echo "  make backup         - Backup data directory"
	@echo ""
	@echo "Quality Assurance:"
	@echo "  make lint           - Run all linters"
	@echo "  make lint-docker    - Lint Dockerfile with hadolint"
	@echo "  make lint-shell     - Lint shell scripts"
	@echo "  make lint-markdown  - Lint markdown files"
	@echo "  make test           - Run tests"
	@echo "  make pre-commit     - Install pre-commit hooks"
	@echo ""
	@echo "User Management:"
	@echo "  make superuser      - Create a superuser account"
	@echo ""
	@echo "Version Management:"
	@echo "  make version        - Show current Fiduswriter version"
	@echo "  make check-update   - Check for new Fiduswriter versions"
	@echo ""

# Build the Docker image
build:
	@echo "Building Docker image..."
	docker compose build

# Build with specific version
build-version:
	@read -p "Enter Fiduswriter version (e.g., 4.0.17): " version; \
	docker compose build --build-arg FIDUSWRITER_VERSION=$$version

# Start containers
up:
	@echo "Starting containers..."
	docker compose up -d

# Stop containers
down:
	@echo "Stopping containers..."
	docker compose down

# Restart containers
restart: down up

# View logs
logs:
	docker compose logs -f

# Open shell in container
shell:
	docker compose exec fiduswriter /bin/bash

# Create superuser
superuser:
	@echo "Creating superuser account..."
	docker compose exec fiduswriter venv/bin/fiduswriter createsuperuser

# Run migrations
migrate:
	@echo "Running database migrations..."
	docker compose exec fiduswriter venv/bin/fiduswriter migrate

# Clean up
clean:
	@echo "Cleaning up stopped containers and volumes..."
	docker compose down -v

# Deep clean
prune: clean
	@echo "Removing Docker images..."
	docker rmi fiduswriter-docker-fiduswriter 2>/dev/null || true
	@echo "Pruning Docker system..."
	docker system prune -f

# Set up data directory with correct permissions
setup-data:
	@echo "Setting up data directory..."
	mkdir -p volumes/data volumes/data/media
	sudo chown -R 999:999 volumes/
	sudo chmod -R 755 volumes/
	@echo "Data directory ready!"

# Backup data directory
backup:
	@echo "Creating backup..."
	tar -czf backup-$$(date +%Y%m%d-%H%M%S).tar.gz volumes/data
	@echo "Backup created!"

# Install pre-commit hooks
pre-commit:
	@echo "Installing pre-commit hooks..."
	pip install pre-commit
	pre-commit install
	@echo "Pre-commit hooks installed!"

# Run pre-commit on all files
pre-commit-all:
	@echo "Running pre-commit on all files..."
	pre-commit run --all-files

# Lint everything
lint: lint-docker lint-shell lint-markdown

# Lint Dockerfile
lint-docker:
	@echo "Linting Dockerfile..."
	@command -v hadolint >/dev/null 2>&1 || { \
		echo "hadolint not found. Install with: brew install hadolint"; \
		exit 1; \
	}
	hadolint Dockerfile --config .hadolint.yaml

# Lint shell scripts
lint-shell:
	@echo "Linting shell scripts..."
	@command -v shellcheck >/dev/null 2>&1 || { \
		echo "shellcheck not found. Install with: brew install shellcheck"; \
		exit 1; \
	}
	shellcheck start-fiduswriter.sh

# Lint markdown files
lint-markdown:
	@echo "Linting markdown files..."
	@command -v markdownlint >/dev/null 2>&1 || { \
		echo "markdownlint not found. Install with: npm install -g markdownlint-cli"; \
		exit 1; \
	}
	markdownlint '**/*.md' --config .markdownlint.json --ignore node_modules

# Run tests
test:
	@echo "Running tests..."
	docker compose build
	docker compose up -d
	@echo "Waiting for container to start..."
	@sleep 10
	@echo "Checking container status..."
	docker compose ps
	@echo "Checking logs..."
	docker compose logs
	docker compose down

# Show current version
version:
	@echo "Current Fiduswriter version in Dockerfile:"
	@grep -oP 'ARG FIDUSWRITER_VERSION=\K[0-9.]+' Dockerfile || echo "Version not found"

# Check for updates
check-update:
	@echo "Checking for new Fiduswriter versions..."
	@python3 -c "import json, urllib.request, re; \
		url = 'https://pypi.org/pypi/fiduswriter/json'; \
		response = urllib.request.urlopen(url); \
		data = json.loads(response.read()); \
		versions = list(data['releases'].keys()); \
		pattern = re.compile(r'^4\.0\.\d+$$'); \
		v40_versions = [v for v in versions if pattern.match(v)]; \
		v40_versions.sort(key=lambda s: [int(u) for u in s.split('.')]); \
		print('Latest 4.0.x version:', v40_versions[-1] if v40_versions else 'Unknown')"
	@echo ""
	@echo "Current version:"
	@make version

# Show container status
status:
	@echo "Container status:"
	docker compose ps
	@echo ""
	@echo "Resource usage:"
	docker stats --no-stream fiduswriter 2>/dev/null || echo "Container not running"

# Development setup (complete)
dev-setup: setup-data build up superuser
	@echo ""
	@echo "Development environment ready!"
	@echo "Access Fiduswriter at: http://localhost:8000"
	@echo ""

# Production setup guide
prod-setup:
	@echo "Production Setup Guide"
	@echo "====================="
	@echo ""
	@echo "1. Set up data directory:"
	@echo "   make setup-data"
	@echo ""
	@echo "2. Edit configuration:"
	@echo "   cp volumes/data/configuration.py.example volumes/data/configuration.py"
	@echo "   nano volumes/data/configuration.py"
	@echo ""
	@echo "3. Update ALLOWED_HOSTS, set DEBUG=False, configure email, etc."
	@echo ""
	@echo "4. Build and start:"
	@echo "   make build"
	@echo "   make up"
	@echo ""
	@echo "5. Create superuser:"
	@echo "   make superuser"
	@echo ""
	@echo "6. Configure site in admin panel:"
	@echo "   http://your-domain/admin/sites/site/"
	@echo ""
