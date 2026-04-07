---
marp: true
theme: default
paginate: true
title: "Packaging AI Custom Files for the Enterprise"
description: >
  Copying Markdown files into each repository doesn't scale. In this presentation I'll show how
  enterprises can bundle customization files (agents, skills, and hooks) into versioned plugins,
  publish them to a marketplace, and let developer use them. Organization-wide standards becomes
  discoverable, maintainable and sharable.
author: Contoso Engineering
style: |
  section {
    font-family: 'Segoe UI', sans-serif;
  }
  h1 {
    color: #0078d4;
  }
  h2 {
    color: #333;
  }
  table {
    font-size: 0.85em;
  }
  code {
    background: #f0f0f0;
    padding: 2px 6px;
    border-radius: 3px;
  }
---

# Packaging AI Custom Files for the Enterprise

### How to bundle, version, and distribute
### agents, skills & hooks across your teams

---

## The Problem

You've built great AI customizations files:

- ✅ **Agents** that know your coding standards
- ✅ **Skills** that automate your workflows
- ✅ **Hooks** that enforce guardrails

But how do you **share them across all your projects and your developers**?

---

## Copy-Paste Doesn't Scale

Copying `.md` files into each repo works for **one project**.

**But what happens when you have shared standards?:**
- How do you **bundle** your custom files?
- How do you **version** your custom files?
- How do you **roll out** a new coding standard to all teams?
- How do developers **discover** available skills/agents/hooks?

---

## The Solution: Plugins

A **plugin** bundles agents, skills, and hooks into a **single installable package**.

```
contoso-ci-cd/
contoso-backend/
contoso-backend-java/
├── plugin.json              ← manifest (name, version, author)
├── agents/
│   ├── contoso-backend-java.agent.md
│   ├── contoso-backend-java-migrator.agent.md
│   └── contoso-backend-java-debugger.agent.md
├── skills/
│   ├── contoso-backend-java-maven-gradle/SKILL.md
│   ├── contoso-backend-java-jpa/SKILL.md
│   └── contoso-backend-java-exception-handling/SKILL.md
└── hooks.json               ← guardrails (auto-enforced)
```

Developers install with **one command**. No file copying.

---

## The Solution: Marketplace

A **marketplace** is a registry of plugins — like an app store for AI skills.

```json
{
  "name": "contoso-marketplace",
  "owner": { "name": "Contoso Engineering" },
  "plugins": [
    { "name": "contoso-code-review",  "version": "1.0.0" },
    { "name": "contoso-backend-java", "version": "1.0.0" },
    { "name": "contoso-ci-cd",        "version": "1.0.0" },
    ...
  ]
}
```

A single `marketplace.json` in a GitHub repo. That's it.

---

## How It Works in Copilot CLI

### 1️⃣ Add the marketplace (once)

```shell
copilot plugin marketplace add contoso/contoso-plugin-marketplace
```

### 2️⃣ Browse available plugins

```shell
copilot plugin marketplace browse contoso-marketplace
```

### 3️⃣ Install what's needed

```shell
copilot plugin install contoso-backend-java@contoso-marketplace
copilot plugin install contoso-ci-cd@contoso-marketplace
```

### 4️⃣ Plugins are active immediately

Agents, skills, and hooks are loaded in every Copilot CLI session.

---

## Lifecycle: Build → Publish → Consume

```
  ┌─────────────────┐     ┌─────────────────┐     ┌──────────────┐
  │      Author     │     │   Marketplace   │     │  Developer   │
  │ (Platform Team) │───▶│   (GitHub Repo) │───▶│  (Consumer)  │
  └─────────────────┘     └─────────────────┘     └──────────────┘

   • Create plugin        │  • marketplace.json   │  • Browse plugins
   • Write agents/skills  │  • Versioned plugins  │  • Install plugins
   • Bump version         │  • One central repo   │  • Manual-updates
```

⚠️ **Manual Updates**: bump the version in the marketplace, developers need to update `plugin update`.

---

# Demo Time 🚀

### What we'll show:

* Browsing the Contoso marketplace
* Using Copilot CLI to
  * Browse/Install Marketplace
  * Browse/Install Plugins
  * Checking agents, skills, and hooks
* Version plugin
* Check VS Code and Intellij IDEA support

---

## Key Benefits

| Without Marketplace | With Marketplace |
|--------------------|--------------------|
| Copy files across repos | `copilot plugin install` |
| "Which version of the skill am I using?" | Semantic versioning (1.0.0, 1.1.0, 2.0.0) |
| Standards drift between teams | One source of truth, auto-enforced by hooks |
| Developers don't know what's available | `copilot plugin marketplace browse` |
| Onboarding: "read the wiki" | Onboarding: install 3 plugins, you're ready |
| Updating 50 repos manually | Bump version once, teams pull the update |

---

# Packaging AI Custom Files for the Enterprise

### How to bundle, version, and distribute
### agents, skills & hooks across your teams

