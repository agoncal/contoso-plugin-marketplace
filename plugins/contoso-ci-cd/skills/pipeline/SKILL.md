---
name: pipeline
description: Generate and optimize CI/CD pipelines using Contoso templates and best practices
---

## Pipeline Generation Skill

This skill generates CI/CD pipeline configurations following Contoso's templates and best practices. Use this skill when asked to create, modify, or optimize pipeline workflows for GitHub Actions, Azure DevOps, or other CI/CD platforms.

## Contoso CI Pipeline Template

### Standard Pull Request Workflow

```yaml
name: PR Validation
on:
  pull_request:
    branches: [main, develop]

permissions:
  contents: read
  checks: write
  pull-requests: write

concurrency:
  group: pr-${{ github.event.pull_request.number }}
  cancel-in-progress: true

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup runtime
        # Language-specific setup step
      - name: Cache dependencies
        # Language-specific caching
      - name: Install dependencies
        # Install command
      - name: Build
        # Build command
      - name: Upload build artifacts
        uses: actions/upload-artifact@v4
        with:
          name: build-output
          path: dist/

  test:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run tests
        # Test command with coverage
      - name: Upload coverage
        uses: actions/upload-artifact@v4
        with:
          name: coverage-report
          path: coverage/
      - name: Check coverage threshold
        # Fail if coverage < 80%

  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run linter
        # Lint command

  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Dependency audit
        # Audit command (npm audit, pip-audit, etc.)
      - name: Secret scanning
        # Secret scan command
```

### Standard Deployment Workflow

```yaml
name: Deploy
on:
  push:
    branches: [main, develop]

permissions:
  contents: read
  id-token: write

jobs:
  deploy-staging:
    if: github.ref == 'refs/heads/develop'
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - uses: actions/checkout@v4
      - name: Login to cloud provider
        # OIDC authentication
      - name: Deploy to staging
        # Deployment command
      - name: Run smoke tests
        # Validate deployment

  deploy-production:
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v4
      - name: Login to cloud provider
        # OIDC authentication
      - name: Deploy to production
        # Deployment command
      - name: Run smoke tests
        # Validate deployment
      - name: Notify team
        # Send deployment notification
```

## Best Practices Checklist

When generating or reviewing pipelines, verify:

### Structure
- [ ] Jobs are organized with clear dependency chains (`needs`)
- [ ] Independent jobs run in parallel (test, lint, security)
- [ ] `concurrency` groups prevent duplicate runs
- [ ] Path filters exclude non-relevant changes (e.g., `paths-ignore: ['docs/**', '*.md']`)

### Security
- [ ] Permissions are explicitly set with least privilege
- [ ] Action versions are pinned (SHA or major version)
- [ ] Secrets are passed via `${{ secrets.NAME }}`, never hardcoded
- [ ] OIDC is used for cloud authentication where possible
- [ ] Third-party actions are from verified publishers or reviewed

### Performance
- [ ] Dependencies are cached with appropriate cache keys
- [ ] Build artifacts are shared between jobs via `upload/download-artifact`
- [ ] Matrix builds are used for multi-version testing
- [ ] `fail-fast` is set appropriately for matrix strategies
- [ ] Timeout limits are set on all jobs (`timeout-minutes`)

### Reliability
- [ ] Retry logic exists for flaky external calls
- [ ] Smoke tests run after every deployment
- [ ] Rollback strategy is documented or automated
- [ ] Notifications are sent on failure

## Language-Specific Templates

### Node.js
```yaml
- uses: actions/setup-node@v4
  with:
    node-version: '20'
    cache: 'npm'
- run: npm ci
- run: npm run build
- run: npm test -- --coverage
```

### Python
```yaml
- uses: actions/setup-python@v5
  with:
    python-version: '3.12'
    cache: 'pip'
- run: pip install -r requirements.txt
- run: pytest --cov --cov-report=xml
```

### Java (Maven)
```yaml
- uses: actions/setup-java@v4
  with:
    distribution: 'temurin'
    java-version: '21'
    cache: 'maven'
- run: mvn verify
```

### Go
```yaml
- uses: actions/setup-go@v5
  with:
    go-version: '1.22'
- run: go build ./...
- run: go test -race -coverprofile=coverage.out ./...
```

### .NET
```yaml
- uses: actions/setup-dotnet@v4
  with:
    dotnet-version: '8.0'
- run: dotnet restore
- run: dotnet build --no-restore
- run: dotnet test --no-build --collect:"XPlat Code Coverage"
```
