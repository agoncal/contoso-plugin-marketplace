---
name: contoso-backend-database-migration
description: Database migration patterns using Flyway, Liquibase, and Alembic with Contoso standards
---

## Database Migration Skill

This skill provides guidance for managing database schema changes using migration tools. Use this when setting up migrations, creating new migration scripts, or establishing migration workflows.

## Contoso Migration Standards

### General Rules

1. **Migrations are immutable** — Never edit a migration that has been applied to any environment. Create a new migration to fix issues.
2. **One concern per migration** — Each migration file should address a single schema change (add table, add column, create index).
3. **Always provide rollback** — Every migration must have a corresponding rollback/undo script.
4. **Use descriptive names** — Migration filenames must describe the change: `V003__add_email_index_to_users.sql`, not `V003__update.sql`.
5. **Test migrations** — Run migrations against a copy of production data before deploying.
6. **No data loss** — Never drop columns or tables without a deprecation period (minimum 2 release cycles).

### Migration Naming Convention

```
V{version}__{description}.sql        # Flyway versioned
R__{description}.sql                  # Flyway repeatable
{timestamp}_{description}.py          # Alembic
```

### Safe Schema Change Patterns

#### Adding a column
```sql
-- Safe: add nullable column with default
ALTER TABLE users ADD COLUMN phone VARCHAR(20) DEFAULT NULL;
```

#### Renaming a column (multi-step)
```
Step 1 (release N):   Add new column, dual-write to both
Step 2 (release N+1): Migrate data, update reads to new column
Step 3 (release N+2): Drop old column
```

#### Adding an index
```sql
-- Safe: create index concurrently (PostgreSQL)
CREATE INDEX CONCURRENTLY idx_users_email ON users (email);
```

#### Dropping a column (multi-step)
```
Step 1 (release N):   Stop writing to column, remove from code
Step 2 (release N+1): Verify no reads/writes in production logs
Step 3 (release N+2): Drop column in migration
```

## Tool-Specific Guidance

### Flyway (Java/Spring Boot — Contoso standard)

Directory structure:
```
src/main/resources/db/migration/
├── V001__create_users_table.sql
├── V002__create_orders_table.sql
├── V003__add_email_index_to_users.sql
└── R__refresh_reporting_views.sql
```

Spring Boot configuration:
```yaml
spring:
  flyway:
    enabled: true
    locations: classpath:db/migration
    baseline-on-migrate: true
    validate-on-migrate: true
```

### Liquibase (.NET — alternative)

Use YAML changelog format:
```yaml
databaseChangeLog:
  - changeSet:
      id: 001-create-users
      author: contoso-engineering
      changes:
        - createTable:
            tableName: users
            columns:
              - column:
                  name: id
                  type: uuid
                  constraints:
                    primaryKey: true
```

### Alembic (Python — Contoso standard)

```python
# alembic/versions/001_create_users_table.py
def upgrade():
    op.create_table(
        'users',
        sa.Column('id', sa.UUID(), primary_key=True),
        sa.Column('email', sa.String(255), nullable=False, unique=True),
        sa.Column('created_at', sa.DateTime(), server_default=sa.func.now()),
    )

def downgrade():
    op.drop_table('users')
```

## CI/CD Integration

- Run migrations as a separate step before application deployment
- Use a dedicated database user with schema modification permissions for migrations
- Lock migrations during deployment to prevent concurrent execution
- Verify migration status in health check endpoints
