---
name: component
description: Scaffolding accessible, responsive UI components following Contoso's component library patterns and design system.
---

## Component Scaffolding — Contoso Standards

Use this skill to generate production-ready UI components that conform to Contoso's design system, accessibility requirements, and testing standards.

## Component Template Structure

Every Contoso component must include these elements:

1. **Props interface** — Typed inputs with JSDoc descriptions for each prop.
2. **Accessibility attributes** — ARIA roles, labels, and keyboard interaction support baked into the markup.
3. **Responsive styles** — Mobile-first CSS using Contoso breakpoints and design tokens.
4. **Documentation block** — Storybook-compatible metadata (title, description, args).

## Creating an Accessible Component

Follow this checklist when scaffolding any new component:

- [ ] Define a clear props interface with required vs. optional props.
- [ ] Use semantic HTML as the foundation (`<button>`, `<input>`, `<nav>`, etc.).
- [ ] Add `role` attributes only when the semantic element does not convey the role implicitly.
- [ ] Include `aria-label` or `aria-labelledby` for elements whose purpose is not clear from visible text.
- [ ] Support keyboard interaction: focusable with `Tab`, activatable with `Enter`/`Space` where appropriate.
- [ ] Manage focus programmatically for modals, drawers, and popovers (trap focus, restore focus on close).
- [ ] Announce dynamic updates using `aria-live="polite"` or `aria-live="assertive"`.

## Contoso Component Template

```
Component Name: [PascalCase]
File: components/[ComponentName]/[ComponentName].[ext]
Styles: components/[ComponentName]/[ComponentName].styles.[ext]
Tests: components/[ComponentName]/[ComponentName].test.[ext]
Stories: components/[ComponentName]/[ComponentName].stories.[ext]

Props Interface:
  - id: string (optional) — DOM id for the root element
  - className: string (optional) — Additional CSS classes
  - children: ReactNode | TemplateRef (optional) — Slot content
  - [domain-specific props]

Accessibility:
  - Root element role: [role or "implicit"]
  - Keyboard support: [Tab, Enter, Space, Escape, Arrow keys as needed]
  - ARIA attributes: [list required aria-* attributes]

Responsive Behavior:
  - Mobile (320px): [description]
  - Tablet (768px): [description]
  - Desktop (1024px): [description]
  - Wide (1440px): [description]
```

## Responsive Styles Pattern

Use Contoso's mobile-first breakpoint tokens:

```css
.block {
  padding: var(--space-sm);
  font-size: var(--font-size-sm);
}

@media (min-width: 768px) {
  .block {
    padding: var(--space-md);
    font-size: var(--font-size-md);
  }
}

@media (min-width: 1024px) {
  .block {
    padding: var(--space-lg);
    font-size: var(--font-size-base);
  }
}
```

## Documentation Requirements (Storybook)

Every component must ship with a Storybook story file that includes:

1. **Default story** — Renders the component with default/required props only.
2. **Variants story** — Demonstrates all visual variants (sizes, colors, states).
3. **Interactive story** — Shows the component responding to user actions.
4. **Accessibility story** — Demonstrates keyboard navigation and screen reader behavior.

Include `argTypes` for all props so Storybook controls are fully functional.

## Testing Requirements

Each component must have tests covering four categories:

1. **Render tests** — Component renders without errors with required props; snapshot matches.
2. **Interaction tests** — Click, hover, focus, and keyboard events trigger expected behavior.
3. **Accessibility tests** — Run automated a11y checks (e.g., axe-core); verify ARIA attributes are present and correct.
4. **Responsive tests** — Verify layout changes at each breakpoint using viewport resizing or container queries.

Aim for at least 90% code coverage per component. Test edge cases: empty children, missing optional props, overflow content, and error states.
