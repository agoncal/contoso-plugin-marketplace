---
name: contoso-backend-java-exception-handling
description: Spring exception handling with @ControllerAdvice and Contoso custom exception hierarchy
---

## Exception Handling Skill

This skill provides patterns for implementing centralized exception handling in Spring Boot applications following Contoso standards. Use this when setting up error handling for new services or standardizing error responses.

## Contoso Exception Hierarchy

```java
public abstract class ContosoBaseException extends RuntimeException {

    private final String errorCode;
    private final List<ErrorDetail> details;

    protected ContosoBaseException(String errorCode, String message) {
        this(errorCode, message, List.of());
    }

    protected ContosoBaseException(String errorCode, String message, List<ErrorDetail> details) {
        super(message);
        this.errorCode = errorCode;
        this.details = details;
    }

    public record ErrorDetail(String field, String reason) {}
}

public class ContosoNotFoundException extends ContosoBaseException {
    public ContosoNotFoundException(String resourceType, String identifier) {
        super(
            "RESOURCE_NOT_FOUND",
            "%s with identifier '%s' not found".formatted(resourceType, identifier)
        );
    }
}

public class ContosoValidationException extends ContosoBaseException {
    public ContosoValidationException(List<ErrorDetail> details) {
        super("VALIDATION_FAILED", "One or more fields failed validation.", details);
    }
}

public class ContosoConflictException extends ContosoBaseException {
    public ContosoConflictException(String message) {
        super("RESOURCE_CONFLICT", message);
    }
}

public class ContosoForbiddenException extends ContosoBaseException {
    public ContosoForbiddenException(String message) {
        super("PERMISSION_DENIED", message);
    }
}
```

## Global Exception Handler

```java
@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    @ExceptionHandler(ContosoNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(ContosoNotFoundException ex, HttpServletRequest request) {
        log.warn("Resource not found: {}", ex.getMessage());
        return buildResponse(HttpStatus.NOT_FOUND, ex, request);
    }

    @ExceptionHandler(ContosoValidationException.class)
    public ResponseEntity<ErrorResponse> handleValidation(ContosoValidationException ex, HttpServletRequest request) {
        log.warn("Validation failed: {}", ex.getMessage());
        return buildResponse(HttpStatus.BAD_REQUEST, ex, request);
    }

    @ExceptionHandler(ContosoConflictException.class)
    public ResponseEntity<ErrorResponse> handleConflict(ContosoConflictException ex, HttpServletRequest request) {
        log.warn("Resource conflict: {}", ex.getMessage());
        return buildResponse(HttpStatus.CONFLICT, ex, request);
    }

    @ExceptionHandler(ContosoForbiddenException.class)
    public ResponseEntity<ErrorResponse> handleForbidden(ContosoForbiddenException ex, HttpServletRequest request) {
        log.warn("Access denied: {}", ex.getMessage());
        return buildResponse(HttpStatus.FORBIDDEN, ex, request);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleBeanValidation(MethodArgumentNotValidException ex, HttpServletRequest request) {
        var details = ex.getBindingResult().getFieldErrors().stream()
            .map(fe -> new ErrorDetail(fe.getField(), fe.getDefaultMessage()))
            .toList();
        var exception = new ContosoValidationException(details);
        return buildResponse(HttpStatus.BAD_REQUEST, exception, request);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleUnexpected(Exception ex, HttpServletRequest request) {
        log.error("Unexpected error processing request {}: {}", request.getRequestURI(), ex.getMessage(), ex);
        var exception = new ContosoBaseException("INTERNAL_ERROR", "An unexpected error occurred.") {};
        return buildResponse(HttpStatus.INTERNAL_SERVER_ERROR, exception, request);
    }

    private ResponseEntity<ErrorResponse> buildResponse(HttpStatus status, ContosoBaseException ex, HttpServletRequest request) {
        var error = new ErrorResponse(
            new ErrorBody(ex.getErrorCode(), ex.getMessage(), ex.getDetails()),
            new MetaInfo(request.getHeader("X-Request-Id"), Instant.now())
        );
        return ResponseEntity.status(status).body(error);
    }
}
```

## Error Response DTOs

```java
public record ErrorResponse(ErrorBody error, MetaInfo meta) {}

public record ErrorBody(String code, String message, List<ErrorDetail> details) {}

public record ErrorDetail(String field, String reason) {}

public record MetaInfo(String requestId, Instant timestamp) {}
```

## Usage in Service Layer

```java
@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    public UserResponse findById(UUID id) {
        return userRepository.findById(id)
            .map(UserMapper::toResponse)
            .orElseThrow(() -> new ContosoNotFoundException("User", id.toString()));
    }

    public UserResponse create(CreateUserRequest request) {
        if (userRepository.existsByEmail(request.email())) {
            throw new ContosoConflictException(
                "User with email '%s' already exists".formatted(request.email())
            );
        }
        // ... create user
    }
}
```

## Rules

1. **Throw from the service layer** — Controllers should not contain try/catch blocks. Let exceptions propagate to `@ControllerAdvice`.
2. **Use specific exception types** — Prefer `ContosoNotFoundException` over generic `RuntimeException`.
3. **Never catch and swallow** — Every caught exception must be either re-thrown, wrapped, or logged at ERROR level.
4. **Log at the handler level** — The global handler is responsible for logging. Services should not log the exception they throw.
5. **Never expose stack traces** — The `INTERNAL_ERROR` handler must not include `ex.getMessage()` from unexpected exceptions in the response body.
