# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

No unreleased changes.

## [4.0.17] - 2025-12-18

### Added
- Pre-commit configuration for code quality checks
- GitHub Actions CI/CD pipeline for automated testing and building
- Automated version checking workflow to detect new Fiduswriter releases
- Makefile with common development commands
- Helper scripts (check-version.py, setup.sh)
- Comprehensive documentation

### Changed
- Updated to Python 3.14.2 from deadsnakes PPA
- Improved Dockerfile with build arguments support
- Enhanced docker-compose.yml with version configuration

### Removed
- IDE-specific files (.idea, .ropeproject)

## [4.0.16] - Previous Release

Initial Docker setup for Fiduswriter with Ubuntu 24.04 base image.

[Unreleased]: https://github.com/fiduswriter/fiduswriter-docker/compare/v4.0.17...HEAD
[4.0.17]: https://github.com/fiduswriter/fiduswriter-docker/releases/tag/v4.0.17
[4.0.16]: https://github.com/fiduswriter/fiduswriter-docker/releases/tag/v4.0.16