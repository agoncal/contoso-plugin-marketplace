# contoso-secret-scanning

Detect and prevent secrets, API keys, passwords, and credentials from being committed to repositories.

## Components

| Type | Name | Description |
|------|------|-------------|
| Agent | `contoso-secret-scanning` | Secret detection agent for preventing credential leaks |
| Skill | `contoso-secret-scanning-scan-secrets` | Scan files and diffs for secrets |
| Hook | PreToolCall on `bash` | Scans staged changes for secrets before git commit/push |

## Installation

```shell
copilot plugin install contoso-secret-scanning@contoso-marketplace
```

## What It Does

The **contoso-secret-scanning** agent detects secrets before they reach your repository:

- **High-confidence patterns**: AWS keys (`AKIA...`), GitHub tokens (`ghp_...`), JWTs, private keys, database URIs
- **Context-aware detection**: High-entropy strings near keywords like `password`, `token`, `secret`
- **File prioritization**: `.env` files, configs, Docker files, CI/CD workflows
- **Remediation guidance**: Suggests environment variables, Key Vault, or CI/CD secret variables
- **Safe output**: Masks detected secrets in responses (shows only first/last 4 characters)
