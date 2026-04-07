# contoso-backend-typescript

TypeScript and Node.js backend development — project configuration, Express/NestJS patterns, and strict typing enforcement.

## Components

| Type | Name | Description |
|------|------|-------------|
| Agent | `contoso-backend-typescript` | TypeScript/Node.js backend expert |
| Skill | `contoso-backend-typescript-ts-node` | TypeScript backend patterns |
| Hook | PreToolCall on `edit` | Enforces strict typing and no `any` usage in `.ts` files |

## Installation

```shell
copilot plugin install contoso-backend-typescript@contoso-marketplace
```

## What It Does

The **contoso-backend-typescript** agent enforces Contoso's TypeScript backend standards:

- **TypeScript 5.x** with strict mode, `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`
- **ESM modules exclusively** — no CommonJS in new projects
- **Frameworks**: NestJS for enterprise, Express + tsyringe for lightweight services
- **Type safety**: No `any` (use `unknown` + type guards), branded types for IDs, `satisfies` operator
- **Validation**: Zod for runtime validation with `z.infer` for type generation
- **Package management**: pnpm exclusively
- **Error handling**: Custom error classes, Result pattern for fallible operations
- **Testing**: Vitest + supertest, minimum 80% coverage

> **See also**: [contoso-backend](../contoso-backend/) for general API conventions.
