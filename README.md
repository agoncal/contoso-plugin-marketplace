# Contoso Plugin Marketplace

A curated collection of GitHub Copilot CLI plugins for Contoso Engineering. These plugins provide AI-powered agents,
skills, and hooks that enforce Contoso's coding standards, automate workflows, and provide domain expertise across all
technology stacks.

## Quick Start

### Add the marketplace

```shell
copilot plugin marketplace add AGoncal/contoso-plugin-marketplace
```

### Browse available plugins

```shell
copilot plugin marketplace browse contoso-marketplace
```

### Install a plugin

```shell
copilot plugin install contoso-code-review@contoso-marketplace
```

## Plugins

### General Purpose (all projects)

| Plugin | Description | Details |
|--------|-------------|---------|
| **contoso-code-review** | Automated code review with Contoso coding standards enforcement, PR analysis, and improvement suggestions | [README](plugins/contoso-code-review/README.md) |
| **contoso-documentation** | Generate and maintain API docs, READMEs, and ADRs following Contoso documentation standards | [README](plugins/contoso-documentation/README.md) |
| **contoso-git-workflow** | Enforce Contoso Git branching strategy, commit message conventions, and PR workflow automation | [README](plugins/contoso-git-workflow/README.md) |
| **contoso-code-quality** | Code quality enforcement with auto-fix for linting issues, formatting standards, and complexity checks | [README](plugins/contoso-code-quality/README.md) |
| **contoso-secret-scanning** | Detect and prevent secrets, API keys, passwords, and credentials from being committed | [README](plugins/contoso-secret-scanning/README.md) |
| **contoso-ci-cd** | Generate, validate, and optimize CI/CD pipeline configurations for GitHub Actions, Azure DevOps, and Jenkins | [README](plugins/contoso-ci-cd/README.md) |
| **contoso-testing** | Generate unit, integration, and E2E tests with coverage tracking and test strategy guidance | [README](plugins/contoso-testing/README.md) |

### Frontend

| Plugin | Description | Details |
|--------|-------------|---------|
| **contoso-frontend** | General frontend expertise — UI component scaffolding, accessibility (WCAG 2.1 AA), responsive design | [README](plugins/contoso-frontend/README.md) |
| **contoso-frontend-react** | React-specific — component patterns, hooks, state management, Contoso React style guide | [README](plugins/contoso-frontend-react/README.md) |
| **contoso-frontend-angular** | Angular-specific — standalone components, signals, RxJS patterns, Contoso Angular style guide | [README](plugins/contoso-frontend-angular/README.md) |

### Backend

| Plugin | Description | Details |
|--------|-------------|---------|
| **contoso-backend** | General backend/API expertise — REST/GraphQL API design, microservice patterns, Contoso API conventions | [README](plugins/contoso-backend/README.md) |
| **contoso-backend-java** | Java/Spring Boot — Maven/Gradle management, Spring patterns, Contoso Java standards | [README](plugins/contoso-backend-java/README.md) |
| **contoso-backend-dotnet** | .NET/C# — NuGet/MSBuild management, Clean Architecture, Contoso .NET conventions | [README](plugins/contoso-backend-dotnet/README.md) |
| **contoso-backend-python** | Python — Poetry management, FastAPI/Django patterns, Contoso PEP standards | [README](plugins/contoso-backend-python/README.md) |
| **contoso-backend-typescript** | TypeScript/Node.js — NestJS/Express patterns, strict typing, Contoso TypeScript standards | [README](plugins/contoso-backend-typescript/README.md) |

### Infrastructure, Security & Mobile

| Plugin | Description | Details |
|--------|-------------|---------|
| **contoso-infrastructure** | Infrastructure-as-Code — Terraform, Bicep generation with Contoso IaC best practices | [README](plugins/contoso-infrastructure/README.md) |
| **contoso-security** | Application security — OWASP-based vulnerability scanning, dependency audits, security reviews | [README](plugins/contoso-security/README.md) |
| **contoso-mobile** | Mobile development — React Native/Flutter patterns, performance optimization, accessibility | [README](plugins/contoso-mobile/README.md) |

## Plugin Structure

Each plugin contains:

```
contoso-<name>/
├── plugin.json           # Plugin manifest
├── agents/
│   └── <name>.agent.md   # AI agent with system prompt
├── skills/
│   └── <skill-name>/
│       └── SKILL.md      # Callable skill with instructions
└── hooks.json            # Event hooks (PreToolCall/PostToolCall)
```

## Naming Convention

Plugins follow a flat hierarchy with naming-based structure:

- `contoso-{domain}` — General domain plugin (e.g., `contoso-frontend`, `contoso-backend`)
- `contoso-{domain}-{tech}` — Technology-specific variant (e.g., `contoso-frontend-react`, `contoso-backend-java`)

## Managing Plugins

### Marketplace

```shell
/plugin marketplace list                          # List registered marketplaces
/plugin marketplace add agoncal/contoso-plugin-marketplace  # Add this marketplace
/plugin marketplace browse contoso-marketplace     # Browse available plugins
```

### Installing Plugins

```shell
/plugin list                         # View installed plugins
/plugin install contoso-backend@contoso-marketplace
/plugin install contoso-backend-java@contoso-marketplace
/plugin install contoso-ci-cd@contoso-marketplace
/plugin list
```

### Updating and Uninstalling Plugins

```shell
/plugin update contoso-backend-java   # Update a plugin
/plugin uninstall contoso-backend-java # Remove a plugin
```

## License

[MIT](LICENSE)