---
name: contoso-frontend-react-patterns
description: React component patterns, custom hooks, context providers, and testing strategies following Contoso conventions.
---

## React Component Patterns — Contoso Standards

Use this skill to generate idiomatic React components, custom hooks, context providers, and tests that follow Contoso's established patterns.

## Component Template (TypeScript)

Every React component at Contoso follows this structure:

```tsx
import { type ReactNode } from 'react';

/** Props for the FeatureName component. */
interface FeatureNameProps {
  /** A unique identifier for the component instance. */
  id?: string;
  /** Additional CSS class names to apply. */
  className?: string;
  /** Content to render inside the component. */
  children?: ReactNode;
}

/** Brief description of what this component does. */
export const FeatureName: React.FC<FeatureNameProps> = ({
  id,
  className,
  children,
}) => {
  return (
    <div id={id} className={className}>
      {children}
    </div>
  );
};
```

Key rules:
- Named export, never default export.
- Props interface defined above the component with JSDoc on each prop.
- Destructure props in the function signature.

## Custom Hook Patterns

### Data Fetching Hook

```tsx
import { useState, useEffect } from 'react';

interface UseFetchResult<T> {
  data: T | null;
  error: Error | null;
  isLoading: boolean;
}

export const useFetch = <T,>(url: string): UseFetchResult<T> => {
  const [data, setData] = useState<T | null>(null);
  const [error, setError] = useState<Error | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const controller = new AbortController();
    setIsLoading(true);

    fetch(url, { signal: controller.signal })
      .then((res) => res.json())
      .then(setData)
      .catch((err) => {
        if (err.name !== 'AbortError') setError(err);
      })
      .finally(() => setIsLoading(false));

    return () => controller.abort();
  }, [url]);

  return { data, error, isLoading };
};
```

### Form Handling Hook

```tsx
import { useState, useCallback, type ChangeEvent } from 'react';

export const useForm = <T extends Record<string, unknown>>(initialValues: T) => {
  const [values, setValues] = useState<T>(initialValues);

  const handleChange = useCallback(
    (e: ChangeEvent<HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement>) => {
      const { name, value } = e.target;
      setValues((prev) => ({ ...prev, [name]: value }));
    },
    [],
  );

  const reset = useCallback(() => setValues(initialValues), [initialValues]);

  return { values, handleChange, reset, setValues };
};
```

### Local Storage Hook

```tsx
import { useState, useEffect } from 'react';

export const useLocalStorage = <T,>(key: string, initialValue: T) => {
  const [value, setValue] = useState<T>(() => {
    try {
      const stored = window.localStorage.getItem(key);
      return stored ? (JSON.parse(stored) as T) : initialValue;
    } catch {
      return initialValue;
    }
  });

  useEffect(() => {
    window.localStorage.setItem(key, JSON.stringify(value));
  }, [key, value]);

  return [value, setValue] as const;
};
```

## Context Provider Pattern

```tsx
import { createContext, useContext, type ReactNode } from 'react';

interface ThemeContextValue {
  theme: 'light' | 'dark';
  toggleTheme: () => void;
}

const ThemeContext = createContext<ThemeContextValue | null>(null);

export const useTheme = (): ThemeContextValue => {
  const ctx = useContext(ThemeContext);
  if (!ctx) throw new Error('useTheme must be used within a ThemeProvider');
  return ctx;
};

export const ThemeProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [theme, setTheme] = useState<'light' | 'dark'>('light');
  const toggleTheme = () => setTheme((t) => (t === 'light' ? 'dark' : 'light'));

  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
};
```

Key rules:
- Context value type is defined as an interface.
- Context is initialized with `null` and the custom hook throws if used outside the provider.
- Provider is a named export alongside the consumer hook.

## Performance Optimization Checklist

Before shipping a component, verify:

- [ ] Large lists use virtualization (e.g., `react-window`) if items exceed 100.
- [ ] Expensive computations are wrapped in `useMemo` with correct dependencies.
- [ ] Callbacks passed to memoized children are stabilized with `useCallback`.
- [ ] Images and heavy components below the fold are lazy-loaded.
- [ ] Bundle size impact has been checked — no unnecessary large dependencies.
- [ ] Re-renders are verified with React DevTools Profiler — no cascading updates.

## Testing Patterns with React Testing Library

### Render Test

```tsx
import { render, screen } from '@testing-library/react';
import { FeatureName } from './FeatureName';

describe('FeatureName', () => {
  it('renders with required props', () => {
    render(<FeatureName>Hello</FeatureName>);
    expect(screen.getByText('Hello')).toBeInTheDocument();
  });
});
```

### Interaction Test

```tsx
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { Counter } from './Counter';

describe('Counter', () => {
  it('increments on button click', async () => {
    const user = userEvent.setup();
    render(<Counter />);
    await user.click(screen.getByRole('button', { name: /increment/i }));
    expect(screen.getByText('1')).toBeInTheDocument();
  });
});
```

### Accessibility Test

```tsx
import { render } from '@testing-library/react';
import { axe, toHaveNoViolations } from 'jest-axe';
import { FeatureName } from './FeatureName';

expect.extend(toHaveNoViolations);

describe('FeatureName accessibility', () => {
  it('has no accessibility violations', async () => {
    const { container } = render(<FeatureName>Accessible content</FeatureName>);
    const results = await axe(container);
    expect(results).toHaveNoViolations();
  });
});
```

Always test user-visible behavior, not implementation details. Query by role, label, or text — never by CSS class or test ID unless no accessible query exists.
