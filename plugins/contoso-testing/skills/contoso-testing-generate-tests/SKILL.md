---
name: contoso-testing-generate-tests
description: Generate unit, integration, and e2e tests following Contoso testing standards
---

## Test Generation Skill

This skill generates comprehensive tests following Contoso's testing standards. Use this skill when asked to create tests, improve coverage, or scaffold test suites for existing code.

## Test Generation Process

### Step 1: Analyze the Source Code
Before writing tests, thoroughly understand:
- What the function/class does (inputs, outputs, side effects)
- What dependencies it has (databases, APIs, file system)
- What can go wrong (error conditions, edge cases)
- What the expected behavior is for each scenario

### Step 2: Identify Test Cases
For each function or method, create test cases for:

**Happy Path (required)**
- Normal input with expected output
- Multiple valid input variations

**Error Handling (required)**
- Invalid inputs (wrong type, out of range, malformed)
- Missing required parameters
- External dependency failures (network, database, file system)
- Permission/authorization failures

**Edge Cases (required)**
- Empty/null/undefined inputs
- Boundary values (0, -1, MAX_INT, empty string)
- Unicode and special characters
- Very large inputs

**Integration Points (when applicable)**
- Database read/write operations
- API call and response handling
- Event emission and handling
- Cache hit and miss scenarios

### Step 3: Write Tests Using AAA Pattern

Every test follows Arrange-Act-Assert:

```javascript
// Jest/Vitest example
describe("OrderService", () => {
  describe("calculateTotal", () => {
    it("should_return_sum_of_item_prices_when_no_discount_applied", () => {
      // Arrange
      const items = [
        { name: "Widget", price: 10.00, quantity: 2 },
        { name: "Gadget", price: 25.00, quantity: 1 },
      ];

      // Act
      const total = orderService.calculateTotal(items);

      // Assert
      expect(total).toBe(45.00);
    });

    it("should_return_zero_when_items_array_is_empty", () => {
      // Arrange
      const items = [];

      // Act
      const total = orderService.calculateTotal(items);

      // Assert
      expect(total).toBe(0);
    });

    it("should_throw_validation_error_when_item_has_negative_price", () => {
      // Arrange
      const items = [{ name: "Bad Item", price: -5.00, quantity: 1 }];

      // Act & Assert
      expect(() => orderService.calculateTotal(items))
        .toThrow(ValidationError);
    });
  });
});
```

```python
# pytest example
class TestOrderService:
    def test_should_return_sum_of_item_prices_when_no_discount_applied(self):
        # Arrange
        items = [
            {"name": "Widget", "price": 10.00, "quantity": 2},
            {"name": "Gadget", "price": 25.00, "quantity": 1},
        ]

        # Act
        total = order_service.calculate_total(items)

        # Assert
        assert total == 45.00

    def test_should_return_zero_when_items_list_is_empty(self):
        # Arrange
        items = []

        # Act
        total = order_service.calculate_total(items)

        # Assert
        assert total == 0

    def test_should_raise_validation_error_when_item_has_negative_price(self):
        # Arrange
        items = [{"name": "Bad Item", "price": -5.00, "quantity": 1}]

        # Act & Assert
        with pytest.raises(ValidationError):
            order_service.calculate_total(items)
```

```java
// JUnit 5 example
class OrderServiceTest {
    @Test
    void should_return_sum_of_item_prices_when_no_discount_applied() {
        // Arrange
        var items = List.of(
            new Item("Widget", 10.00, 2),
            new Item("Gadget", 25.00, 1)
        );

        // Act
        double total = orderService.calculateTotal(items);

        // Assert
        assertThat(total).isEqualTo(45.00);
    }

    @Test
    void should_return_zero_when_items_list_is_empty() {
        // Arrange
        var items = List.<Item>of();

        // Act
        double total = orderService.calculateTotal(items);

        // Assert
        assertThat(total).isZero();
    }

    @Test
    void should_throw_validation_error_when_item_has_negative_price() {
        // Arrange
        var items = List.of(new Item("Bad Item", -5.00, 1));

        // Act & Assert
        assertThatThrownBy(() -> orderService.calculateTotal(items))
            .isInstanceOf(ValidationException.class);
    }
}
```

### Step 4: Create Test Helpers and Factories
For complex objects, create reusable test factories:

```
test/
├── factories/
│   ├── user.factory.ts
│   ├── order.factory.ts
│   └── product.factory.ts
├── fixtures/
│   ├── valid-api-response.json
│   └── error-response.json
└── helpers/
    ├── database.helper.ts
    └── mock-server.helper.ts
```

## Coverage Analysis

After generating tests, check coverage:

```bash
# JavaScript/TypeScript
npx jest --coverage
npx vitest --coverage

# Python
pytest --cov=src --cov-report=term-missing

# Java
mvn jacoco:report

# Go
go test -coverprofile=coverage.out ./...
go tool cover -func=coverage.out

# .NET
dotnet test --collect:"XPlat Code Coverage"
```

### Coverage Targets
| Metric | Minimum | Target |
|--------|---------|--------|
| Line coverage | 80% | 90% |
| Branch coverage | 75% | 85% |
| Function coverage | 85% | 95% |

### Coverage Report Format
```
## Test Coverage Report

**Module:** [module name]
**Framework:** [test framework]

| File | Lines | Branches | Functions |
|------|-------|----------|-----------|
| src/service.ts | 92% | 85% | 100% |
| src/utils.ts | 88% | 80% | 95% |

**Overall:** 90% lines, 82% branches, 97% functions
**Status:** ✅ Meets Contoso minimum (80% lines)

### Uncovered Areas
- `src/service.ts:45-52` — Error handling for timeout scenario
- `src/utils.ts:78` — Null check branch
```

## Anti-Patterns to Avoid

1. **Testing implementation details**: Test behavior, not internal structure
2. **Excessive mocking**: If you need 10 mocks, the code needs refactoring
3. **Flaky tests**: Never depend on timing, network, or execution order
4. **Meaningless assertions**: `expect(result).toBeTruthy()` — assert specific values
5. **Copy-paste tests**: Use parameterized tests for similar scenarios
6. **Testing getters/setters**: Only test logic, not trivial property access
