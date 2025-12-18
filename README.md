# docker-fiduswriter

![GitHub tag (with filter)](https://img.shields.io/github/v/tag/fiduswriter/fiduswriter)
[![pulls](https://img.shields.io/docker/pulls/fiduswriter/fiduswriter.svg)](https://hub.docker.com/r/fiduswriter/fiduswriter/)
[![CI](https://github.com/fiduswriter/fiduswriter-docker/actions/workflows/ci.yml/badge.svg)](https://github.com/fiduswriter/fiduswriter-docker/actions/workflows/ci.yml)

[FidusWriter](https://github.com/fiduswriter/fiduswriter) is a collaborative online writing tool.
This is the official Docker image built following the installation manual for Ubuntu.

This project is the official Fidus Writer images and it's the continuation of the great work
done by Moritz at <https://github.com/moritzfl/docker-fiduswriter>. Check his repository if you
need older images.

## 🚀 What's New

- **Latest Fiduswriter** - Automatically tracks latest 4.0.x release
- **Python 3.14.2** - Modern Python runtime
- **Automated Updates** - GitHub Actions automatically check for new releases
- **CI/CD Pipeline** - Pre-commit hooks and automated testing
- **Multi-architecture** - Support for amd64 and arm64

## 📦 Docker Image Tags

Docker images are automatically built and tagged:

- **latest**: Latest release or prerelease
- **[MAJOR]**: Latest MAJOR release (e.g., `fiduswriter/fiduswriter:4`)
- **[MAJOR.minor]**: Latest MAJOR.minor release (e.g., `fiduswriter/fiduswriter:4.0`)
- **[MAJOR.minor.patch]**: Fixed version (e.g., `fiduswriter/fiduswriter:4.0.17`)

**Fixed versions are recommended for production sites.**

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/fiduswriter/fiduswriter-docker.git
cd fiduswriter-docker

# Set permissions for data directory
sudo mkdir -p volumes/data
sudo chown -R 999:999 volumes

# Start the container
docker compose up -d

# Create a superuser
docker compose exec fiduswriter venv/bin/fiduswriter createsuperuser

# Check logs
docker compose logs -f
```

Visit <http://localhost:8000> to access Fidus Writer.

### Using Makefile (Recommended)

```bash
# Complete development setup
make dev-setup

# Or step by step
make setup-data    # Set up data directory with correct permissions
make build         # Build Docker image
make up            # Start containers
make superuser     # Create admin user
```

Run `make help` to see all available commands.

## 🔧 Configuration

### Environment Variables

Copy the example environment file and customize it:

```bash
cp .env.example .env
nano .env
```

Key configuration options:

- `FIDUSWRITER_VERSION`: Fiduswriter version to use
- `HOST_PORT`: Port to expose on host (default: 8000)
- `DEBUG`: Debug mode (set to `false` in production)
- `ALLOWED_HOSTS`: Comma-separated list of allowed hosts

### Application Configuration

The main configuration file is at `volumes/data/configuration.py`. After first run, edit this
file to customize:

- `ALLOWED_HOSTS`: Add your domain name here
- `DEBUG`: Set to `False` in production
- `CONTACT_EMAIL`: Set your contact email
- `DATABASES`: Configure database settings (PostgreSQL, MySQL, etc.)
- `EMAIL_BACKEND`: Configure email service

Example:

```python
# volumes/data/configuration.py
ALLOWED_HOSTS = ['localhost', '127.0.0.1', 'your-domain.com']
DEBUG = False
CONTACT_EMAIL = 'admin@your-domain.com'
```

## 💾 Persistence

Data is stored in the `./volumes/data` directory, including:

- SQLite database (or configuration for external DB)
- User uploads and media files
- Configuration file

**Important:** Make sure to back up this directory regularly!

```bash
# Create a backup
make backup

# Or manually
tar -czf backup-$(date +%Y%m%d).tar.gz volumes/data
```

## 🌐 Running Behind a Reverse Proxy

When running behind Nginx, Apache, or similar:

**Forward the correct headers:**

```nginx
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;
```

**Update configuration.py:**

```python
ALLOWED_HOSTS = ['your-domain.com']
CSRF_TRUSTED_ORIGINS = ['https://your-domain.com']
```

**Example Nginx configuration:**

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## 🔄 Upgrading

### Automatic Updates

This repository includes GitHub Actions workflows that automatically:

- Check for new Fiduswriter releases daily
- Create pull requests for version updates
- Build and test Docker images

### Manual Upgrade

```bash
# Using Makefile
make check-update  # Check for new versions
make down          # Stop containers
make build         # Rebuild with new version
make up            # Start containers
make migrate       # Run database migrations if needed

# Or using docker compose
git pull
docker compose down
docker compose build --no-cache
docker compose up -d
docker compose exec fiduswriter venv/bin/fiduswriter migrate
```

### Upgrading to a Specific Version

```bash
# Set version in .env file
echo "FIDUSWRITER_VERSION=4.0.17" > .env

# Or pass as build argument
docker compose build --build-arg FIDUSWRITER_VERSION=4.0.17
docker compose up -d
```

### Important: Upgrading from 4.0.16

The update to Python 3.14.2 is handled automatically in the container build.
No configuration changes are required. Just follow the upgrade steps above.

**Always backup before upgrading:**

```bash
make backup  # Or: tar -czf backup-$(date +%Y%m%d).tar.gz volumes/data
```

## 🧪 Development and Testing

### Pre-commit Hooks

This repository uses pre-commit hooks for code quality:

```bash
# Install pre-commit hooks
make pre-commit

# Run manually
make lint

# Run specific linters
make lint-docker    # Lint Dockerfile
make lint-shell     # Lint shell scripts
make lint-markdown  # Lint markdown files
```

### CI/CD Pipeline

The repository includes GitHub Actions workflows for:

- **CI**: Runs on every push and PR (linting, validation, testing)
- **Docker Build**: Builds and publishes images (multi-architecture)
- **Version Check**: Daily check for updates (creates automated PRs)

## 🛠️ Common Tasks

### Create Superuser

```bash
make superuser
# Or
docker compose exec fiduswriter venv/bin/fiduswriter createsuperuser
```

### Run Django Management Commands

```bash
docker compose exec fiduswriter venv/bin/fiduswriter <command>

# Examples:
docker compose exec fiduswriter venv/bin/fiduswriter migrate
docker compose exec fiduswriter venv/bin/fiduswriter collectstatic
docker compose exec fiduswriter venv/bin/fiduswriter check
```

### Access Container Shell

```bash
make shell
# Or
docker compose exec fiduswriter /bin/bash
```

### View Logs

```bash
make logs
# Or
docker compose logs -f
```

### Check Status

```bash
make status
# Or
docker compose ps
```

## 📊 Version Information

### Current Versions

- **Fiduswriter**: Tracks latest 4.0.x
- **Python**: 3.14.2
- **Node.js**: 22.x
- **Ubuntu**: 24.04

### Check Your Version

```bash
# Check Dockerfile version
make version

# Check running container version
docker compose exec fiduswriter venv/bin/pip show fiduswriter

# Check for updates
make check-update
```

## 🐛 Troubleshooting

### Database Permissions

If you encounter database permission issues:

```bash
sudo chown -R 999:999 volumes/data
sudo chmod -R 755 volumes/data
```

### Email Configuration

By default, emails are printed to the console. To set up a real email service, configure
these settings in `configuration.py`:

```python
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'smtp.gmail.com'
EMAIL_PORT = 587
EMAIL_USE_TLS = True
EMAIL_HOST_USER = 'your-email@gmail.com'
EMAIL_HOST_PASSWORD = 'your-app-password'  # pragma: allowlist secret
DEFAULT_FROM_EMAIL = 'noreply@your-domain.com'
```

### Container Won't Start

```bash
# Check logs
docker compose logs

# Verify permissions
ls -la volumes/data

# Reset and try again
make clean
make setup-data
make build
make up
```

### Port Already in Use

Change the host port in `.env`:

```bash
echo "HOST_PORT=8080" >> .env
docker compose up -d
```

### Database Migration Issues

```bash
# Run migrations manually
docker compose exec fiduswriter venv/bin/fiduswriter migrate

# Or reset database (WARNING: destroys data!)
docker compose down -v
rm volumes/data/fiduswriter.sql
docker compose up -d
```

## 🔒 Security Considerations

1. **Change default secret key** in production
2. **Set DEBUG=False** in `configuration.py`
3. **Configure ALLOWED_HOSTS** properly
4. **Use HTTPS** with a reverse proxy
5. **Regular backups** of the data directory
6. **Keep Docker images updated**
7. **Use strong passwords** for superuser accounts
8. **Configure CSRF_TRUSTED_ORIGINS** for HTTPS

## 📚 Additional Resources

- [Fiduswriter Documentation](https://www.fiduswriter.org/help/)
- [Fiduswriter GitHub](https://github.com/fiduswriter/fiduswriter)
- [Docker Documentation](https://docs.docker.com/)
- [Issue Tracker](https://github.com/fiduswriter/fiduswriter-docker/issues)

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Install pre-commit hooks: `make pre-commit`
4. Make your changes
5. Run tests and linters: `make lint test`
6. Submit a pull request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

## 📝 License

This project follows the same license as Fiduswriter. See LICENSE.txt for details.

## 💬 Support

- **Issues**: [GitHub Issues](https://github.com/fiduswriter/fiduswriter-docker/issues)
- **Discussions**: [GitHub Discussions](https://github.com/fiduswriter/fiduswriter-docker/discussions)
- **Fiduswriter Support**: [Fiduswriter Help](https://www.fiduswriter.org/help/)

---

**Note**: Until you configure a mail server, registration emails will be printed to the
container logs. Access them with `docker compose logs -f`.
