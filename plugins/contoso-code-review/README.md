# contoso-code-review

Automated code review with Contoso coding standards enforcement, PR analysis, and improvement suggestions.

## Components

| Type | Name | Description |
|------|------|-------------|
| Agent | `code-reviewer` | Senior code reviewer enforcing Contoso coding standards |
| Skill | `review` | Structured code review workflow |
| Hook | PreToolCall on `edit` | Reminds to follow Contoso coding standards before edits |

## Installation

```shell
copilot plugin install contoso-code-review@contoso-marketplace
```

## What It Does

The **code-reviewer** agent acts as a senior Contoso code reviewer. It enforces:

- **Function length**: Maximum 30 lines per function
- **Naming**: Meaningful, descriptive variable and function names
- **Error handling**: Proper try/catch with specific error types for all external calls
- **No dead code**: No commented-out code, unused imports, or unreachable paths
- **Security**: No hardcoded secrets, input validation, parameterized queries

Reviews are structured using the Contoso template:

1. **Summary** — Overall assessment
2. **Critical Issues** 🔴 — Must fix before merge
3. **Warnings** 🟡 — Should address but non-blocking
4. **Suggestions** 🟢 — Improvements for code quality
5. **Positive Highlights** ⭐ — Acknowledge good patterns
