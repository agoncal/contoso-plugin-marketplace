---
name: contoso-frontend-angular-ng-scaffold
description: Angular component, service, and module scaffolding with OnPush, signals, standalone patterns, and testing strategies.
---

## Angular Scaffolding — Contoso Standards

Use this skill to generate production-ready Angular components, services, modules, and tests that follow Contoso's established patterns for standalone components, signals, and reactive forms.

## Component Generation

Every Angular component at Contoso must include:

1. **Standalone flag** — `standalone: true` in the component decorator.
2. **OnPush change detection** — `changeDetection: ChangeDetectionStrategy.OnPush`.
3. **Signal-based inputs/outputs** — Use `input()`, `input.required()`, and `output()` instead of decorators.
4. **Typed template** — Strict template type checking with no `$any()` casts.

### Component Template

```typescript
import {
  ChangeDetectionStrategy,
  Component,
  input,
  output,
  signal,
  computed,
} from '@angular/core';

@Component({
  selector: 'app-feature-name',
  standalone: true,
  imports: [],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <div class="feature-name">
      <h2>{{ title() }}</h2>
      <p>{{ description() }}</p>
    </div>
  `,
  styles: [`
    .feature-name {
      padding: var(--space-md);
    }
  `],
})
export class FeatureNameComponent {
  /** The display title for this feature. */
  title = input.required<string>();

  /** Optional description text. */
  description = input<string>('');

  /** Emitted when the user interacts with this feature. */
  interacted = output<void>();

  /** Internal state managed with signals. */
  protected isExpanded = signal(false);

  /** Derived state computed from signals. */
  protected toggleLabel = computed(() =>
    this.isExpanded() ? 'Collapse' : 'Expand'
  );

  protected toggle(): void {
    this.isExpanded.update((v) => !v);
    this.interacted.emit();
  }
}
```

## Service Generation

Services follow the injectable pattern with `inject()`:

```typescript
import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class FeatureNameService {
  private readonly http = inject(HttpClient);
  private readonly baseUrl = '/api/feature-name';

  getAll(): Observable<FeatureItem[]> {
    return this.http.get<FeatureItem[]>(this.baseUrl);
  }

  getById(id: string): Observable<FeatureItem> {
    return this.http.get<FeatureItem>(`${this.baseUrl}/${id}`);
  }

  create(item: CreateFeatureItemDto): Observable<FeatureItem> {
    return this.http.post<FeatureItem>(this.baseUrl, item);
  }

  update(id: string, item: UpdateFeatureItemDto): Observable<FeatureItem> {
    return this.http.put<FeatureItem>(`${this.baseUrl}/${id}`, item);
  }

  delete(id: string): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`);
  }
}
```

Key rules:
- Use `inject()` function, not constructor injection.
- Return `Observable<T>` from service methods — let the consumer decide when to subscribe.
- Use `providedIn: 'root'` for singleton services; omit for feature-scoped services.

## Module Structure with Lazy Loading

For feature areas with multiple routes, create a routes file:

```typescript
import { Routes } from '@angular/router';

export const FEATURE_ROUTES: Routes = [
  {
    path: '',
    loadComponent: () =>
      import('./feature-list.component').then((m) => m.FeatureListComponent),
  },
  {
    path: ':id',
    loadComponent: () =>
      import('./feature-detail.component').then((m) => m.FeatureDetailComponent),
  },
  {
    path: ':id/edit',
    loadComponent: () =>
      import('./feature-edit.component').then((m) => m.FeatureEditComponent),
    canActivate: [authGuard],
  },
];
```

Register in the parent routes:

```typescript
{
  path: 'features',
  loadChildren: () =>
    import('./features/feature.routes').then((m) => m.FEATURE_ROUTES),
}
```

## RxJS Operator Patterns

### Search with Debounce

```typescript
this.searchControl.valueChanges.pipe(
  debounceTime(300),
  distinctUntilChanged(),
  switchMap((query) => this.searchService.search(query)),
  takeUntilDestroyed(this.destroyRef),
).subscribe((results) => this.results.set(results));
```

### Combine Multiple Data Sources

```typescript
combineLatest([
  this.userService.currentUser$,
  this.settingsService.preferences$,
]).pipe(
  map(([user, prefs]) => ({ user, prefs })),
  takeUntilDestroyed(this.destroyRef),
).subscribe(({ user, prefs }) => {
  this.user.set(user);
  this.preferences.set(prefs);
});
```

### Error Handling with Retry

```typescript
this.dataService.loadData().pipe(
  retry({ count: 3, delay: 1000 }),
  catchError((err) => {
    this.error.set(err.message);
    return EMPTY;
  }),
  takeUntilDestroyed(this.destroyRef),
).subscribe((data) => this.data.set(data));
```

## Testing Patterns

### Component Test with TestBed

```typescript
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { FeatureNameComponent } from './feature-name.component';

describe('FeatureNameComponent', () => {
  let component: FeatureNameComponent;
  let fixture: ComponentFixture<FeatureNameComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [FeatureNameComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(FeatureNameComponent);
    component = fixture.componentInstance;
    fixture.componentRef.setInput('title', 'Test Title');
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('should display the title', () => {
    const el: HTMLElement = fixture.nativeElement;
    expect(el.querySelector('h2')?.textContent).toContain('Test Title');
  });

  it('should toggle expanded state', () => {
    component['toggle']();
    expect(component['isExpanded']()).toBe(true);
  });
});
```

### Service Test

```typescript
import { TestBed } from '@angular/core/testing';
import { HttpTestingController, provideHttpClientTesting } from '@angular/common/http/testing';
import { provideHttpClient } from '@angular/common/http';
import { FeatureNameService } from './feature-name.service';

describe('FeatureNameService', () => {
  let service: FeatureNameService;
  let httpMock: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [provideHttpClient(), provideHttpClientTesting()],
    });
    service = TestBed.inject(FeatureNameService);
    httpMock = TestBed.inject(HttpTestingController);
  });

  afterEach(() => httpMock.verify());

  it('should fetch all items', () => {
    const mockData = [{ id: '1', name: 'Item 1' }];
    service.getAll().subscribe((data) => expect(data).toEqual(mockData));

    const req = httpMock.expectOne('/api/feature-name');
    expect(req.request.method).toBe('GET');
    req.flush(mockData);
  });
});
```

### Testing with Spectator (Recommended)

```typescript
import { createComponentFactory, Spectator } from '@ngneat/spectator';
import { FeatureNameComponent } from './feature-name.component';

describe('FeatureNameComponent (Spectator)', () => {
  const createComponent = createComponentFactory({
    component: FeatureNameComponent,
    componentProperties: { title: 'Test Title' },
  });

  let spectator: Spectator<FeatureNameComponent>;

  beforeEach(() => {
    spectator = createComponent();
  });

  it('should display title', () => {
    expect(spectator.query('h2')).toHaveText('Test Title');
  });
});
```

Always test observable streams, signal updates, and template bindings. Verify that OnPush change detection is respected by checking that manual `detectChanges()` calls are needed after signal updates in tests.
