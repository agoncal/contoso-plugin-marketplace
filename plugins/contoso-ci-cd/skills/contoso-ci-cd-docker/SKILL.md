---
name: contoso-ci-cd-docker
description: Dockerfile best practices and multi-stage build patterns for Contoso containerized applications
---

## Docker Skill

This skill provides patterns for writing Dockerfiles and container configurations following Contoso's container standards. Use this when containerizing applications, optimizing image sizes, or setting up container builds in CI/CD pipelines.

## Contoso Docker Standards

### Image Naming Convention

```
contoso.azurecr.io/{team}/{service}:{version}
```

Examples:
- `contoso.azurecr.io/platform/user-service:1.2.0`
- `contoso.azurecr.io/platform/user-service:latest`
- `contoso.azurecr.io/platform/user-service:sha-abc123`

Tags:
- **Semantic version** (`1.2.0`) — for releases
- **Git SHA** (`sha-abc123`) — for traceability
- **`latest`** — only in development, never in production deployments

### General Dockerfile Rules

1. **Use specific base image tags** — Never use `latest`. Pin to a specific version: `node:20.11-alpine3.19`.
2. **Use Alpine or distroless images** — Minimize attack surface and image size.
3. **Run as non-root** — Always create and switch to a non-root user.
4. **Use multi-stage builds** — Separate build dependencies from runtime.
5. **Order layers by change frequency** — Put rarely-changing layers first (OS packages, dependencies) and frequently-changing layers last (application code).
6. **Use `.dockerignore`** — Exclude `node_modules`, `.git`, `*.md`, `tests/`, and build artifacts.
7. **Set health checks** — Include `HEALTHCHECK` instruction.
8. **No secrets in images** — Never `COPY` or `ARG` secrets into the image. Use runtime environment variables or mounted secrets.

## Multi-Stage Build Templates

### Node.js / TypeScript

```dockerfile
# Stage 1: Dependencies
FROM node:20-alpine AS deps
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN corepack enable && pnpm install --frozen-lockfile

# Stage 2: Build
FROM node:20-alpine AS build
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN corepack enable && pnpm run build

# Stage 3: Production
FROM node:20-alpine AS production
WORKDIR /app
RUN addgroup -S contoso && adduser -S appuser -G contoso

COPY --from=build /app/dist ./dist
COPY --from=deps /app/node_modules ./node_modules
COPY package.json ./

USER appuser
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://localhost:3000/health/live || exit 1
CMD ["node", "dist/main.js"]
```

### Java / Spring Boot

```dockerfile
# Stage 1: Build
FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /app
COPY .mvn .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:resolve -q
COPY src ./src
RUN ./mvnw package -DskipTests -q

# Stage 2: Production
FROM eclipse-temurin:21-jre-alpine AS production
WORKDIR /app
RUN addgroup -S contoso && adduser -S appuser -G contoso

COPY --from=build /app/target/*.jar app.jar

USER appuser
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://localhost:8080/actuator/health/liveness || exit 1
ENTRYPOINT ["java", "-XX:+UseContainerSupport", "-XX:MaxRAMPercentage=75.0", "-jar", "app.jar"]
```

### Python / FastAPI

```dockerfile
# Stage 1: Dependencies
FROM python:3.12-slim AS deps
WORKDIR /app
RUN pip install poetry
COPY pyproject.toml poetry.lock ./
RUN poetry export -f requirements.txt --output requirements.txt --without-hashes

# Stage 2: Production
FROM python:3.12-slim AS production
WORKDIR /app
RUN groupadd -r contoso && useradd -r -g contoso appuser

COPY --from=deps /app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY src/ ./src/

USER appuser
EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=3s CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health/live')" || exit 1
CMD ["uvicorn", "src.app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### .NET / ASP.NET

```dockerfile
# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
WORKDIR /app
COPY *.sln .
COPY src/*/*.csproj ./
RUN for f in *.csproj; do mkdir -p "src/${f%.csproj}" && mv "$f" "src/${f%.csproj}/"; done
RUN dotnet restore
COPY src/ ./src/
RUN dotnet publish src/API/API.csproj -c Release -o /publish

# Stage 2: Production
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS production
WORKDIR /app
RUN addgroup -S contoso && adduser -S appuser -G contoso

COPY --from=build /publish .

USER appuser
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://localhost:8080/health/live || exit 1
ENTRYPOINT ["dotnet", "API.dll"]
```

## .dockerignore Template

```
.git
.github
.vscode
.idea
*.md
LICENSE
docs/
tests/
node_modules/
dist/
target/
bin/
obj/
__pycache__/
.env
.env.*
docker-compose*.yml
```
