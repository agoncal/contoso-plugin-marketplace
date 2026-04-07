---
name: contoso-backend-java-jpa
description: JPA entity design, repository patterns, and query optimization following Contoso Java standards
---

## JPA Skill

This skill provides patterns for implementing data access with JPA and Spring Data in Contoso Java services. Use this when designing entities, creating repositories, writing queries, or optimizing database access.

## Entity Design Rules

### Base Entity

All Contoso entities must extend the standard base entity or include these fields:

```java
@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
public abstract class ContosoBaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @CreatedDate
    @Column(nullable = false, updatable = false)
    private Instant createdAt;

    @LastModifiedDate
    @Column(nullable = false)
    private Instant updatedAt;

    @Version
    private Long version;
}
```

### Entity Conventions

1. **Use UUID for primary keys** — Never use auto-increment integers (they leak information and cause issues in distributed systems).

2. **Immutable IDs** — Mark `@Id` fields with `updatable = false`.

3. **Optimistic locking** — Always include `@Version` for entities that can be concurrently modified.

4. **Audit fields** — Use `@CreatedDate` and `@LastModifiedDate` with Spring Data JPA auditing.

5. **Enums as strings** — Use `@Enumerated(EnumType.STRING)`, never `EnumType.ORDINAL`.

6. **Lazy loading by default** — Use `FetchType.LAZY` for all `@OneToMany` and `@ManyToMany` relationships.

7. **No Lombok on entities** — Use explicit getters/setters on JPA entities (Lombok interferes with proxying).

### Entity Configuration

Use `@EntityTypeConfiguration` for mapping:

```java
@Configuration
public class UserEntityConfig implements EntityTypeConfiguration<User> {

    @Override
    public void configure(EntityTypeBuilder<User> builder) {
        builder.toTable("users");
        builder.property(User::getEmail).unique().nullable(false).length(255);
        builder.property(User::getStatus).enumerated(EnumType.STRING);
        builder.index("idx_users_email", User::getEmail);
    }
}
```

## Repository Patterns

### Standard Repository Interface

```java
public interface UserRepository extends JpaRepository<User, UUID> {

    Optional<User> findByEmail(String email);

    @Query("SELECT u FROM User u WHERE u.status = :status AND u.createdAt > :since")
    Page<User> findActiveUsersSince(
        @Param("status") UserStatus status,
        @Param("since") Instant since,
        Pageable pageable
    );

    boolean existsByEmail(String email);

    @Modifying
    @Query("UPDATE User u SET u.status = :status WHERE u.id = :id")
    int updateStatus(@Param("id") UUID id, @Param("status") UserStatus status);
}
```

### Repository Rules

1. **Return `Optional` for single results** — Never return `null` from repository methods.
2. **Use `Page` for paginated queries** — Pair with `Pageable` parameter.
3. **Use `@Query` for complex queries** — Derived method names are only for simple lookups (1-2 conditions).
4. **Use `@Modifying` for updates/deletes** — Annotate bulk operations explicitly.
5. **Projections for read-only queries** — Use interface projections or DTOs for queries that don't need full entities.

## Query Optimization

### N+1 Problem Prevention

```java
// BAD: N+1 queries
List<Order> orders = orderRepository.findAll();
orders.forEach(o -> o.getItems().size()); // triggers N queries

// GOOD: Join fetch
@Query("SELECT o FROM Order o JOIN FETCH o.items WHERE o.userId = :userId")
List<Order> findOrdersWithItems(@Param("userId") UUID userId);

// GOOD: Entity graph
@EntityGraph(attributePaths = {"items", "customer"})
List<Order> findByStatus(OrderStatus status);
```

### Pagination

```java
// Contoso standard: cursor-based via Spring Data
Pageable pageable = PageRequest.of(0, 25, Sort.by("createdAt").descending());
Page<User> page = userRepository.findByStatus(UserStatus.ACTIVE, pageable);
```

### Batch Operations

```java
// Configure batch size in application.yml
spring:
  jpa:
    properties:
      hibernate:
        jdbc:
          batch_size: 50
        order_inserts: true
        order_updates: true
```

## Testing

Use `@DataJpaTest` for repository tests:

```java
@DataJpaTest
@AutoConfigureTestDatabase(replace = Replace.NONE)
@Testcontainers
class UserRepositoryTest {

    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16");

    @Autowired
    private UserRepository userRepository;

    @Test
    void should_find_user_when_email_exists() {
        // Arrange
        User user = User.builder().email("jane@contoso.com").build();
        userRepository.save(user);

        // Act
        Optional<User> result = userRepository.findByEmail("jane@contoso.com");

        // Assert
        assertThat(result).isPresent();
        assertThat(result.get().getEmail()).isEqualTo("jane@contoso.com");
    }
}
```
