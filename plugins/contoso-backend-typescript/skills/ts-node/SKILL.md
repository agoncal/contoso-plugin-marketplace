---
name: ts-node
description: TypeScript backend patterns — strict project setup, ESM configuration, Zod schemas, error handling, and testing with Vitest
---

## Contoso TypeScript Backend Patterns Skill

This skill provides guidance for setting up and developing TypeScript backend projects following Contoso's strict standards. Use this skill when creating new projects, configuring TypeScript, writing Zod schemas, implementing error handling, or setting up tests.

## Project Initialization

Create a new Contoso-standard TypeScript backend project:

```bash
mkdir contoso-order-service && cd contoso-order-service
pnpm init
pnpm add typescript @types/node -D
pnpm add zod dotenv
npx tsc --init
```

Set `"type": "module"` in `package.json`:

```json
{
  "name": "contoso-order-service",
  "version": "1.0.0",
  "type": "module",
  "engines": { "node": ">=20.0.0" },
  "packageManager": "pnpm@9.4.0",
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js",
    "dev": "tsx watch src/index.ts",
    "test": "vitest",
    "test:coverage": "vitest run --coverage",
    "lint": "eslint src/",
    "typecheck": "tsc --noEmit"
  }
}
```

## Strict tsconfig.json

The complete Contoso-standard TypeScript configuration:

```json
{
  "compilerOptions": {
    "target": "ES2023",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "lib": ["ES2023"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,
    "noImplicitOverride": true,
    "noPropertyAccessFromIndexSignature": true,
    "noFallthroughCasesInSwitch": true,
    "forceConsistentCasingInFileNames": true,
    "verbatimModuleSyntax": true,
    "isolatedModules": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "skipLibCheck": true,
    "esModuleInterop": false
  },
  "include": ["src/**/*.ts"],
  "exclude": ["node_modules", "dist"]
}
```

Critical flags explained:
- `strict` — enables all strict checks (strictNullChecks, noImplicitAny, etc.)
- `noUncheckedIndexedAccess` — array/object index access returns `T | undefined`
- `exactOptionalPropertyTypes` — `prop?: string` means `string | undefined`, not `string | undefined | missing`
- `verbatimModuleSyntax` — enforces explicit `import type` for type-only imports

## ESM Configuration

ESM is mandatory for all new Contoso projects. Key rules:

1. Set `"type": "module"` in `package.json`.
2. Use `.js` extension in relative imports (even for `.ts` source files):

```typescript
// Correct
import { OrderService } from './order.service.js';
import type { Order } from './order.types.js';

// Wrong — will fail at runtime
import { OrderService } from './order.service';
import { OrderService } from './order.service.ts';
```

3. Use `import type` for type-only imports (enforced by `verbatimModuleSyntax`):

```typescript
import type { Request, Response } from 'express';
import { Router } from 'express';
```

4. For `__dirname` and `__filename` equivalents in ESM:

```typescript
import { fileURLToPath } from 'node:url';
import { dirname } from 'node:path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
```

## Zod Schema Patterns

Define validation schemas as the single source of truth:

```typescript
import { z } from 'zod';

// Base schemas for reuse
const UuidSchema = z.string().uuid();
const PaginationSchema = z.object({
  cursor: z.string().optional(),
  limit: z.coerce.number().int().min(1).max(100).default(25),
});

// Domain schemas
export const OrderItemSchema = z.object({
  productId: UuidSchema,
  quantity: z.number().int().positive(),
  unitPrice: z.number().positive(),
});

export const CreateOrderSchema = z.object({
  customerId: UuidSchema,
  items: z.array(OrderItemSchema).min(1).max(50),
  notes: z.string().trim().max(500).optional(),
  priority: z.enum(['low', 'normal', 'high']).default('normal'),
});

// Derive types from schemas
export type CreateOrderDto = z.infer<typeof CreateOrderSchema>;
export type OrderItem = z.infer<typeof OrderItemSchema>;

// Validation helper for route handlers
export function validate<T>(schema: z.ZodSchema<T>, data: unknown): T {
  const result = schema.safeParse(data);
  if (!result.success) {
    throw new ValidationError(result.error.flatten());
  }
  return result.data;
}
```

Patterns:
- Compose schemas from smaller, reusable schemas.
- Use `.transform()` for data normalization (e.g., trimming strings, converting case).
- Use `.refine()` for cross-field validation.
- Use `z.infer<>` to derive types — never define types separately from schemas.

## Error Handling Patterns

Contoso's standard error class hierarchy:

```typescript
export abstract class AppError extends Error {
  abstract readonly statusCode: number;
  abstract readonly errorCode: string;
  abstract readonly isOperational: boolean;

  constructor(message: string, public readonly details?: unknown[]) {
    super(message);
    this.name = this.constructor.name;
    Error.captureStackTrace(this, this.constructor);
  }

  toResponse() {
    return {
      error: {
        code: this.errorCode,
        message: this.message,
        ...(this.details && { details: this.details }),
      },
    };
  }
}

export class ValidationError extends AppError {
  readonly statusCode = 400;
  readonly errorCode = 'VALIDATION_FAILED';
  readonly isOperational = true;
}

export class NotFoundError extends AppError {
  readonly statusCode = 404;
  readonly errorCode = 'RESOURCE_NOT_FOUND';
  readonly isOperational = true;
}

export class ConflictError extends AppError {
  readonly statusCode = 409;
  readonly errorCode = 'RESOURCE_CONFLICT';
  readonly isOperational = true;
}
```

Global error handler middleware:

```typescript
export function errorHandler(err: Error, req: Request, res: Response, _next: NextFunction): void {
  if (err instanceof AppError && err.isOperational) {
    res.status(err.statusCode).json(err.toResponse());
    return;
  }

  // Programming error — log and return generic 500
  logger.error('Unexpected error', { error: err });
  res.status(500).json({
    error: {
      code: 'INTERNAL_ERROR',
      message: 'An unexpected error occurred.',
    },
  });
}
```

## Testing Setup with Vitest

`vitest.config.ts`:

```typescript
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    include: ['src/**/*.test.ts', 'tests/**/*.test.ts'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'lcov', 'json-summary'],
      include: ['src/**/*.ts'],
      exclude: ['src/**/*.test.ts', 'src/**/*.d.ts', 'src/index.ts'],
      thresholds: {
        statements: 80,
        branches: 80,
        functions: 80,
        lines: 80,
      },
    },
  },
});
```

Test patterns:

```typescript
import { describe, it, expect, vi, beforeEach } from 'vitest';

describe('OrderService', () => {
  let service: OrderService;
  let mockRepo: MockOrderRepository;

  beforeEach(() => {
    mockRepo = {
      findById: vi.fn(),
      save: vi.fn(),
      delete: vi.fn(),
    };
    service = new OrderService(mockRepo);
  });

  describe('createOrder', () => {
    it('should create order with valid input', async () => {
      mockRepo.save.mockResolvedValue({ id: 'order-1', ...validInput });

      const result = await service.createOrder(validInput);

      expect(result.id).toBe('order-1');
      expect(mockRepo.save).toHaveBeenCalledWith(expect.objectContaining({
        customerId: validInput.customerId,
      }));
    });

    it('should throw NotFoundError for invalid customer', async () => {
      mockRepo.save.mockRejectedValue(new NotFoundError('Customer not found'));

      await expect(service.createOrder(invalidInput))
        .rejects
        .toThrow(NotFoundError);
    });
  });
});
```
