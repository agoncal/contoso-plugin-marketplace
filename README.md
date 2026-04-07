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

| Plugin                      | Description                                                                                                  |
|-----------------------------|--------------------------------------------------------------------------------------------------------------|
| **contoso-code-review**     | Automated code review with Contoso coding standards enforcement, PR analysis, and improvement suggestions    |
| **contoso-documentation**   | Generate and maintain API docs, READMEs, and ADRs following Contoso documentation standards                  |
| **contoso-git-workflow**    | Enforce Contoso Git branching strategy, commit message conventions, and PR workflow automation               |
| **contoso-code-quality**    | Code quality enforcement with auto-fix for linting issues, formatting standards, and complexity checks       |
| **contoso-secret-scanning** | Detect and prevent secrets, API keys, passwords, and credentials from being committed                        |
| **contoso-ci-cd**           | Generate, validate, and optimize CI/CD pipeline configurations for GitHub Actions, Azure DevOps, and Jenkins |
| **contoso-testing**         | Generate unit, integration, and E2E tests with coverage tracking and test strategy guidance                  |

### Frontend

| Plugin                       | Description                                                                                           |
|------------------------------|-------------------------------------------------------------------------------------------------------|
| **contoso-frontend**         | General frontend expertise — UI component scaffolding, accessibility (WCAG 2.1 AA), responsive design |
| **contoso-frontend-react**   | React-specific — component patterns, hooks, state management, Contoso React style guide               |
| **contoso-frontend-angular** | Angular-specific — standalone components, signals, RxJS patterns, Contoso Angular style guide         |

### Backend

| Plugin                         | Description                                                                                             |
|--------------------------------|---------------------------------------------------------------------------------------------------------|
| **contoso-backend**            | General backend/API expertise — REST/GraphQL API design, microservice patterns, Contoso API conventions |
| **contoso-backend-java**       | Java/Spring Boot — Maven/Gradle management, Spring patterns, Contoso Java standards                     |
| **contoso-backend-dotnet**     | .NET/C# — NuGet/MSBuild management, Clean Architecture, Contoso .NET conventions                        |
| **contoso-backend-python**     | Python — Poetry management, FastAPI/Django patterns, Contoso PEP standards                              |
| **contoso-backend-typescript** | TypeScript/Node.js — NestJS/Express patterns, strict typing, Contoso TypeScript standards               |

### Infrastructure, Security & Mobile

| Plugin                     | Description                                                                                    |
|----------------------------|------------------------------------------------------------------------------------------------|
| **contoso-infrastructure** | Infrastructure-as-Code — Terraform, Bicep generation with Contoso IaC best practices           |
| **contoso-security**       | Application security — OWASP-based vulnerability scanning, dependency audits, security reviews |
| **contoso-mobile**         | Mobile development — React Native/Flutter patterns, performance optimization, accessibility    |

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