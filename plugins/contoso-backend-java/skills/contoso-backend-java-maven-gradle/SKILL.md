---
name: contoso-backend-java-maven-gradle
description: Maven and Gradle build tool management — POM structure, build scripts, dependency management, and multi-module patterns
---

## Contoso Build Tool Management Skill

This skill provides guidance for managing Java projects using Maven and Gradle following Contoso's build standards. Use this skill when setting up new projects, managing dependencies, configuring builds, or structuring multi-module projects.

## When to Use Which Build Tool

Per Contoso standards:
- **Maven** — use for multi-module projects, enterprise services, and projects with complex dependency trees.
- **Gradle (Kotlin DSL)** — use for single-module projects, libraries, and projects requiring custom build logic.

Always use the wrapper (`mvnw` / `gradlew`) — never require a globally installed build tool.

## Maven POM Structure

A Contoso-standard parent POM for multi-module projects:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0">
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.3.0</version>
    </parent>

    <groupId>com.contoso</groupId>
    <artifactId>service-parent</artifactId>
    <version>1.0.0-SNAPSHOT</version>
    <packaging>pom</packaging>

    <modules>
        <module>api</module>
        <module>service</module>
        <module>repository</module>
        <module>common</module>
    </modules>

    <properties>
        <java.version>21</java.version>
        <lombok.version>1.18.32</lombok.version>
        <mapstruct.version>1.5.5.Final</mapstruct.version>
        <testcontainers.version>1.19.8</testcontainers.version>
    </properties>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.testcontainers</groupId>
                <artifactId>testcontainers-bom</artifactId>
                <version>${testcontainers.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>
</project>
```

Rules:
- Always inherit from `spring-boot-starter-parent` for Spring Boot projects.
- Use `<dependencyManagement>` for centralizing dependency versions. Child modules should not declare versions.
- Use BOM imports for dependency families (Testcontainers, Spring Cloud, Jackson).
- Use `<properties>` for version variables. Name them `{artifact}.version`.

## Gradle Kotlin DSL Structure

A Contoso-standard `build.gradle.kts` for single-module projects:

```kotlin
plugins {
    java
    id("org.springframework.boot") version "3.3.0"
    id("io.spring.dependency-management") version "1.1.5"
}

group = "com.contoso"
version = "1.0.0-SNAPSHOT"

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("org.springframework.boot:spring-boot-starter-data-jpa")
    compileOnly("org.projectlombok:lombok")
    annotationProcessor("org.projectlombok:lombok")

    testImplementation("org.springframework.boot:spring-boot-starter-test")
    testImplementation("org.testcontainers:junit-jupiter")
}
```

Use version catalogs (`gradle/libs.versions.toml`) for dependency management:

```toml
[versions]
spring-boot = "3.3.0"
lombok = "1.18.32"
testcontainers = "1.19.8"

[libraries]
spring-boot-web = { module = "org.springframework.boot:spring-boot-starter-web", version.ref = "spring-boot" }
lombok = { module = "org.projectlombok:lombok", version.ref = "lombok" }

[plugins]
spring-boot = { id = "org.springframework.boot", version.ref = "spring-boot" }
```

## Dependency Management Best Practices

- **Pin all versions** — never use dynamic versions (`+`, `latest.release`, `SNAPSHOT` for releases).
- **Use BOMs** for coordinated dependency sets to avoid version conflicts.
- **Scope dependencies correctly**: `compile`/`implementation` for production, `test`/`testImplementation` for tests, `compileOnly` for compile-time-only (Lombok, annotation processors).
- **Run dependency checks** regularly: `mvn versions:display-dependency-updates` or `gradle dependencyUpdates`.
- **Exclude transitive conflicts** explicitly rather than relying on resolution strategies.

## Multi-Module Project Structure

Contoso's standard multi-module layout:

```
service-parent/
├── pom.xml                   # Parent POM
├── api/                      # Controllers, DTOs, OpenAPI specs
│   └── pom.xml
├── service/                  # Business logic, domain services
│   └── pom.xml
├── repository/               # Data access, entities, migrations
│   └── pom.xml
└── common/                   # Shared utilities, exceptions, constants
    └── pom.xml
```

Dependencies flow downward: `api → service → repository → common`. Never create circular dependencies between modules.

## Profile Configuration

Maven profiles for Contoso environments:

```xml
<profiles>
    <profile>
        <id>dev</id>
        <activation>
            <activeByDefault>true</activeByDefault>
        </activation>
        <properties>
            <spring.profiles.active>dev</spring.profiles.active>
        </properties>
    </profile>
    <profile>
        <id>staging</id>
        <properties>
            <spring.profiles.active>staging</spring.profiles.active>
        </properties>
    </profile>
    <profile>
        <id>prod</id>
        <properties>
            <spring.profiles.active>prod</spring.profiles.active>
        </properties>
    </profile>
</profiles>
```

## Essential Maven Plugins

Include these plugins in every Contoso Java project:
- `maven-compiler-plugin` — set source/target to 21, configure annotation processors
- `maven-surefire-plugin` — unit test execution
- `maven-failsafe-plugin` — integration test execution
- `jacoco-maven-plugin` — code coverage with 80% minimum threshold
- `maven-enforcer-plugin` — enforce dependency convergence and minimum Java version
- `spring-boot-maven-plugin` — build executable JARs with layered packaging
