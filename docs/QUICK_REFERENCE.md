# Quick Reference Guide

Fast command reference for Fiduswriter Docker.

## 🚀 Quick Start Commands

```bash
# Complete setup (one command)
make dev-setup

# Or step by step
make setup-data     # Set up data directory
make build          # Build Docker image
make up             # Start containers
make superuser      # Create admin user
```

## 📦 Docker Compose Commands

```bash
# Start containers
docker compose up -d

# Stop containers
docker compose down

# Restart containers
docker compose restart

# View logs
docker compose logs -f

# Check status
docker compose ps

# Build/rebuild image
docker compose build
docker compose build --no-cache

# Execute command in container
docker compose exec fiduswriter <command>

# Remove everything (including volumes)
docker compose down -v
```

## 🛠️ Makefile Commands

```bash
make help           # Show all available commands

# Development
make build          # Build Docker image
make up             # Start containers
make down           # Stop containers
make restart        # Restart containers
make logs           # View logs
make shell          # Open shell in container

# Maintenance
make clean          # Remove containers and volumes
make prune          # Deep clean (removes images)
make setup-data     # Set up data directory permissions
make backup         # Backup data directory

# Quality Assurance
make lint           # Run all linters
make lint-docker    # Lint Dockerfile
make lint-shell     # Lint shell scripts
make lint-markdown  # Lint markdown files
make test           # Run tests
make pre-commit     # Install pre-commit hooks

# User Management
make superuser      # Create superuser
make migrate        # Run database migrations

# Version Management
make version        # Show current version
make check-update   # Check for new versions
```

## 🐍 Django Management Commands

```bash
# General syntax
docker compose exec fiduswriter venv/bin/fiduswriter <command>

# Common commands
docker compose exec fiduswriter venv/bin/fiduswriter migrate
docker compose exec fiduswriter venv/bin/fiduswriter createsuperuser
docker compose exec fiduswriter venv/bin/fiduswriter collectstatic
docker compose exec fiduswriter venv/bin/fiduswriter check
docker compose exec fiduswriter venv/bin/fiduswriter shell
docker compose exec fiduswriter venv/bin/fiduswriter dbshell
docker compose exec fiduswriter venv/bin/fiduswriter showmigrations
docker compose exec fiduswriter venv/bin/fiduswriter flush
```

## 📂 File Locations

```bash
# Configuration
volumes/data/configuration.py       # Main configuration file
.env                                # Environment variables
docker-compose.yml                  # Docker compose config

# Data
volumes/data/                       # All persistent data
volumes/data/fiduswriter.sql        # SQLite database (default)
volumes/data/media/                 # User uploads

# Logs
docker compose logs                 # View container logs
docker compose logs -f              # Follow logs
docker compose logs --tail=100      # Last 100 lines
```

## 🔑 Important File Paths (Inside Container)

```bash
/fiduswriter/                       # Application root
/fiduswriter/venv/                  # Python virtual environment
/fiduswriter/configuration.py       # Config (symlink to /data/configuration.py)
/fiduswriter/media/                 # Media files (symlink to /data/media/)
/data/                              # Persistent data volume
```

## 🔧 Common Tasks

### Create Superuser

```bash
make superuser
# Or
docker compose exec fiduswriter venv/bin/fiduswriter createsuperuser
```

### Backup Data

```bash
make backup
# Or
tar -czf backup-$(date +%Y%m%d).tar.gz volumes/data
```

### Restore from Backup

```bash
docker compose down
rm -rf volumes/data/*
tar -xzf backup-20240101.tar.gz -C .
docker compose up -d
```

### View Logs

```bash
make logs
# Or
docker compose logs -f
docker compose logs --tail=100
docker compose logs --since=1h
```

### Check Version

```bash
make version
# Or
docker compose exec fiduswriter venv/bin/pip show fiduswriter
docker compose exec fiduswriter python3 --version
```

### Update to Latest Version

```bash
make down
git pull
make build
make up
make migrate
```

### Reset Database (⚠️ Destroys data!)

```bash
docker compose down -v
rm volumes/data/fiduswriter.sql
docker compose up -d
make superuser
```

### Fix Permissions

```bash
make setup-data
# Or
sudo chown -R 999:999 volumes/
sudo chmod -R 755 volumes/
```

### Access Container Shell

```bash
make shell
# Or
docker compose exec fiduswriter /bin/bash
docker compose exec fiduswriter sh
```

### Run Python Shell

```bash
docker compose exec fiduswriter venv/bin/python
# Or Django shell
docker compose exec fiduswriter venv/bin/fiduswriter shell
```

## 🌐 Configuration Variables

### Environment Variables (.env)

```bash
FIDUSWRITER_VERSION=4.0.17          # Fiduswriter version
HOST_PORT=8000                      # Host port
DEBUG=false                         # Debug mode
TZ=UTC                              # Timezone
```

### Key Configuration Settings (configuration.py)

```python
DEBUG = False                       # Debug mode
ALLOWED_HOSTS = ['domain.com']     # Allowed hosts
CONTACT_EMAIL = 'admin@domain.com' # Contact email
SECRET_KEY = 'your-secret-key'     # pragma: allowlist secret
CSRF_TRUSTED_ORIGINS = ['https://domain.com']  # CSRF origins

# Database
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'fiduswriter',
        'USER': 'fiduswriter',
        'PASSWORD': 'password',  # pragma: allowlist secret
        'HOST': 'db',
        'PORT': '5432',
    }
}

# Email
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'smtp.example.com'
EMAIL_PORT = 587
EMAIL_USE_TLS = True
EMAIL_HOST_USER = 'user@example.com'
EMAIL_HOST_PASSWORD = 'password'  # pragma: allowlist secret
```

## 🐛 Troubleshooting Quick Fixes

### Container Won't Start

```bash
docker compose logs
sudo chown -R 999:999 volumes/data
docker compose down
docker compose up -d
```

### Port Already in Use

```bash
# Change port in .env
echo "HOST_PORT=8080" >> .env
docker compose down
docker compose up -d
```

### Permission Denied

```bash
sudo chown -R 999:999 volumes/
sudo chmod -R 755 volumes/
docker compose restart
```

### Database Locked

```bash
docker compose restart
# Or
docker compose down
docker compose up -d
```

### Migrations Not Applied

```bash
docker compose exec fiduswriter venv/bin/fiduswriter migrate
# Or force
docker compose exec fiduswriter venv/bin/fiduswriter migrate --run-syncdb
```

### Clear Everything and Start Fresh

```bash
make prune
rm -rf volumes/data/*
make setup-data
make build
make up
make superuser
```

## 📊 Monitoring

### Check Container Status

```bash
docker compose ps
docker stats fiduswriter
docker inspect fiduswriter
```

### Check Disk Usage

```bash
docker system df
du -sh volumes/data
df -h
```

### Health Check

```bash
docker compose exec fiduswriter venv/bin/fiduswriter check
curl http://localhost:8000
```

## 🔄 Update Workflow

### Check for Updates

```bash
make check-update
python3 scripts/check-version.py
```

### Update Process

```bash
# 1. Backup
make backup

# 2. Stop
make down

# 3. Update
git pull

# 4. Rebuild
make build

# 5. Start
make up

# 6. Migrate
make migrate

# 7. Verify
make logs
```

## 🔒 Security Checklist

```bash
# Check these before going to production:
[ ] DEBUG = False in configuration.py
[ ] Changed SECRET_KEY from default
[ ] Set proper ALLOWED_HOSTS
[ ] Configured CSRF_TRUSTED_ORIGINS for HTTPS
[ ] Using strong superuser password
[ ] Regular backups configured
[ ] SSL/TLS configured (reverse proxy)
[ ] Email server configured
[ ] Proper file permissions (999:999)
```

## 📞 Getting Help

```bash
# View help
make help
docker compose --help
docker compose exec fiduswriter venv/bin/fiduswriter help

# Check documentation
cat README.md
cat CONTRIBUTING.md
cat UPGRADE_GUIDE.md

# Online resources
# - GitHub: https://github.com/fiduswriter/fiduswriter-docker
# - Fiduswriter: https://www.fiduswriter.org/help/
```

## 💡 Pro Tips

1. **Always backup before making changes**

   ```bash
   make backup
   ```

2. **Use `.env` for configuration**

   ```bash
   cp .env.example .env
   ```

3. **Pin versions in production**

   ```bash
   FIDUSWRITER_VERSION=4.0.17
   ```

4. **Monitor logs regularly**

   ```bash
   make logs
   ```

5. **Keep system updated**

   ```bash
   make check-update
   ```

6. **Use Makefile for consistency**

   ```bash
   make <command>
   ```

7. **Test in staging first**

   ```bash
   # Copy setup to staging environment
   ```

8. **Document customizations**

   ```bash
   # Keep notes of config changes
   ```

---

**Quick Links:**

- [README](../README.md)
- [Contributing](../CONTRIBUTING.md)
- [Upgrade Guide](../UPGRADE_GUIDE.md)
- [Changelog](../CHANGELOG.md)
