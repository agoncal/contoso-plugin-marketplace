# contoso-infrastructure

Infrastructure-as-Code expertise — Terraform, Bicep, and CloudFormation generation with Contoso IaC best practices.

## Components

| Type | Name | Description |
|------|------|-------------|
| Agent | `infra-expert` | Infrastructure-as-Code expert |
| Skill | `iac` | Generate Terraform/Bicep configurations |
| Hook | PreToolCall on `create` | Enforces resource tagging and naming in `.tf`/`.bicep` files |

## Installation

```shell
copilot plugin install contoso-infrastructure@contoso-marketplace
```

## What It Does

The **infra-expert** agent enforces Contoso's IaC standards:

- **Tools**: Terraform (multi-cloud/AWS), Bicep (Azure-only)
- **Naming**: `{company}-{environment}-{region}-{resource-type}-{name}` (e.g., `contoso-prod-eastus-rg-api`)
- **Required tags**: environment, team, cost-center, managed-by, project, created-date
- **State**: Remote state with locking (Azure Storage or Terraform Cloud)
- **Structure**: `modules/` (reusable), `environments/` (dev/staging/prod), `shared/`
- **Security**: No hardcoded secrets, least-privilege IAM, private endpoints, encryption at rest/in transit
- **Lifecycle**: `prevent_destroy` for databases, `ignore_changes` for auto-scaled resources
