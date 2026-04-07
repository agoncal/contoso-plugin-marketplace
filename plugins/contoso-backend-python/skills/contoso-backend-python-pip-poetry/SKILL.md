---
name: contoso-backend-python-pip-poetry
description: Python dependency management with Poetry — pyproject.toml configuration, virtual environments, dependency groups, and package publishing
---

## Contoso Python Dependency Management Skill

This skill provides guidance for managing Python project dependencies using Poetry following Contoso's standards. Use this skill when setting up new projects, managing dependencies, configuring virtual environments, or publishing packages.

## Why Poetry (Not pip)

Contoso uses Poetry as the standard dependency manager because it provides:
- Deterministic builds via `poetry.lock`
- Dependency resolution that detects conflicts before installation
- Virtual environment management built in
- Separation of dev/test/prod dependency groups
- `pyproject.toml` as the single source of truth (PEP 621 compatible)

**Rule:** Never use `pip install` for project dependencies. Use `poetry add` instead.

## pyproject.toml Configuration

A complete Contoso-standard `pyproject.toml`:

```toml
[tool.poetry]
name = "contoso-order-service"
version = "1.0.0"
description = "Order management microservice for the Contoso platform"
authors = ["Contoso Engineering <engineering@contoso.com>"]
license = "MIT"
readme = "README.md"
packages = [{include = "app", from = "src"}]

[tool.poetry.dependencies]
python = "^3.12"
fastapi = "^0.111.0"
uvicorn = {extras = ["standard"], version = "^0.30.0"}
pydantic = "^2.7.0"
pydantic-settings = "^2.3.0"
sqlalchemy = {extras = ["asyncio"], version = "^2.0.30"}
alembic = "^1.13.0"
httpx = "^0.27.0"
structlog = "^24.2.0"

[tool.poetry.group.dev.dependencies]
pytest = "^8.2.0"
pytest-asyncio = "^0.23.0"
pytest-cov = "^5.0.0"
ruff = "^0.4.0"
mypy = "^1.10.0"
pre-commit = "^3.7.0"

[tool.poetry.group.test.dependencies]
factory-boy = "^3.3.0"
faker = "^25.0.0"
testcontainers = "^4.5.0"

[tool.poetry.scripts]
serve = "app.main:start"

[build-system]
requires = ["poetry-core"]
build-backend = "poetry.core.masonry.api"
```

## Dependency Groups

Contoso organizes dependencies into these groups:

- **Main dependencies** (`[tool.poetry.dependencies]`) — production runtime requirements.
- **Dev dependencies** (`[tool.poetry.group.dev.dependencies]`) — development tools (linters, formatters, type checkers).
- **Test dependencies** (`[tool.poetry.group.test.dependencies]`) — testing frameworks and fixtures.
- **Docs dependencies** (`[tool.poetry.group.docs.dependencies]`) — documentation generators (optional).

Install only production dependencies in Docker:
```bash
poetry install --only main --no-interaction
```

Install everything for development:
```bash
poetry install --no-interaction
```

## Essential Poetry Commands

```bash
# Create a new project
poetry new contoso-service --src

# Initialize in existing directory
poetry init

# Add a production dependency
poetry add fastapi

# Add a dev dependency
poetry add --group dev pytest ruff mypy

# Add with extras
poetry add sqlalchemy[asyncio]

# Remove a dependency
poetry remove unused-package

# Update dependencies (respecting version constraints)
poetry update

# Update a specific package
poetry update fastapi

# Show installed packages
poetry show

# Show dependency tree
poetry show --tree

# Export to requirements.txt (for Docker builds without Poetry)
poetry export -f requirements.txt --output requirements.txt --without-hashes

# Run a command in the virtual environment
poetry run pytest

# Activate the virtual environment shell
poetry shell

# Check for dependency conflicts
poetry check

# Lock dependencies without installing
poetry lock --no-update
```

## Virtual Environment Setup

Poetry manages virtual environments automatically. Configure it for Contoso's standard:

```bash
# Create .venv in the project directory (Contoso standard)
poetry config virtualenvs.in-project true

# Use Python 3.12
poetry env use python3.12

# Show environment info
poetry env info
```

The `.venv` directory should be added to `.gitignore`.

## Version Constraints

Follow these version constraint conventions:

| Constraint | Meaning | Use When |
|---|---|---|
| `^2.7.0` | `>=2.7.0, <3.0.0` | Default — allows minor and patch updates |
| `~2.7.0` | `>=2.7.0, <2.8.0` | Only allow patch updates |
| `>=2.7.0,<2.9.0` | Explicit range | Specific compatibility window |
| `2.7.0` | Exact version | Pinned for critical dependencies |

Rules:
- Use `^` (caret) by default for most dependencies.
- Use exact pinning for dependencies with known breaking changes in minor versions.
- Always commit `poetry.lock` to version control for applications.
- Do NOT commit `poetry.lock` for libraries (let consumers resolve versions).

## Docker Integration

For production Docker images, export to requirements.txt to avoid installing Poetry in the container:

```dockerfile
FROM python:3.12-slim AS builder
WORKDIR /app
COPY pyproject.toml poetry.lock ./
RUN pip install poetry && \
    poetry export -f requirements.txt --output requirements.txt --without-hashes

FROM python:3.12-slim
WORKDIR /app
COPY --from=builder /app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY src/ ./src/
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

## Ruff Configuration in pyproject.toml

Include Ruff configuration alongside Poetry in the same `pyproject.toml`:

```toml
[tool.ruff]
target-version = "py312"
line-length = 120
src = ["src"]

[tool.ruff.lint]
select = ["E", "F", "W", "I", "N", "UP", "S", "B", "A", "C4", "SIM", "TCH", "RUF"]
ignore = ["S101"]

[tool.ruff.lint.isort]
known-first-party = ["app"]

[tool.ruff.format]
quote-style = "double"
indent-style = "space"
```

## Mypy Configuration

```toml
[tool.mypy]
python_version = "3.12"
strict = true
warn_return_any = true
warn_unused_configs = true
plugins = ["pydantic.mypy"]

[[tool.mypy.overrides]]
module = "tests.*"
disallow_untyped_defs = false
```
