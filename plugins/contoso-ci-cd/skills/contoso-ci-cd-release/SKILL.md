---
name: contoso-ci-cd-release
description: Semantic versioning, changelog generation, and release management workflows
---

## Release Management Skill

This skill provides patterns for managing releases following Contoso's versioning and release standards. Use this when setting up release workflows, configuring automated versioning, or creating changelogs.

## Contoso Versioning Standards

### Semantic Versioning (SemVer)

All Contoso projects use Semantic Versioning 2.0.0:

```
MAJOR.MINOR.PATCH[-prerelease][+build]
```

| Change type | Version bump | Example | When |
|------------|-------------|---------|------|
| Breaking API change | MAJOR | 1.0.0 → 2.0.0 | Removing an endpoint, changing response format |
| New feature (backward compatible) | MINOR | 1.0.0 → 1.1.0 | Adding an endpoint, new optional field |
| Bug fix (backward compatible) | PATCH | 1.0.0 → 1.0.1 | Fixing validation logic, correcting a typo |

Pre-release tags:
- `1.2.0-alpha.1` — Early development, may be unstable
- `1.2.0-beta.1` — Feature complete, under testing
- `1.2.0-rc.1` — Release candidate, final validation

### Version Determination from Commits

Contoso uses Conventional Commits to automatically determine the version bump:

| Commit type | Version bump |
|------------|-------------|
| `fix:` | PATCH |
| `feat:` | MINOR |
| `feat!:` or `BREAKING CHANGE:` in footer | MAJOR |
| `docs:`, `style:`, `refactor:`, `test:`, `chore:`, `ci:` | No release |

## Changelog Generation

### CHANGELOG.md Format

```markdown
# Changelog

## [1.2.0] - 2024-06-15

### Added
- New user search endpoint with filtering (#123)
- Rate limiting on authentication endpoints (#145)

### Changed
- Improved error messages for validation failures (#134)

### Fixed
- Fix pagination cursor encoding for special characters (#156)
- Fix race condition in concurrent order creation (#162)

### Security
- Upgrade jackson-databind to address CVE-2024-XXXX (#170)
```

### Changelog Rules

1. **Categorize changes**: Added, Changed, Deprecated, Removed, Fixed, Security
2. **Reference issue/PR numbers** in every entry
3. **Write for the user** — Describe the impact, not the implementation
4. **Group related changes** under the same category
5. **Highlight breaking changes** prominently at the top of the release

## Release Workflow (GitHub Actions)

```yaml
name: Release
on:
  push:
    branches: [main]

permissions:
  contents: write
  pull-requests: write

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Determine version bump
        id: version
        # Analyze commits since last tag to determine MAJOR/MINOR/PATCH

      - name: Update version
        # Update version in package.json / pom.xml / pyproject.toml

      - name: Generate changelog
        # Generate changelog from conventional commits

      - name: Create GitHub Release
        uses: softprops/action-gh-release@v2
        with:
          tag_name: v${{ steps.version.outputs.new_version }}
          body_path: CHANGELOG.md
          generate_release_notes: true

      - name: Publish artifacts
        # Publish to npm / Maven Central / PyPI / NuGet
```

## Release Checklist

Before creating a release:

- [ ] All CI checks pass on the release branch
- [ ] CHANGELOG.md is up to date
- [ ] Version number is correct in all manifest files
- [ ] Breaking changes are documented with migration guides
- [ ] Security vulnerabilities are addressed
- [ ] Documentation is updated for new features
- [ ] Release notes reviewed by team lead

## Hotfix Process

```
1. Create hotfix branch from main: hotfix/CONT-XXXX-description
2. Apply the fix with appropriate tests
3. Bump PATCH version
4. Create PR to main AND develop
5. After merge to main, tag and release immediately
```

## Git Tags

```shell
# Annotated tags only (Contoso standard)
git tag -a v1.2.0 -m "Release v1.2.0: user search and rate limiting"
git push origin v1.2.0
```

Rules:
- Always use annotated tags (`-a`), never lightweight tags
- Prefix with `v`: `v1.2.0`, not `1.2.0`
- Include a summary message in the tag annotation
- Never delete or move a published tag
