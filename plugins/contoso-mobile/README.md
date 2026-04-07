# contoso-mobile

Mobile development — cross-platform patterns, performance optimization, and mobile-specific UI guidelines.

## Components

| Type | Name | Description |
|------|------|-------------|
| Agent | `contoso-mobile` | Mobile development expert for cross-platform apps |
| Skill | `contoso-mobile-scaffold` | Mobile project scaffolding |
| Hook | PreToolCall on `edit` | Enforces performance and accessibility in mobile source files |

## Installation

```shell
copilot plugin install contoso-mobile@contoso-marketplace
```

## What It Does

The **contoso-mobile** agent enforces Contoso's mobile standards:

- **Frameworks**: React Native (primary), Flutter (alternative)
- **Platform support**: iOS 16+, Android API 28+, phones and tablets
- **Performance**: FlatList/FlashList for lists, WebP images, Hermes engine, cold start < 2s
- **Offline-first**: Local storage (MMKV/WatermelonDB), sync queue, conflict resolution
- **Navigation**: React Navigation with stack, tab, and drawer patterns + deep linking
- **Accessibility**: 44pt touch targets, VoiceOver/TalkBack labels, dynamic type support
- **CI/CD**: Fastlane for builds, App Center for distribution, CodePush for JS updates
- **Error monitoring**: Sentry with crash-free rate alerts (< 99%)
- **Testing**: Vitest/Jest + React Native Testing Library (unit), Detox (E2E)
