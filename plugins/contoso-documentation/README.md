# contoso-documentation

Generate and maintain API docs, READMEs, and architecture decision records following Contoso documentation standards.

## Components

| Type | Name | Description |
|------|------|-------------|
| Agent | `doc-writer` | Documentation specialist following Contoso standards |
| Skill | `generate-docs` | API/README documentation generation |
| Hook | PostToolCall on `create` | Checks if documentation needs updating when files are created |

## Installation

```shell
copilot plugin install contoso-documentation@contoso-marketplace
```

## What It Does

The **doc-writer** agent generates and maintains documentation following Contoso's standards:

- **README files** using the Contoso template (Title, Description, Prerequisites, Installation, Usage, API Reference, Configuration, Testing, Contributing, License)
- **API documentation** with endpoint details, request/response examples, and error codes
- **Architecture Decision Records (ADRs)** with Status, Context, Decision, and Consequences
- **Writing style**: Clear, concise, example-rich, active voice, present tense
