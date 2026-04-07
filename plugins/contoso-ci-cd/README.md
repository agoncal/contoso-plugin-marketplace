# contoso-ci-cd

Generate, validate, and optimize CI/CD pipeline configurations for GitHub Actions, Azure DevOps, and Jenkins.

## Components

| Type | Name | Description |
|------|------|-------------|
| Agent | `contoso-ci-cd` | CI/CD pipeline generator and optimizer |
| Skill | `contoso-ci-cd-pipeline` | Generate and validate CI/CD configurations |
| Hook | PostToolCall on `create` | Validates pipeline YAML syntax after creation |

## Installation

```shell
copilot plugin install contoso-ci-cd@contoso-marketplace
```

## What It Does

The **contoso-ci-cd** agent generates and optimizes CI/CD pipelines:

- **GitHub Actions** (primary), Azure DevOps, and Jenkins support
- **Standard workflows**: CI (lint, test, coverage), CD (build, deploy staging/prod), Security (dependency scan, SAST)
- **Best practices**: Pinned action versions, dependency caching, concurrency groups, timeouts
- **Quality gates**: ≥80% coverage, zero critical vulnerabilities, lint passing, build under 15 minutes
- **Deployment**: Staging → smoke tests → production with manual approval gates
