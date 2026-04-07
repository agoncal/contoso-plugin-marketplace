---
name: contoso-secret-scanning-scan-secrets
description: Scan code for leaked secrets, API keys, and credentials with remediation guidance
---

## Secret Scanning Skill

This skill scans codebases and diffs for accidentally committed secrets, credentials, API keys, and sensitive data. Use this skill when asked to check for secrets, audit security, or validate that no credentials are exposed in code.

## Secret Detection Patterns

### Credential Patterns

| Category | Pattern | Example |
|----------|---------|---------|
| AWS Access Key | `AKIA[0-9A-Z]{16}` | `AKIAIOSFODNN7EXAMPLE` |
| AWS Secret Key | `[0-9a-zA-Z/+=]{40}` near `aws_secret` | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` |
| GitHub PAT | `ghp_[a-zA-Z0-9]{36}` | `ghp_aBcDeFgHiJkLmNoPqRsTuVwXyZ012345` |
| GitHub Fine-grained | `github_pat_[a-zA-Z0-9]{22}_[a-zA-Z0-9]{59}` | `github_pat_...` |
| Azure Storage Key | Base64 near `AccountKey=` | `AccountKey=abc123def456...==` |
| Generic API Key | `api[_-]?key.*[:=].*[a-zA-Z0-9]{20,}` | `api_key = "sk-abc123..."` |
| Private Key | `-----BEGIN.*PRIVATE KEY-----` | PEM-encoded private key |
| JWT Token | `eyJ[A-Za-z0-9_-]+\.eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+` | `eyJhbGciOi...` |
| Database URI | `(mongo|postgres|mysql)://[^:]+:[^@]+@` | `postgres://user:pass@host` |
| Password in Config | `password\s*[:=]\s*["'][^"']+["']` | `password: "s3cret"` |
| Bearer Token | `Bearer\s+[a-zA-Z0-9\-._~+/]+=*` | `Bearer eyJ...` |
| Slack Webhook | `https://hooks.slack.com/services/T[A-Z0-9]+/B[A-Z0-9]+/[a-zA-Z0-9]+` | Slack webhook URL |
| SendGrid Key | `SG\.[a-zA-Z0-9_-]{22}\.[a-zA-Z0-9_-]{43}` | `SG.xxx...` |
| Stripe Key | `sk_live_[a-zA-Z0-9]{24,}` | `sk_live_abc123...` |

## Scanning Procedure

### Step 1: Determine Scan Scope
- **Full repository scan**: Check all tracked files for secrets
- **Staged changes scan**: Check only `git diff --cached` for new secrets about to be committed
- **Branch diff scan**: Check changes between branches for secrets introduced in a feature branch

### Step 2: Execute Pattern Matching
```bash
# Scan all source files for secret patterns
grep -rn --include="*.{js,ts,py,java,go,rb,php,yml,yaml,json,xml,env,cfg,conf,ini,toml,properties}" \
  -E "(AKIA[0-9A-Z]{16}|ghp_[a-zA-Z0-9]{36}|password\s*[:=]\s*[\"'][^\"']+[\"']|-----BEGIN.*PRIVATE KEY-----)" .

# Check for .env files not in .gitignore
find . -name ".env*" -not -path "./.git/*" -not -path "*/node_modules/*"

# Verify .gitignore coverage
for pattern in ".env" ".env.local" "*.pem" "*.key" "*.p12"; do
  grep -q "$pattern" .gitignore 2>/dev/null && echo "✅ $pattern in .gitignore" || echo "❌ $pattern NOT in .gitignore"
done
```

### Step 3: Filter False Positives
Exclude matches that are clearly not real secrets:
- Example/placeholder values: `YOUR_API_KEY_HERE`, `xxx`, `changeme`, `password123`
- Test fixtures with obviously fake data
- Documentation and comments explaining secret formats
- Environment variable references (e.g., `os.environ["KEY"]`, `process.env.KEY`)
- Secret manager references (e.g., `@Microsoft.KeyVault(...)`)

### Step 4: Report Findings
Classify each finding by severity and provide specific remediation:

```
## Secret Scan Report

**Scope:** [repo/staged/branch]
**Files Scanned:** [count]
**Secrets Found:** [count]
**False Positives Filtered:** [count]

### Critical Findings
1. **[SECRET_TYPE]** in `[file]:[line]`
   - Pattern: `[matched pattern]`
   - Remediation: [specific steps to fix]
   - Priority: Rotate credential immediately

### Recommendations
- Add pre-commit hook for secret scanning
- Configure GitHub secret scanning alerts
- Add missing patterns to .gitignore
```

## Remediation Strategies

### Environment Variables
Replace hardcoded secrets with environment variable references:
```javascript
// ❌ Bad: Hardcoded secret
const apiKey = "sk-abc123def456";

// ✅ Good: Environment variable
const apiKey = process.env.API_KEY;
```

### Secret Managers
For production deployments, use managed secret stores:
- **Azure Key Vault**: `@Microsoft.KeyVault(SecretUri=https://vault.vault.azure.net/secrets/key)`
- **AWS Secrets Manager**: `aws secretsmanager get-secret-value --secret-id mySecret`
- **HashiCorp Vault**: `vault kv get secret/myapp/config`

### .gitignore Essentials
Every Contoso repository MUST have these patterns in `.gitignore`:
```
.env
.env.*
*.pem
*.key
*.p12
*.pfx
**/secrets/
credentials.json
service-account.json
```

## Prevention: Pre-Commit Hook
Recommend installing a pre-commit hook to catch secrets before they reach the repository:
```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.0
    hooks:
      - id: gitleaks
```
