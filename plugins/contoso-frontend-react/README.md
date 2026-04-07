# contoso-frontend-react

React-specific development — component patterns, hooks, state management, and Contoso React style guide enforcement.

## Components

| Type | Name | Description |
|------|------|-------------|
| Agent | `react-expert` | React development expert with TypeScript |
| Skill | `react-patterns` | React component and hook patterns |
| Hook | PreToolCall on `create` | Enforces functional components with TypeScript in `.tsx`/`.jsx` files |

## Installation

```shell
copilot plugin install contoso-frontend-react@contoso-marketplace
```

## What It Does

The **react-expert** agent enforces Contoso's React standards:

- **Functional components only** with TypeScript and named exports
- **Hooks**: Correct dependency arrays, cleanup functions, custom hooks for shared logic
- **State management**: useState (local), React Context + useReducer (simple shared), Zustand (complex), TanStack Query (server state)
- **File structure**: `components/`, `hooks/`, `contexts/`, `pages/`, `utils/`, `types/`
- **Performance**: React.memo when profiled, code splitting with React.lazy, virtualization for large lists
- **Testing**: React Testing Library with accessible queries (`getByRole`, `getByLabelText`), MSW for API mocking

> **See also**: [contoso-frontend](../contoso-frontend/) for general frontend standards.
