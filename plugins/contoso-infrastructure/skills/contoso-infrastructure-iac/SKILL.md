---
name: contoso-infrastructure-iac
description: Infrastructure-as-Code generation skill for Terraform and Bicep following Contoso standards.
---

## IaC Generation Skill

Use this skill when generating Infrastructure-as-Code configurations. Follow all patterns and templates below to ensure consistency with Contoso standards.

### Terraform Module Template

Every Terraform module must include these files:

**main.tf** — Resource definitions
```hcl
resource "azurerm_resource_group" "this" {
  name     = "${var.company}-${var.environment}-${var.region}-rg-${var.name}"
  location = var.region

  tags = local.common_tags
}
```

**variables.tf** — Input variables with descriptions and validation
```hcl
variable "company" {
  description = "Company prefix for resource naming"
  type        = string
  default     = "contoso"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be dev, staging, or production."
  }
}

variable "region" {
  description = "Azure region for resource deployment"
  type        = string
}

variable "name" {
  description = "Logical name for the resource group"
  type        = string
}

variable "team" {
  description = "Owning team name"
  type        = string
}

variable "cost_center" {
  description = "Finance cost center code"
  type        = string
}
```

**outputs.tf** — Outputs for cross-module references
```hcl
output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.this.name
}

output "resource_group_id" {
  description = "ID of the created resource group"
  value       = azurerm_resource_group.this.id
}
```

**locals.tf** — Common tags and computed values
```hcl
locals {
  common_tags = {
    environment = var.environment
    team        = var.team
    cost-center = var.cost_center
    managed-by  = "terraform"
  }
}
```

**providers.tf** — Provider configuration with version pinning
```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }
}
```

### Bicep Template Structure

**main.bicep** — Module composition
```bicep
targetScope = 'subscription'

@description('Deployment environment')
@allowed(['dev', 'staging', 'production'])
param environment string

@description('Azure region for resources')
param location string = 'eastus'

@description('Owning team name')
param team string

@description('Finance cost center code')
param costCenter string

var commonTags = {
  environment: environment
  team: team
  'cost-center': costCenter
  'managed-by': 'bicep'
}

module resourceGroup 'modules/resource-group.bicep' = {
  name: 'rg-deployment'
  params: {
    name: 'contoso-${environment}-${location}-rg-app'
    location: location
    tags: commonTags
  }
}
```

### Contoso Resource Naming Convention

Pattern: `{company}-{environment}-{region}-{resource-type}-{name}`

| Resource Type       | Abbreviation | Example                              |
|---------------------|--------------|--------------------------------------|
| Resource Group      | rg           | contoso-prod-eastus-rg-api           |
| App Service         | app          | contoso-dev-westus2-app-web          |
| Function App        | func         | contoso-staging-eastus-func-orders   |
| SQL Server          | sql          | contoso-prod-eastus-sql-main         |
| Storage Account     | st           | contosoprodeastusst (no hyphens)     |
| Key Vault           | kv           | contoso-prod-eastus-kv-app           |
| AKS Cluster         | aks          | contoso-prod-eastus-aks-platform     |
| Virtual Network     | vnet         | contoso-prod-eastus-vnet-main        |

### Tagging Strategy

All resources must include these tags. No exceptions.

| Tag Key       | Description                    | Example Values                   |
|---------------|--------------------------------|----------------------------------|
| environment   | Deployment environment         | dev, staging, production         |
| team          | Owning engineering team        | platform, payments, identity     |
| cost-center   | Finance cost center code       | CC-1234, CC-5678                 |
| managed-by    | IaC tool managing the resource | terraform, bicep                 |

### State Management Configuration

**Azure Storage Backend (Terraform)**
```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "contoso-shared-tfstate-rg"
    storage_account_name = "contosotfstate"
    container_name       = "tfstate"
    key                  = "project-name/environment.tfstate"
  }
}
```

**Terraform Cloud Backend (Enterprise)**
```hcl
terraform {
  cloud {
    organization = "contoso"
    workspaces {
      tags = ["project-name"]
    }
  }
}
```

### Environment-Specific Variable Files

Create one `terraform.tfvars` per environment directory:

**environments/dev/terraform.tfvars**
```hcl
environment = "dev"
region      = "eastus"
team        = "platform"
cost_center = "CC-DEV-001"
```

**environments/production/terraform.tfvars**
```hcl
environment = "production"
region      = "eastus"
team        = "platform"
cost_center = "CC-PROD-001"
```

When generating IaC, always produce all environment variable files unless the user specifies a single environment.
