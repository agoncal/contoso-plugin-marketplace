---
name: generate-docs
description: Generate API documentation, READMEs, and ADRs following Contoso templates
---

## Documentation Generation Skill

This skill generates comprehensive documentation for Contoso projects including API docs, README files, and Architecture Decision Records. Use this skill when asked to create, update, or scaffold project documentation.

## API Documentation Generation

When generating API documentation from source code, follow these steps:

### Step 1: Identify Public Interfaces
- Scan the codebase for public classes, functions, methods, and endpoints
- Identify exported modules, REST endpoints, GraphQL schemas, or CLI commands
- Note any decorators, annotations, or attributes that indicate public API surface

### Step 2: Extract Documentation
- Read existing doc comments (JSDoc, Javadoc, docstrings, XML docs)
- Analyze function signatures for parameter types, return types, and thrown exceptions
- Identify default values, optional parameters, and overloaded methods

### Step 3: Generate Documentation
For each public API element, produce:

```
### `functionName(param1: Type, param2: Type): ReturnType`

Brief description of what this function does.

**Parameters:**
| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| param1 | `Type` | Yes | — | Description |
| param2 | `Type` | No | `default` | Description |

**Returns:** `ReturnType` — Description of return value

**Throws:**
- `ErrorType` — When this error condition occurs

**Example:**
\`\`\`language
// Concrete, runnable example
const result = functionName("input", { option: true });
\`\`\`
```

## README Scaffolding

When creating a README, use the Contoso README template:

1. **Title**: Project name as H1 heading
2. **Description**: One paragraph explaining the project's purpose and value proposition
3. **Prerequisites**: All required tools with version numbers (e.g., `Node.js >= 18.0`, `Python >= 3.11`)
4. **Installation**: Numbered steps with code blocks for each command
5. **Usage**: At least 3 usage examples covering common scenarios
6. **API Reference**: Summary table with links to detailed docs
7. **Configuration**: Table of environment variables with descriptions and defaults
8. **Contributing**: Brief workflow description with link to CONTRIBUTING.md
9. **License**: License type with link to LICENSE file

### README Quality Checklist
- [ ] Can a new developer go from zero to running in under 15 minutes?
- [ ] Are all prerequisites listed with version requirements?
- [ ] Do code examples actually work when copy-pasted?
- [ ] Are environment variables documented with example values?
- [ ] Is the project's purpose clear from the first paragraph?

## ADR Creation

When creating Architecture Decision Records:

1. **Number sequentially**: Check the `docs/adr/` directory for existing ADRs and use the next number
2. **Title should be descriptive**: Use the format `ADR-NNNN: Verb + Object` (e.g., `ADR-0012: Use PostgreSQL for User Data`)
3. **Context must be thorough**: Explain the business and technical drivers behind the decision
4. **List ALL alternatives**: Document every option considered with pros and cons
5. **Consequences must be honest**: Include negative consequences and technical debt introduced
6. **Link related ADRs**: Reference any ADRs that this decision supersedes or depends on

### ADR File Naming Convention
```
docs/adr/NNNN-descriptive-slug.md
```
Example: `docs/adr/0012-use-postgresql-for-user-data.md`

## Documentation Maintenance

When updating existing documentation:
- Verify all code examples still compile and run
- Update version numbers, URLs, and external references
- Check that screenshots and diagrams reflect the current UI/architecture
- Remove documentation for deprecated or removed features
- Add migration guides when breaking changes are introduced
