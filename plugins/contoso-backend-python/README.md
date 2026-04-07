# contoso-backend-python

Python development — pip/Poetry management, FastAPI/Django patterns, and Contoso PEP standards enforcement.

## Components

| Type | Name | Description |
|------|------|-------------|
| Agent | `python-expert` | Python development expert with modern tooling |
| Skill | `pip-poetry` | Dependency management |
| Hook | PreToolCall on `edit` | Enforces type hints and docstrings in `.py` files |

## Installation

```shell
copilot plugin install contoso-backend-python@contoso-marketplace
```

## What It Does

The **python-expert** agent enforces Contoso's Python standards:

- **Python 3.12+**: Type hints, match statements, f-strings, `type` statement
- **Poetry** for dependency management (not pip directly)
- **Type hints required** on all function signatures — enforced with `mypy --strict`
- **Code style**: PEP 8 + max 120 chars, Google-style docstrings, Ruff for linting/formatting
- **Frameworks**: FastAPI for APIs, Django for full-stack
- **Data validation**: Pydantic v2 with strict mode
- **Project structure**: `src/app/` with api, models, services, repositories
- **Testing**: pytest + factory_boy + httpx AsyncClient, minimum 80% coverage

> **See also**: [contoso-backend](../contoso-backend/) for general API conventions.
