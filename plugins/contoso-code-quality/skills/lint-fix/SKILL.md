---
name: lint-fix
description: Detect and auto-fix linting issues across multiple languages and frameworks
---

## Lint Fix Skill

This skill detects and fixes linting, formatting, and code style issues across Contoso projects. Use this skill when asked to lint, format, or fix code quality issues in a project.

## Supported Languages and Tools

| Language | Linter | Formatter | Config File |
|----------|--------|-----------|-------------|
| JavaScript/TypeScript | ESLint | Prettier | `.eslintrc.*`, `.prettierrc` |
| Python | Ruff, Flake8, Pylint | Black, Ruff | `pyproject.toml`, `.flake8` |
| Java | Checkstyle, SpotBugs | google-java-format | `checkstyle.xml` |
| C# | dotnet-format, StyleCop | dotnet-format | `.editorconfig` |
| Go | golangci-lint | gofmt, goimports | `.golangci.yml` |
| Rust | Clippy | rustfmt | `rustfmt.toml` |
| YAML/JSON | yamllint, jsonlint | Prettier | `.yamllint` |

## Detection Process

### Step 1: Identify Project Configuration
```
1. Check for package.json (Node.js projects)
2. Check for pyproject.toml, setup.py (Python projects)
3. Check for pom.xml, build.gradle (Java projects)
4. Check for *.csproj, *.sln (C# projects)
5. Check for go.mod (Go projects)
6. Check for Cargo.toml (Rust projects)
7. Look for existing linter configuration files
```

### Step 2: Run Available Linters
Execute the appropriate linting commands based on the detected project type:

**JavaScript/TypeScript:**
```bash
npx eslint . --format json          # Lint with ESLint
npx prettier --check .              # Check formatting
```

**Python:**
```bash
ruff check .                        # Lint with Ruff
ruff format --check .               # Check formatting
```

**Java:**
```bash
mvn checkstyle:check                # Run Checkstyle
mvn spotbugs:check                  # Run SpotBugs
```

**Go:**
```bash
golangci-lint run                   # Run golangci-lint
gofmt -l .                         # Check formatting
```

### Step 3: Auto-Fix Safe Issues
Apply fixes for issues that can be safely auto-corrected:

**JavaScript/TypeScript:**
```bash
npx eslint . --fix                  # Auto-fix ESLint issues
npx prettier --write .              # Auto-format with Prettier
```

**Python:**
```bash
ruff check . --fix                  # Auto-fix Ruff issues
ruff format .                       # Auto-format with Ruff
```

**Go:**
```bash
gofmt -w .                         # Auto-format Go files
goimports -w .                     # Fix imports
```

### Step 4: Report Remaining Issues
For issues that cannot be auto-fixed, report them with:
- File path and line number
- Rule ID and description
- Severity (error, warning, info)
- Suggested manual fix

## Output Format

```
## Lint Results

**Project:** [project name]
**Language:** [detected language]
**Tool:** [linter/formatter used]

### Auto-Fixed Issues ([count])
- [file:line] [rule-id] — [description] ✅ Fixed

### Manual Fix Required ([count])
- [file:line] [rule-id] — [description]
  → Suggested fix: [how to fix]

### Summary
- Total issues found: [count]
- Auto-fixed: [count]
- Manual fix needed: [count]
- Files checked: [count]
```

## Contoso-Specific Rules

Beyond standard linter rules, enforce these Contoso-specific checks:

1. **No `console.log` in production code** — Use the project's logging framework
2. **No `any` type in TypeScript** — Use proper types or `unknown` with type guards
3. **No `TODO` without ticket reference** — Format: `// TODO(CONT-1234): description`
4. **No magic numbers** — Extract to named constants
5. **No nested ternaries** — Use if/else or early returns for readability
6. **Maximum 3 parameters per function** — Use an options object for more
7. **No default exports** in TypeScript — Use named exports for better refactoring support
