---
name: contoso-git-workflow-branching
description: Contoso Git branching strategy rules and workflow guidance
---

## Branching Strategy Skill

This skill provides guidance on Contoso's Git branching strategy, helping engineers create, manage, and merge branches correctly. Use this skill when asked about branch naming, merge strategy, or Git workflow questions.

## Branch Naming Convention

All branches MUST follow the pattern: `<type>/<ticket-id>-<short-description>`

### Valid Branch Types

| Type | Base Branch | Merges Into | Purpose |
|------|------------|-------------|---------|
| `feature` | `develop` | `develop` | New features and enhancements |
| `bugfix` | `develop` | `develop` | Non-urgent bug fixes |
| `hotfix` | `main` | `main` + `develop` | Urgent production fixes |
| `release` | `develop` | `main` + `develop` | Release preparation and stabilization |

### Naming Rules
- Use lowercase letters, numbers, and hyphens only
- Always include the ticket ID (e.g., `CONT-1234`)
- Keep the description to 3-5 words maximum
- Use hyphens to separate words in the description

### Valid Examples
```
feature/CONT-1234-user-authentication
bugfix/CONT-5678-fix-login-redirect
hotfix/CONT-9012-patch-sql-injection
release/2.4.0
```

### Invalid Examples
```
feature/my-new-feature          # Missing ticket ID
CONT-1234-user-auth             # Missing branch type
feature/CONT-1234_user_auth     # Underscores not allowed
Feature/CONT-1234-user-auth     # Uppercase type not allowed
```

## Branch Workflow

### Feature Development
```
1. git checkout develop
2. git pull origin develop
3. git checkout -b feature/CONT-XXXX-description
4. # ... make changes, commit following Conventional Commits ...
5. git rebase develop              # Keep branch up to date
6. git push origin feature/CONT-XXXX-description
7. # Create PR targeting develop
8. # After approval: merge with --no-ff
9. git branch -d feature/CONT-XXXX-description
```

### Hotfix Workflow
```
1. git checkout main
2. git pull origin main
3. git checkout -b hotfix/CONT-XXXX-description
4. # ... make the fix ...
5. git push origin hotfix/CONT-XXXX-description
6. # Create PR targeting main
7. # After merge to main: also merge main into develop
8. git checkout develop && git merge main
```

### Release Workflow
```
1. git checkout develop
2. git checkout -b release/X.Y.Z
3. # Update version numbers, changelog, final fixes
4. # Create PR targeting main
5. # After merge: tag main with vX.Y.Z
6. # Merge main back into develop
7. git branch -d release/X.Y.Z
```

## Merge Strategy

- **Feature → Develop**: Use `--no-ff` merge to preserve branch history
- **Release → Main**: Use `--no-ff` merge with version tag
- **Hotfix → Main**: Use `--no-ff` merge with patch version tag
- **Main → Develop**: Fast-forward merge to sync release/hotfix changes

## Branch Protection Rules

### `main` Branch
- Require pull request reviews (minimum 1 approver, 2 for core services)
- Require status checks to pass (CI, tests, security scan)
- Require branches to be up to date before merging
- Do not allow force pushes
- Do not allow deletions

### `develop` Branch
- Require pull request reviews (minimum 1 approver)
- Require status checks to pass (CI, tests)
- Do not allow force pushes

## Common Scenarios

### Resolving Merge Conflicts
1. Rebase your branch on the target: `git rebase develop`
2. Resolve conflicts file by file
3. Continue rebase: `git rebase --continue`
4. Force push your branch: `git push --force-with-lease`

### Recovering from Accidental Commit to Main
1. Note the commit hash: `git log -1`
2. Move the commit to a new branch: `git branch feature/CONT-XXXX-description`
3. Reset main: `git reset --hard HEAD~1`
4. Push the fix: `git push --force-with-lease origin main`
5. Switch to the feature branch and create a PR
