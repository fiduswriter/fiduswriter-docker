# Upgrade Guide

This guide helps you upgrade your Fiduswriter Docker installation.

## Quick Upgrade

```bash
# 1. Backup your data (CRITICAL!)
make backup

# 2. Stop containers
make down

# 3. Update repository
git pull

# 4. Rebuild image
make build

# 5. Start containers
make up

# 6. Run migrations (if needed)
make migrate

# 7. Verify
make logs
```

## Upgrading from 4.0.16 to Current

### What's Changed

- **Python**: Upgraded to 3.14.2 from deadsnakes PPA (handled in container)
- **Build Process**: Now supports build arguments for version specification
- **Tooling**: Added Makefile, pre-commit hooks, and helper scripts

### Prerequisites

1. **Backup your data**:
   ```bash
   make backup
   # Or: tar -czf backup-$(date +%Y%m%d).tar.gz volumes/data
   ```

2. **Check disk space**:
   ```bash
   df -h volumes/data
   ```

3. **Save configuration**:
   ```bash
   cp volumes/data/configuration.py volumes/data/configuration.py.backup
   ```

### Upgrade Steps

```bash
# Stop services
docker compose down

# Update code
git pull origin main

# Rebuild with no cache (recommended for major upgrades)
docker compose build --no-cache

# Start services
docker compose up -d

# Run migrations if needed
docker compose exec fiduswriter venv/bin/fiduswriter migrate

# Check logs
docker compose logs -f
```

### Post-Upgrade Verification

1. **Check container status**: `docker compose ps`
2. **Verify Python version**: `docker compose exec fiduswriter python3 --version`
3. **Test application**: Open http://localhost:8000 and verify functionality
4. **Check logs**: `docker compose logs` for any errors

### Configuration

Your existing `configuration.py` should work without changes. No action required.

## Rollback Procedure

If you need to rollback:

```bash
# Stop current version
docker compose down

# Checkout previous version
git checkout v4.0.16

# Restore configuration if needed
cp volumes/data/configuration.py.backup volumes/data/configuration.py

# Rebuild and start
docker compose build --no-cache
docker compose up -d
```

## Troubleshooting

### Container Won't Start

```bash
# Check logs
docker compose logs

# Fix permissions
sudo chown -R 999:999 volumes/data
sudo chmod -R 755 volumes/data
docker compose restart
```

### Port Conflicts

```bash
# Change port in .env
echo "HOST_PORT=8080" >> .env
docker compose down
docker compose up -d
```

### Migration Errors

```bash
# Show current migrations
docker compose exec fiduswriter venv/bin/fiduswriter showmigrations

# Run migrations
docker compose exec fiduswriter venv/bin/fiduswriter migrate
```

### Database Issues

```bash
# Run Django checks
docker compose exec fiduswriter venv/bin/fiduswriter check

# Collect static files
docker compose exec fiduswriter venv/bin/fiduswriter collectstatic --noinput
```

## Best Practices

1. **Always backup before upgrading**
2. **Test in staging first** if possible
3. **Read the changelog** before upgrading
4. **Monitor logs** during and after upgrade
5. **Verify all functionality** after upgrade
6. **Use version pinning** in production (not `latest`)

## Getting Help

If you encounter issues:

1. Check the [README.md](README.md)
2. Search [GitHub Issues](https://github.com/fiduswriter/fiduswriter-docker/issues)
3. Check [Fiduswriter Documentation](https://www.fiduswriter.org/help/)
4. Create a new issue with full error logs and environment details

---

**Remember**: Always backup before upgrading!