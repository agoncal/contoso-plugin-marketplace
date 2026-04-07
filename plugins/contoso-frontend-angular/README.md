# contoso-frontend-angular

Angular-specific development — component/service generation, RxJS patterns, and Contoso Angular style guide enforcement.

## Components

| Type | Name | Description |
|------|------|-------------|
| Agent | `angular-expert` | Angular development expert with signals and RxJS |
| Skill | `ng-scaffold` | Angular component/service scaffolding |
| Hook | PreToolCall on `create` | Enforces OnPush change detection and standalone components |

## Installation

```shell
copilot plugin install contoso-frontend-angular@contoso-marketplace
```

## What It Does

The **angular-expert** agent enforces Contoso's Angular standards:

- **Standalone components** with OnPush change detection by default
- **Signals**: Angular signals (`signal()`, `computed()`, `effect()`) for reactive state
- **RxJS**: Proper subscription cleanup with `takeUntilDestroyed`, declarative streams, correct operator selection
- **Reactive forms only** — no template-driven forms in new code
- **Lazy loading**: Feature areas loaded via `loadComponent` in route configuration
- **Dependency injection**: `inject()` function (not constructor injection) for new code
- **Testing**: TestBed or Spectator, `HttpClientTestingModule` for HTTP tests

> **See also**: [contoso-frontend](../contoso-frontend/) for general frontend standards.
