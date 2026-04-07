# contoso-code-quality

Code quality enforcement with auto-fix for linting issues, formatting standards, and complexity checks.

## Components

| Type | Name | Description |
|------|------|-------------|
| Agent | `quality-enforcer` | Code quality enforcer for formatting and complexity |
| Skill | `lint-fix` | Auto-fix linting issues |
| Hook | PreToolCall on `edit` | Checks formatting compliance before applying edits |

## Installation

```shell
copilot plugin install contoso-code-quality@contoso-marketplace
```

## What It Does

The **quality-enforcer** agent ensures code meets Contoso's quality standards:

- **Cyclomatic complexity**: Max 10 per function
- **Cognitive complexity**: Max 15 per function
- **File length**: Max 300 lines (excluding comments and blanks)
- **Function parameters**: Max 4 (use options objects for more)
- **No duplication**: No duplicated logic blocks longer than 5 lines
- **Naming conventions**: Language-appropriate casing, verb-first functions, boolean `is/has/can` prefixes
- **Linter integration**: ESLint, Ruff, Checkstyle, Roslyn analyzers
