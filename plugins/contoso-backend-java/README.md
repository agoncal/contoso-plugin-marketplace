# contoso-backend-java

Java and Spring Boot development — Maven/Gradle management, Spring patterns, and Contoso Java coding standards.

## Components

| Type | Name | Description |
|------|------|-------------|
| Agent | `contoso-backend-java` | Java/Spring Boot development expert |
| Skill | `contoso-backend-java-maven-gradle` | Build tool management |
| Skill | `contoso-backend-java-jpa` | JPA entity, repository, and query patterns |
| Skill | `contoso-backend-java-exception-handling` | @ControllerAdvice and custom exception hierarchy |
| Hook | PreToolCall on `edit` | Enforces constructor injection and Contoso Java standards in `.java` files |

## Installation

```shell
copilot plugin install contoso-backend-java@contoso-marketplace
```

## What It Does

The **contoso-backend-java** agent enforces Contoso's Java standards:

- **Java 21+**: Records, sealed classes, pattern matching, virtual threads
- **Spring Boot 3.x**: Layered architecture (Controller → Service → Repository)
- **Constructor injection only** — no `@Autowired` on fields
- **Lombok**: Only `@Slf4j`, `@Builder`, `@RequiredArgsConstructor` permitted
- **DTOs**: Java records for data transfer objects
- **Exception handling**: `@ControllerAdvice` with custom hierarchy extending `ContosoBaseException`
- **Build tools**: Maven for multi-module, Gradle (Kotlin DSL) for single-module
- **Testing**: JUnit 5 + Mockito + AssertJ, slice tests preferred over `@SpringBootTest`

> **See also**: [contoso-backend](../contoso-backend/) for general API conventions.
