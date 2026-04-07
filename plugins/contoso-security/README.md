# contoso-security

Application security — OWASP-based vulnerability scanning, dependency audits, and security review workflows.

## Components

| Type | Name | Description |
|------|------|-------------|
| Agent | `contoso-security` | Application security expert with OWASP focus |
| Skill | `contoso-security-vulnerability-scan` | OWASP-based vulnerability scanning |
| Hook | PreToolCall on `bash` | Enforces security review before deploy/publish commands |

## Installation

```shell
copilot plugin install contoso-security@contoso-marketplace
```

## What It Does

The **contoso-security** agent performs security assessments based on OWASP Top 10:

- **Access control**: Authorization checks, IDOR prevention, CORS validation
- **Cryptography**: No MD5/SHA1, minimum AES-256, TLS 1.2+
- **Injection**: Parameterized queries, input validation, output encoding
- **Authentication**: bcrypt/argon2 hashing, MFA, JWT expiration (15min access, 7d refresh)
- **Dependencies**: Automated audits (`npm audit`, `pip audit`, `dotnet list --vulnerable`)
- **Security headers**: CSP, X-Frame-Options, HSTS, Referrer-Policy, Permissions-Policy
- **Logging**: Auth events, authorization failures, no PII in logs
- **Review process**: Code analysis → dependency audit → config review → data handling → report
