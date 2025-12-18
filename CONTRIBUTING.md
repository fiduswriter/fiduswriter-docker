# Contributing to Fiduswriter Docker

Thank you for your interest in contributing to the Fiduswriter Docker project! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Making Changes](#making-changes)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Style Guidelines](#style-guidelines)
- [Reporting Issues](#reporting-issues)

## Code of Conduct

This project follows the [Fiduswriter Code of Conduct](https://github.com/fiduswriter/fiduswriter/blob/main/CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR-USERNAME/fiduswriter-docker.git
   cd fiduswriter-docker
   ```
3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/fiduswriter/fiduswriter-docker.git
   ```

## Development Setup

### Prerequisites

- Docker and Docker Compose
- Python 3.8+ (for pre-commit hooks)
- Git
- Make (optional, but recommended)

### Install Development Tools

```bash
# Install pre-commit hooks
make pre-commit

# Or manually
pip install pre-commit
pre-commit install
```

### Install Linters (Optional)

For local linting without pre-commit:

```bash
# macOS (using Homebrew)
brew install hadolint shellcheck
npm install -g markdownlint-cli

# Ubuntu/Debian
sudo apt-get install shellcheck
wget -O hadolint https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-x86_64
chmod +x hadolint
sudo mv hadolint /usr/local/bin/

npm install -g markdownlint-cli
```

### Build and Test Locally

```bash
# Complete development setup
make dev-setup

# Or step by step
make setup-data
make build
make up
make superuser

# View logs
make logs
```

## Making Changes

### Branch Naming

Use descriptive branch names:

- `feature/description` - New features
- `fix/description` - Bug fixes
- `docs/description` - Documentation changes
- `refactor/description` - Code refactoring
- `test/description` - Test additions or fixes
- `chore/description` - Maintenance tasks

Example:
```bash
git checkout -b feature/add-postgresql-support
```

### Commit Messages

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `ci`: CI/CD changes

Examples:
```
feat(docker): add support for PostgreSQL database

fix(dockerfile): correct Python version installation

docs(readme): update installation instructions

chore(deps): update fiduswriter to 4.0.18
```

### Keep Your Fork Updated

```bash
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

## Testing

### Run All Tests

```bash
make test
```

### Run Specific Tests

```bash
# Lint everything
make lint

# Lint Dockerfile
make lint-docker

# Lint shell scripts
make lint-shell

# Lint markdown files
make lint-markdown

# Run pre-commit on all files
make pre-commit-all
```

### Manual Testing

```bash
# Build the image
docker compose build

# Start the container
docker compose up -d

# Check logs
docker compose logs -f

# Test functionality
docker compose exec fiduswriter venv/bin/fiduswriter check

# Clean up
docker compose down
```

### Test Different Versions

```bash
# Test with specific Fiduswriter version
FIDUSWRITER_VERSION=4.0.16 docker compose build
docker compose up -d
# ... test ...
docker compose down

# Test with latest version
FIDUSWRITER_VERSION=4.0.17 docker compose build
docker compose up -d
# ... test ...
docker compose down
```

## Submitting Changes

### Before Submitting

1. **Run all tests and linters**:
   ```bash
   make lint
   make test
   ```

2. **Test your changes locally**:
   ```bash
   make clean
   make build
   make up
   # Verify everything works
   ```

3. **Update documentation** if needed:
   - Update `README.md` for user-facing changes
   - Update `CONTRIBUTING.md` for development process changes
   - Add comments to complex code

4. **Commit your changes** with clear messages

5. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

### Create a Pull Request

1. Go to your fork on GitHub
2. Click "New Pull Request"
3. Select your feature branch
4. Fill in the PR template with:
   - **Title**: Brief description following conventional commits format
   - **Description**: Detailed explanation of changes
   - **Motivation**: Why is this change needed?
   - **Testing**: How did you test this?
   - **Screenshots**: If applicable
   - **Breaking Changes**: List any breaking changes
   - **Related Issues**: Reference any related issues

### PR Template Example

```markdown
## Description
Brief description of what this PR does.

## Motivation
Why is this change necessary? What problem does it solve?

## Changes
- List of changes made
- Another change
- Yet another change

## Testing
- [ ] Tested locally with `make test`
- [ ] All linters pass with `make lint`
- [ ] Built and run Docker image successfully
- [ ] Verified application starts correctly
- [ ] Tested with Fiduswriter version X.Y.Z

## Screenshots (if applicable)
Add screenshots here.

## Breaking Changes
List any breaking changes and migration steps.

## Related Issues
Closes #123
Related to #456
```

### After Submitting

- Be responsive to feedback
- Make requested changes in new commits
- Push updates to the same branch
- Squash commits if requested
- Wait for CI checks to pass

## Style Guidelines

### Dockerfile

- Follow [Docker best practices](https://docs.docker.com/develop/dev-best-practices/)
- Use multi-line commands for readability
- Combine `RUN` commands to reduce layers when appropriate
- Clean up package manager caches
- Add comments for complex operations
- Use hadolint to check for issues

Example:
```dockerfile
# Install Python dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        python3.14 \
        python3.14-venv \
        python3.14-dev \
    && rm -rf /var/lib/apt/lists/*
```

### Shell Scripts

- Use `#!/bin/sh -e` for POSIX compliance
- Quote variables: `"$VARIABLE"`
- Use `set -e` for error handling
- Add comments for clarity
- Use shellcheck to verify

Example:
```bash
#!/bin/sh -e

# Activate virtual environment
export PATH="/fiduswriter/venv/bin:$PATH"

if [ -f /data/configuration.py ]; then
    echo "Using existing configuration"
else
    echo "Creating default configuration"
    fiduswriter startproject
fi
```

### YAML Files

- Use 2 spaces for indentation
- Quote strings when necessary
- Add comments for complex configurations
- Validate with `yamllint` or docker compose config

### Markdown

- Use ATX-style headers (`#` not `===`)
- Use `-` for unordered lists
- Add blank lines between sections
- Keep lines under 120 characters when possible
- Use code blocks with language specifiers
- Validate with markdownlint

### Python (for scripts)

- Follow PEP 8
- Use type hints when possible
- Add docstrings for functions
- Keep functions small and focused

## Reporting Issues

### Before Reporting

1. Check if the issue already exists
2. Test with the latest version
3. Gather relevant information:
   - Docker version
   - Operating system
   - Fiduswriter version
   - Steps to reproduce
   - Expected vs actual behavior
   - Error messages and logs

### Issue Template

```markdown
**Describe the bug**
A clear description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Run command '...'
2. Open browser to '...'
3. See error

**Expected behavior**
What you expected to happen.

**Actual behavior**
What actually happened.

**Environment:**
- OS: [e.g., Ubuntu 22.04]
- Docker version: [e.g., 24.0.0]
- Fiduswriter version: [e.g., 4.0.17]

**Logs**
```
Paste relevant logs here
```

**Additional context**
Any other relevant information.
```

## Feature Requests

We welcome feature requests! Please provide:

1. **Use case**: Why is this feature needed?
2. **Proposed solution**: How should it work?
3. **Alternatives**: What alternatives have you considered?
4. **Additional context**: Screenshots, examples, etc.

## Questions?

- **GitHub Discussions**: For questions and discussions
- **GitHub Issues**: For bug reports and feature requests
- **Fiduswriter Help**: For application-specific questions

## Recognition

Contributors will be:
- Listed in release notes
- Credited in the repository
- Appreciated by the community! 🎉

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for contributing to Fiduswriter Docker! 🚀