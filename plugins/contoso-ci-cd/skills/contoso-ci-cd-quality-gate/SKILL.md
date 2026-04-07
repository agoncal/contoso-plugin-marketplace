---
name: contoso-ci-cd-quality-gate
description: Quality gate configuration and enforcement for CI/CD pipelines
---

## Quality Gate Skill

This skill provides patterns for configuring and enforcing quality gates in Contoso CI/CD pipelines. Use this when setting up automated checks, defining pass/fail thresholds, or integrating quality tools into pipelines.

## Contoso Quality Gate Standards

Every Contoso project must pass these quality gates before merging or deploying:

### Gate 1: Build

| Check | Threshold | Action on failure |
|-------|-----------|-------------------|
| Compilation | Zero errors | Block merge |
| Build time | < 15 minutes | Warn, investigate if > 10 min |
| Build warnings | Zero warnings (treat as errors) | Block merge |

### Gate 2: Testing

| Check | Threshold | Action on failure |
|-------|-----------|-------------------|
| Unit test pass rate | 100% | Block merge |
| Line coverage | ≥ 80% | Block merge |
| Branch coverage | ≥ 70% | Block merge |
| Critical path coverage | 100% (auth, payments) | Block merge |
| Integration tests | 100% pass | Block merge |
| Test execution time | < 10 minutes | Warn |

### Gate 3: Code Quality

| Check | Threshold | Action on failure |
|-------|-----------|-------------------|
| Linting errors | Zero | Block merge |
| Cyclomatic complexity | ≤ 10 per function | Block merge |
| Code duplication | < 3% | Warn |
| Technical debt ratio | < 5% | Warn |

### Gate 4: Security

| Check | Threshold | Action on failure |
|-------|-----------|-------------------|
| Critical vulnerabilities | Zero | Block merge |
| High vulnerabilities | Zero | Block merge |
| Medium vulnerabilities | < 5 | Warn |
| Secret detection | Zero secrets found | Block merge |
| SAST findings (critical) | Zero | Block merge |
| License compliance | No copyleft in production deps | Block merge |

### Gate 5: Deployment

| Check | Threshold | Action on failure |
|-------|-----------|-------------------|
| Smoke tests (staging) | 100% pass | Block production deploy |
| Performance regression | < 10% degradation | Warn |
| Error rate (canary) | < 1% | Auto-rollback |
| Latency (P99) | < 500ms | Warn |

## GitHub Actions Implementation

### Required Status Checks

Configure branch protection to require these checks:

```yaml
# .github/workflows/quality-gate.yml
name: Quality Gate
on:
  pull_request:
    branches: [main, develop]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build
        run: # build command
      - name: Check build warnings
        run: # fail if any warnings

  test:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run tests with coverage
        run: # test command
      - name: Check coverage thresholds
        run: |
          # Extract coverage percentage
          # Fail if line coverage < 80% or branch coverage < 70%

  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run linter
        run: # lint command --max-warnings=0

  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Dependency audit
        run: # audit command
      - name: Secret scanning
        run: # secret scan
      - name: License check
        run: # license compliance check
```

### Coverage Enforcement by Language

#### Java (JaCoCo)
```xml
<plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
    <executions>
        <execution>
            <id>check</id>
            <goals><goal>check</goal></goals>
            <configuration>
                <rules>
                    <rule>
                        <element>BUNDLE</element>
                        <limits>
                            <limit>
                                <counter>LINE</counter>
                                <value>COVEREDRATIO</value>
                                <minimum>0.80</minimum>
                            </limit>
                            <limit>
                                <counter>BRANCH</counter>
                                <value>COVEREDRATIO</value>
                                <minimum>0.70</minimum>
                            </limit>
                        </limits>
                    </rule>
                </rules>
            </configuration>
        </execution>
    </executions>
</plugin>
```

#### JavaScript/TypeScript (Vitest/Jest)
```json
{
  "coverageThreshold": {
    "global": {
      "lines": 80,
      "branches": 70,
      "functions": 75,
      "statements": 80
    }
  }
}
```

#### Python (pytest-cov)
```ini
# pyproject.toml
[tool.coverage.report]
fail_under = 80
```

#### .NET (coverlet)
```xml
<PropertyGroup>
    <CollectCoverage>true</CollectCoverage>
    <Threshold>80</Threshold>
    <ThresholdType>line</ThresholdType>
</PropertyGroup>
```

## Quality Gate Dashboard

Track and display these metrics over time:
- Coverage trend (should be stable or increasing)
- Build time trend (should be stable or decreasing)
- Security vulnerability count trend
- Technical debt ratio trend
- Test flakiness rate (should be < 1%)

## Exceptions Process

If a quality gate needs to be temporarily bypassed:
1. Create a ticket documenting the reason and remediation plan
2. Get approval from the team lead
3. Add a time-boxed exception (max 2 weeks)
4. Remove the exception once remediated
5. Never bypass security gates
