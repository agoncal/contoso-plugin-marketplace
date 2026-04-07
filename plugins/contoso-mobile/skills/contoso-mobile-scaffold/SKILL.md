---
name: contoso-mobile-scaffold
description: Mobile project scaffolding skill with React Native templates, navigation patterns, and CI/CD configuration.
---

## Mobile Scaffolding Skill

Use this skill when creating new mobile projects, adding features to existing apps, or setting up mobile infrastructure. Follow the templates and patterns below.

### React Native Project Template (TypeScript)

Initialize a new project with Contoso defaults:

```bash
npx react-native init ContosoApp --template react-native-template-typescript
cd ContosoApp
npm install @react-navigation/native @react-navigation/native-stack @react-navigation/bottom-tabs
npm install react-native-screens react-native-safe-area-context
npm install @sentry/react-native
npm install react-native-mmkv
npm install @shopify/flash-list
npm install expo-image
```

**tsconfig.json** — Strict TypeScript configuration:
```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": false,
    "baseUrl": ".",
    "paths": {
      "@core/*": ["src/core/*"],
      "@features/*": ["src/features/*"],
      "@shared/*": ["src/shared/*"],
      "@navigation/*": ["src/navigation/*"]
    }
  }
}
```

### Feature Module Structure

Every feature module follows this template:

```
src/features/{feature-name}/
├── components/
│   └── {FeatureName}Card.tsx
├── hooks/
│   └── use{FeatureName}.ts
├── screens/
│   └── {FeatureName}Screen.tsx
├── services/
│   └── {featureName}Service.ts
├── types.ts
└── index.ts
```

**index.ts** — Barrel export (public API):
```typescript
export { default as OrdersScreen } from './screens/OrdersScreen';
export { useOrders } from './hooks/useOrders';
export type { Order, OrderStatus } from './types';
```

**Screen template:**
```typescript
import React from 'react';
import { View, StyleSheet } from 'react-native';
import { FlashList } from '@shopify/flash-list';
import { useOrders } from '../hooks/useOrders';
import { OrderCard } from '../components/OrderCard';
import { ErrorBoundary } from '@shared/ErrorBoundary';

export default function OrdersScreen() {
  const { orders, isLoading, error, refetch } = useOrders();

  return (
    <ErrorBoundary fallback={<ErrorFallback onRetry={refetch} />}>
      <View style={styles.container}>
        <FlashList
          data={orders}
          renderItem={({ item }) => (
            <OrderCard
              order={item}
              accessibilityLabel={`Order ${item.id}, status ${item.status}`}
            />
          )}
          estimatedItemSize={120}
          onRefresh={refetch}
          refreshing={isLoading}
        />
      </View>
    </ErrorBoundary>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
});
```

### Navigation Setup Patterns

**RootNavigator.tsx:**
```typescript
import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { useAuth } from '@core/auth';
import { AuthNavigator } from './AuthNavigator';
import { MainTabNavigator } from './MainTabNavigator';
import { linking } from './linking';

export type RootStackParamList = {
  Auth: undefined;
  Main: undefined;
};

const Stack = createNativeStackNavigator<RootStackParamList>();

export function RootNavigator() {
  const { isAuthenticated } = useAuth();

  return (
    <NavigationContainer linking={linking}>
      <Stack.Navigator screenOptions={{ headerShown: false }}>
        {isAuthenticated ? (
          <Stack.Screen name="Main" component={MainTabNavigator} />
        ) : (
          <Stack.Screen name="Auth" component={AuthNavigator} />
        )}
      </Stack.Navigator>
    </NavigationContainer>
  );
}
```

**MainTabNavigator.tsx:**
```typescript
import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { HomeScreen } from '@features/home';
import { OrdersScreen } from '@features/orders';
import { ProfileScreen } from '@features/profile';

const Tab = createBottomTabNavigator();

export function MainTabNavigator() {
  return (
    <Tab.Navigator
      screenOptions={{
        tabBarActiveTintColor: '#0078D4',
        tabBarInactiveTintColor: '#666',
        tabBarLabelStyle: { fontSize: 12 },
        tabBarStyle: { paddingBottom: 8, height: 60 },
        tabBarItemStyle: { minHeight: 44 }, // Accessibility: 44pt touch target
      }}
    >
      <Tab.Screen name="Home" component={HomeScreen} />
      <Tab.Screen name="Orders" component={OrdersScreen} />
      <Tab.Screen name="Profile" component={ProfileScreen} />
    </Tab.Navigator>
  );
}
```

### Offline-First Data Layer Pattern

```typescript
import { MMKV } from 'react-native-mmkv';
import NetInfo from '@react-native-community/netinfo';

const storage = new MMKV();
const CACHE_TTL = 5 * 60 * 1000; // 5 minutes

interface CacheEntry<T> {
  data: T;
  timestamp: number;
}

export async function fetchWithCache<T>(
  key: string,
  fetcher: () => Promise<T>,
): Promise<T> {
  const cached = storage.getString(key);
  if (cached) {
    const entry: CacheEntry<T> = JSON.parse(cached);
    const isStale = Date.now() - entry.timestamp > CACHE_TTL;

    if (!isStale) return entry.data;

    // Stale-while-revalidate: return cached, refresh in background
    const netState = await NetInfo.fetch();
    if (netState.isConnected) {
      fetcher().then((fresh) => {
        storage.set(key, JSON.stringify({ data: fresh, timestamp: Date.now() }));
      });
    }
    return entry.data;
  }

  const data = await fetcher();
  storage.set(key, JSON.stringify({ data, timestamp: Date.now() }));
  return data;
}
```

### CI/CD Pipeline Configuration (Fastlane)

**fastlane/Fastfile:**
```ruby
default_platform(:ios)

platform :ios do
  desc "Build and distribute iOS beta"
  lane :beta do
    setup_ci
    match(type: "adhoc", readonly: true)
    build_app(
      scheme: "ContosoApp",
      workspace: "ios/ContosoApp.xcworkspace",
      export_method: "ad-hoc"
    )
    appcenter_upload(
      api_token: ENV["APPCENTER_API_TOKEN"],
      owner_name: "contoso",
      app_name: "ContosoApp-iOS",
      notify_testers: true
    )
  end
end

platform :android do
  desc "Build and distribute Android beta"
  lane :beta do
    gradle(
      project_dir: "android",
      task: "assemble",
      build_type: "Release"
    )
    appcenter_upload(
      api_token: ENV["APPCENTER_API_TOKEN"],
      owner_name: "contoso",
      app_name: "ContosoApp-Android",
      notify_testers: true
    )
  end
end
```

### Platform-Specific Configuration

**iOS — Info.plist required entries:**
- `NSAppTransportSecurity` — Enforce HTTPS. No `NSAllowsArbitraryLoads`.
- `UILaunchStoryboardName` — Required for all screen sizes.
- `CFBundleURLTypes` — For deep linking / universal links.
- Privacy usage descriptions for any device capabilities used.

**Android — build.gradle settings:**
```groovy
android {
    compileSdkVersion 34
    defaultConfig {
        minSdkVersion 28
        targetSdkVersion 34
    }
    buildTypes {
        release {
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

When scaffolding a new mobile project, always generate the full directory structure, navigation setup, core services, and CI/CD configuration. Ask the user which features to include in the initial scaffold.
