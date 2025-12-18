# Getting Started with Fiduswriter Docker

Welcome! This guide will help you get Fiduswriter up and running quickly.

## Prerequisites

- **Docker**: Version 20.10 or higher
- **Docker Compose**: Version 2.0 or higher
- **Git**: To clone the repository

## Quick Start

### Step 1: Clone and Setup

```bash
git clone https://github.com/fiduswriter/fiduswriter-docker.git
cd fiduswriter-docker

# Run the setup script (interactive)
./scripts/setup.sh
```

The script will guide you through the entire setup process.

### Step 2: Access Fiduswriter

Open your browser to: **<http://localhost:8000>**

## Manual Setup

If you prefer step-by-step control:

```bash
# 1. Clone repository
git clone https://github.com/fiduswriter/fiduswriter-docker.git
cd fiduswriter-docker

# 2. Set up data directory with correct permissions
make setup-data

# 3. Build Docker image
make build

# 4. Start containers
make up

# 5. Create admin account
make superuser

# 6. Access at http://localhost:8000
```

## Basic Configuration

### Change the Port

If port 8000 is already in use:

```bash
echo "HOST_PORT=8080" > .env
docker compose restart
```

### Configure Your Domain

Edit `volumes/data/configuration.py`:

```python
ALLOWED_HOSTS = ['your-domain.com', 'localhost']
DEBUG = False  # Important for production!
CONTACT_EMAIL = 'admin@your-domain.com'
```

Restart after changes: `docker compose restart`

## Common Commands

```bash
# View logs
make logs

# Stop containers
make down

# Restart containers
make restart

# Create backup
make backup

# Check status
make status

# See all commands
make help
```

## Next Steps

1. **Configure site**: Go to <http://localhost:8000/admin/sites/site/>
2. **Change domain**: Update from example.com to your domain
3. **Set up email**: Edit `configuration.py` (optional)
4. **Create backups**: Run `make backup` regularly

## Troubleshooting

### Container Won't Start

```bash
# Check logs
docker compose logs

# Fix permissions
sudo chown -R 999:999 volumes/data
docker compose restart
```

### Port Already in Use

```bash
# Change port
echo "HOST_PORT=8080" >> .env
docker compose down
docker compose up -d
```

### Forgot Admin Password

```bash
# Create new superuser
make superuser

# Or change password
docker compose exec fiduswriter venv/bin/fiduswriter changepassword username
```

## Production Deployment

For production use:

1. **Set DEBUG=False** in `configuration.py`
2. **Use PostgreSQL** instead of SQLite
3. **Set up SSL/TLS** with reverse proxy (nginx/apache)
4. **Configure email** server
5. **Set up backups** (automated)

See [README.md](README.md) for detailed production setup instructions.

## Getting Help

- **Documentation**: [README.md](README.md)
- **Quick Reference**: [docs/QUICK_REFERENCE.md](docs/QUICK_REFERENCE.md)
- **Upgrade Guide**: [UPGRADE_GUIDE.md](UPGRADE_GUIDE.md)
- **Issues**: [GitHub Issues](https://github.com/fiduswriter/fiduswriter-docker/issues)
- **Fiduswriter Help**: [Official Documentation](https://www.fiduswriter.org/help/)

---

Happy writing! 📝
