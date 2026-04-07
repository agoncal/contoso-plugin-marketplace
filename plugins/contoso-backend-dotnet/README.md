# contoso-backend-dotnet

.NET and C# development — NuGet/MSBuild management, ASP.NET patterns, and Contoso .NET conventions.

## Components

| Type | Name | Description |
|------|------|-------------|
| Agent | `dotnet-expert` | .NET/C# development expert |
| Skill | `nuget-msbuild` | Package and build management |
| Hook | PreToolCall on `edit` | Enforces naming conventions and nullable reference types in `.cs` files |

## Installation

```shell
copilot plugin install contoso-backend-dotnet@contoso-marketplace
```

## What It Does

The **dotnet-expert** agent enforces Contoso's .NET conventions:

- **.NET 8+** with C# 12 features (primary constructors, collection expressions, required members)
- **Clean Architecture**: API → Application → Domain → Infrastructure
- **Minimal APIs** for new projects (Contoso standard for .NET 8+)
- **Naming**: PascalCase public, `_camelCase` private, `I`-prefix interfaces, `Async` suffix
- **Data access**: Entity Framework Core with code-first migrations, nullable reference types enabled
- **CQRS**: MediatR with pipeline behaviors for cross-cutting concerns
- **Validation**: FluentValidation for request DTOs
- **Testing**: xUnit + Moq + FluentAssertions, `WebApplicationFactory<T>` for integration tests

> **See also**: [contoso-backend](../contoso-backend/) for general API conventions.
