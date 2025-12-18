---
name: Bug Report
about: Report a bug or issue with the Fiduswriter Docker setup
title: '[BUG] '
labels: bug
assignees: ''
---

## Bug Description

A clear and concise description of what the bug is.

## Environment

- **OS**: [e.g., Ubuntu 22.04, macOS 13.0, Windows 11]
- **Docker Version**: [e.g., 24.0.0]
- **Docker Compose Version**: [e.g., 2.20.0]
- **Fiduswriter Version**: [e.g., 4.0.17]
- **Image Tag**: [e.g., latest, 4.0.17, 4.0, 4]

## Steps to Reproduce

Steps to reproduce the behavior:

1. Run command '...'
2. Navigate to '...'
3. Click on '...'
4. See error

## Expected Behavior

A clear and concise description of what you expected to happen.

## Actual Behavior

A clear and concise description of what actually happened.

## Logs

Please provide relevant logs:

```bash
# Docker logs
docker compose logs

# Or for specific container
docker logs fiduswriter
```

<details>
<summary>Paste logs here</summary>

```
[Paste your logs here]
```

</details>

## Configuration

If relevant, share your configuration (remove sensitive information):

<details>
<summary>docker-compose.yml</summary>

```yaml
[Paste your docker-compose.yml here]
```

</details>

<details>
<summary>.env file (if used)</summary>

```
[Paste relevant .env variables here, REMOVE SECRETS]
```

</details>

<details>
<summary>configuration.py (if modified)</summary>

```python
[Paste relevant parts of configuration.py, REMOVE SECRETS]
```

</details>

## Screenshots

If applicable, add screenshots to help explain your problem.

## Additional Context

Add any other context about the problem here:
- Did this work in a previous version?
- Are you using any custom configuration?
- Are you behind a proxy or using special networking setup?
- Any relevant host system configuration?

## Possible Solution

If you have an idea of what might be causing the issue or how to fix it, please share.

## Checklist

- [ ] I have checked existing issues to ensure this is not a duplicate
- [ ] I have tested with the latest version
- [ ] I have included all relevant information above
- [ ] I have removed any sensitive information from logs and configuration