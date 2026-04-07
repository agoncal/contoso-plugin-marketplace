# contoso-testing

Generate unit, integration, and end-to-end tests with coverage tracking and test strategy guidance.

## Components

| Type | Name | Description |
|------|------|-------------|
| Agent | `contoso-testing` | Test generation agent following Contoso testing standards |
| Skill | `contoso-testing-generate-tests` | Generate unit/integration tests |
| Hook | PostToolCall on `create` | Reminds to create tests when new source files are added |

## Installation

```shell
copilot plugin install contoso-testing@contoso-marketplace
```

## What It Does

The **contoso-testing** agent creates comprehensive tests following Contoso standards:

- **Coverage**: Minimum 80% line, 70% branch, 100% for critical paths (auth, payments)
- **Naming convention**: `should_[expected]_when_[condition]`
- **AAA pattern**: Arrange → Act → Assert in every test
- **Test types**: Unit (isolated, mocked), Integration (real dependencies), E2E (user workflows)
- **Frameworks**: JUnit 5, pytest, Vitest/Jest, xUnit — selected based on project language
- **Test data**: Factory/builder patterns, no shared mutable state, realistic fake data
