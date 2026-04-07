---
name: contoso-backend-dotnet-nuget-msbuild
description: NuGet package management and MSBuild configuration — .csproj structure, package management, solution organization, and build configuration
---

## Contoso NuGet and MSBuild Management Skill

This skill provides guidance for managing .NET projects with NuGet and MSBuild following Contoso's build and packaging standards. Use this skill when setting up new projects, managing dependencies, configuring builds, or structuring solutions.

## .csproj Configuration

A Contoso-standard .csproj file for an ASP.NET API project:

```xml
<Project Sdk="Microsoft.NET.Sdk.Web">

  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
    <TreatWarningsAsErrors>true</TreatWarningsAsErrors>
    <AnalysisLevel>latest-recommended</AnalysisLevel>
    <EnforceCodeStyleInBuild>true</EnforceCodeStyleInBuild>
  </PropertyGroup>

</Project>
```

Required property settings for all Contoso projects:
- `<Nullable>enable</Nullable>` — always enabled, no exceptions.
- `<ImplicitUsings>enable</ImplicitUsings>` — reduce boilerplate using directives.
- `<TreatWarningsAsErrors>true</TreatWarningsAsErrors>` — zero tolerance for warnings in CI.
- `<AnalysisLevel>latest-recommended</AnalysisLevel>` — enforce latest code analysis rules.

For class libraries:

```xml
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
    <TreatWarningsAsErrors>true</TreatWarningsAsErrors>
  </PropertyGroup>

</Project>
```

## NuGet Package Management

Contoso uses Central Package Management (CPM) with `Directory.Packages.props`:

```xml
<Project>
  <PropertyGroup>
    <ManagePackageVersionsCentrally>true</ManagePackageVersionsCentrally>
  </PropertyGroup>

  <ItemGroup>
    <PackageVersion Include="MediatR" Version="12.3.0" />
    <PackageVersion Include="FluentValidation" Version="11.9.2" />
    <PackageVersion Include="Serilog.AspNetCore" Version="8.0.1" />
    <PackageVersion Include="Microsoft.EntityFrameworkCore" Version="8.0.6" />
    <PackageVersion Include="Swashbuckle.AspNetCore" Version="6.6.2" />
  </ItemGroup>

  <ItemGroup Label="Testing">
    <PackageVersion Include="xunit" Version="2.8.1" />
    <PackageVersion Include="FluentAssertions" Version="6.12.0" />
    <PackageVersion Include="Testcontainers" Version="3.9.0" />
    <PackageVersion Include="NSubstitute" Version="5.1.0" />
    <PackageVersion Include="Microsoft.AspNetCore.Mvc.Testing" Version="8.0.6" />
  </ItemGroup>
</Project>
```

In individual .csproj files, reference packages without versions:

```xml
<ItemGroup>
  <PackageReference Include="MediatR" />
  <PackageReference Include="FluentValidation" />
</ItemGroup>
```

Rules:
- **Always use Central Package Management** for solutions with more than one project.
- **Pin exact versions** — never use floating versions or wildcard ranges.
- **Group packages** by purpose (runtime, testing, tooling) using `Label` attributes.
- **Audit packages** regularly with `dotnet list package --vulnerable` and `--outdated`.

## Solution Structure

Contoso's standard Clean Architecture solution layout:

```
Contoso.Orders/
├── Contoso.Orders.sln
├── Directory.Build.props          # Shared MSBuild properties
├── Directory.Packages.props       # Central package versions
├── .editorconfig                  # Code style rules
├── global.json                    # SDK version pinning
├── src/
│   ├── Contoso.Orders.Api/
│   ├── Contoso.Orders.Application/
│   ├── Contoso.Orders.Domain/
│   └── Contoso.Orders.Infrastructure/
└── tests/
    ├── Contoso.Orders.UnitTests/
    ├── Contoso.Orders.IntegrationTests/
    └── Contoso.Orders.ArchitectureTests/
```

Naming conventions for projects:
- Use the pattern `Contoso.{BoundedContext}.{Layer}` — e.g., `Contoso.Orders.Domain`
- Test projects mirror source projects with a test suffix: `Contoso.Orders.UnitTests`

## Directory.Build.props

Share common properties across all projects in the solution:

```xml
<Project>
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
    <TreatWarningsAsErrors>true</TreatWarningsAsErrors>
  </PropertyGroup>
</Project>
```

This eliminates duplication — individual .csproj files inherit these settings automatically.

## global.json

Pin the .NET SDK version to ensure reproducible builds:

```json
{
  "sdk": {
    "version": "8.0.300",
    "rollForward": "latestPatch"
  }
}
```

- Use `latestPatch` for automatic patch updates within the pinned minor version.
- Update `global.json` intentionally — never allow it to drift.

## Build Configuration

Contoso standard build configurations:

- **Debug** — used in `Development` environment. Full symbols, no optimization.
- **Release** — used in `Staging` and `Production`. Full optimization, trimming enabled for self-contained deployments.

Configure CI-specific settings in `Directory.Build.props`:

```xml
<PropertyGroup Condition="'$(CI)' == 'true'">
  <ContinuousIntegrationBuild>true</ContinuousIntegrationBuild>
  <Deterministic>true</Deterministic>
  <EmbedUntrackedSources>true</EmbedUntrackedSources>
</PropertyGroup>
```

## Common dotnet CLI Commands

```bash
# Restore dependencies
dotnet restore

# Build in Release mode
dotnet build --configuration Release --no-restore

# Run tests with coverage
dotnet test --configuration Release --no-build --collect:"XPlat Code Coverage"

# Add a package (version managed centrally)
dotnet add package MediatR

# Publish self-contained
dotnet publish --configuration Release --self-contained --runtime linux-x64

# Check for vulnerable packages
dotnet list package --vulnerable --include-transitive
```
