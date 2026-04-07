---
name: review
description: Perform structured code reviews following Contoso coding standards and best practices
---

## Structured Code Review Skill

This skill performs comprehensive code reviews following Contoso Engineering's standards and best practices. Use this skill when asked to review code changes, pull requests, or code files for quality and compliance.

## Review Checklist

When performing a review, systematically check each of the following areas:

### 1. Error Handling
- [ ] All error paths are handled explicitly (no silent failures)
- [ ] Errors include sufficient context for debugging (file, function, operation, input)
- [ ] Error messages are user-friendly at API boundaries and detailed in logs
- [ ] Async operations have proper error handling and cleanup
- [ ] Resource cleanup happens in finally blocks or equivalent patterns (defer, using, try-with-resources)

### 2. Input Validation
- [ ] All public function parameters are validated before use
- [ ] External inputs are sanitized to prevent injection attacks
- [ ] Boundary conditions are checked (null, empty, negative, overflow)
- [ ] Data types and formats are verified at API boundaries
- [ ] File paths, URLs, and user-supplied identifiers are validated

### 3. Naming Conventions
- [ ] Variables describe their content, not their type (e.g., `userCount` not `intVar`)
- [ ] Functions describe their action (e.g., `calculateTotal` not `process`)
- [ ] Boolean variables use is/has/should prefixes (e.g., `isActive`, `hasPermission`)
- [ ] Constants use UPPER_SNAKE_CASE
- [ ] Classes use PascalCase, functions use camelCase (or language-appropriate conventions)
- [ ] No single-letter names except loop counters in short loops

### 4. Test Coverage
- [ ] New code has corresponding unit tests
- [ ] Edge cases and error paths are tested
- [ ] Tests are independent and deterministic (no flaky tests)
- [ ] Test names describe the scenario: `should_[expected]_when_[condition]`
- [ ] Integration tests exist for cross-component interactions
- [ ] Mocks and stubs are used appropriately, not excessively

### 5. Documentation
- [ ] Public APIs have documentation comments (JSDoc, Javadoc, docstrings, XML docs)
- [ ] Complex algorithms have explanatory comments
- [ ] README is updated if features, configuration, or setup steps change
- [ ] Architecture decision records exist for significant design choices
- [ ] No commented-out code (use version control, not comments)

### 6. Security
- [ ] No hardcoded credentials, API keys, or secrets
- [ ] SQL queries use parameterized statements
- [ ] User input is sanitized before rendering (XSS prevention)
- [ ] Authentication and authorization checks are in place
- [ ] Dependencies are free of known vulnerabilities

### 7. Performance
- [ ] No N+1 query patterns in database access
- [ ] Large collections are paginated
- [ ] Expensive operations are cached where appropriate
- [ ] No unnecessary object allocations in hot paths
- [ ] Async operations are used for I/O-bound work

## Output Format

Structure review results as follows:

```
## Code Review Results

**Files Reviewed:** [list of files]
**Overall Assessment:** [APPROVE | REQUEST_CHANGES | COMMENT]
**Standards Compliance:** [PASS | FAIL — list violations]

### Critical Issues (must fix)
1. [file:line] — [description] — [suggested fix]

### Warnings (should fix)
1. [file:line] — [description] — [recommendation]

### Suggestions (nice to have)
1. [file:line] — [description] — [proposed improvement]

### Positive Highlights
1. [file:line] — [what was done well]

### Checklist Summary
- Error Handling: ✅/❌
- Input Validation: ✅/❌
- Naming Conventions: ✅/❌
- Test Coverage: ✅/❌
- Documentation: ✅/❌
- Security: ✅/❌
- Performance: ✅/❌
```

## Severity Classification

- **Critical**: Bugs, security vulnerabilities, data loss risks, breaking changes. These MUST be fixed before merge.
- **Warning**: Performance issues, missing edge cases, standards violations, maintainability concerns. These SHOULD be fixed.
- **Suggestion**: Code style improvements, refactoring opportunities, documentation enhancements. These are OPTIONAL but encouraged.
