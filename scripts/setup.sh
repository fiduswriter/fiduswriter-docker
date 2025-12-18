#!/bin/sh -e
#
# Quick setup script for Fiduswriter Docker
# This script helps set up a new Fiduswriter Docker installation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    printf "${BLUE}ℹ ${NC}%s\n" "$1"
}

print_success() {
    printf "${GREEN}✓${NC} %s\n" "$1"
}

print_warning() {
    printf "${YELLOW}⚠${NC} %s\n" "$1"
}

print_error() {
    printf "${RED}✗${NC} %s\n" "$1"
}

print_header() {
    echo ""
    echo "======================================"
    echo "$1"
    echo "======================================"
    echo ""
}

# Check if required commands exist
check_requirements() {
    print_header "Checking Requirements"

    missing_requirements=0

    if ! command -v docker >/dev/null 2>&1; then
        print_error "Docker is not installed"
        missing_requirements=1
    else
        print_success "Docker is installed: $(docker --version)"
    fi

    if ! command -v docker >/dev/null 2>&1 || ! docker compose version >/dev/null 2>&1; then
        print_error "Docker Compose is not installed or not available"
        missing_requirements=1
    else
        print_success "Docker Compose is available: $(docker compose version)"
    fi

    if [ $missing_requirements -eq 1 ]; then
        print_error "Please install missing requirements before continuing"
        exit 1
    fi
}

# Set up data directory with correct permissions
setup_data_directory() {
    print_header "Setting Up Data Directory"

    if [ ! -d "volumes/data" ]; then
        print_info "Creating data directory..."
        mkdir -p volumes/data volumes/data/media
        print_success "Data directory created"
    else
        print_info "Data directory already exists"
    fi

    print_info "Setting correct permissions (user:group 999:999)..."

    # Check if we need sudo
    if [ -w "volumes" ]; then
        chown -R 999:999 volumes/ 2>/dev/null || {
            print_warning "Cannot change ownership without sudo"
            sudo chown -R 999:999 volumes/
        }
        chmod -R 755 volumes/
    else
        sudo chown -R 999:999 volumes/
        sudo chmod -R 755 volumes/
    fi

    print_success "Permissions set correctly"
}

# Create environment file
setup_environment() {
    print_header "Setting Up Environment"

    if [ -f ".env" ]; then
        print_warning ".env file already exists, skipping creation"
        return
    fi

    if [ -f ".env.example" ]; then
        print_info "Creating .env file from .env.example..."
        cp .env.example .env
        print_success ".env file created"
        print_info "You can customize settings in .env file"
    else
        print_warning ".env.example not found, skipping .env creation"
    fi
}

# Build Docker image
build_image() {
    print_header "Building Docker Image"

    print_info "This may take several minutes on first run..."

    if docker compose build; then
        print_success "Docker image built successfully"
    else
        print_error "Failed to build Docker image"
        exit 1
    fi
}

# Start containers
start_containers() {
    print_header "Starting Containers"

    if docker compose up -d; then
        print_success "Containers started successfully"
    else
        print_error "Failed to start containers"
        exit 1
    fi

    print_info "Waiting for Fiduswriter to initialize..."
    sleep 5
}

# Check container status
check_status() {
    print_header "Checking Container Status"

    if docker compose ps | grep -q "fiduswriter.*Up"; then
        print_success "Fiduswriter container is running"
    else
        print_error "Fiduswriter container is not running properly"
        print_info "Checking logs..."
        docker compose logs --tail=50
        exit 1
    fi
}

# Prompt for superuser creation
create_superuser() {
    print_header "Create Superuser Account"

    print_info "You need to create a superuser account to access the admin panel"
    printf "Would you like to create a superuser now? (y/n): "
    read -r response

    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
        print_info "Creating superuser..."
        docker compose exec fiduswriter venv/bin/fiduswriter createsuperuser
        print_success "Superuser created"
    else
        print_info "You can create a superuser later with:"
        print_info "  docker compose exec fiduswriter venv/bin/fiduswriter createsuperuser"
        print_info "Or:"
        print_info "  make superuser"
    fi
}

# Display completion message
show_completion_message() {
    print_header "Setup Complete!"

    print_success "Fiduswriter is now running!"
    echo ""
    print_info "Access Fiduswriter at: http://localhost:8000"
    echo ""
    print_info "Important next steps:"
    echo "  1. Change the site domain in admin panel: http://localhost:8000/admin/sites/site/"
    echo "  2. Configure ALLOWED_HOSTS in volumes/data/configuration.py"
    echo "  3. Set up email server (optional) in volumes/data/configuration.py"
    echo ""
    print_info "Useful commands:"
    echo "  View logs:           docker compose logs -f"
    echo "  Stop containers:     docker compose down"
    echo "  Restart containers:  docker compose restart"
    echo "  Create superuser:    docker compose exec fiduswriter venv/bin/fiduswriter createsuperuser"
    echo ""
    echo "  Or use make commands:"
    echo "  make logs, make down, make restart, make superuser"
    echo "  Run 'make help' for all available commands"
    echo ""
    print_info "For production deployment:"
    echo "  - Set DEBUG=False in volumes/data/configuration.py"
    echo "  - Configure a proper database (PostgreSQL recommended)"
    echo "  - Set up SSL/TLS with a reverse proxy (nginx/apache)"
    echo "  - Configure email server for notifications"
    echo "  - Set up regular backups (make backup)"
    echo ""
}

# Main setup flow
main() {
    clear

    cat << "EOF"
    _____ _     _         _    _      _ _
   |  ___(_) __| |_   _ _| |  | |_ __(_) |_ ___ _ __
   | |_  | |/ _` | | | / __| | __/ _ \ | __/ _ \ '__|
   |  _| | | (_| | |_| \__ \ | ||  __/ | ||  __/ |
   |_|   |_|\__,_|\__,_|___/  \__\___|_|\__\___|_|

              Docker Quick Setup
EOF

    echo ""
    print_info "This script will help you set up Fiduswriter Docker"
    echo ""

    # Check if already running
    if docker compose ps 2>/dev/null | grep -q "fiduswriter.*Up"; then
        print_warning "Fiduswriter is already running!"
        printf "Do you want to continue anyway? (y/n): "
        read -r response
        if [ "$response" != "y" ] && [ "$response" != "Y" ]; then
            print_info "Setup cancelled"
            exit 0
        fi
    fi

    check_requirements
    setup_data_directory
    setup_environment
    build_image
    start_containers
    check_status

    echo ""
    create_superuser
    echo ""
    show_completion_message
}

# Run main function
main "$@"
