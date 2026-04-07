# contoso-git-workflow

Enforce Contoso Git branching strategy, commit message conventions, and PR workflow automation.

## Components

| Type | Name | Description |
|------|------|-------------|
| Agent | `git-assistant` | Git workflow assistant enforcing Contoso conventions |
| Skill | `branching` | Contoso branching strategy enforcement |
| Hook | PreToolCall on `bash` | Enforces Conventional Commits format on git commit commands |

## Installation

```shell
copilot plugin install contoso-git-workflow@contoso-marketplace
```

## What It Does

The **git-assistant** agent enforces the Contoso Git workflow:

- **Branching strategy**: `main`, `develop`, `feature/*`, `bugfix/*`, `hotfix/*`, `release/*`
- **Branch naming**: `{type}/{ticket-id}-{short-description}` (e.g., `feature/CONT-1234-user-auth`)
- **Commit messages**: Conventional Commits format — `<type>(<scope>): <description>`
- **Types**: feat, fix, docs, style, refactor, test, chore, ci
- **PR guidelines**: Focused PRs under 400 lines, 2 reviewers, linked tickets
