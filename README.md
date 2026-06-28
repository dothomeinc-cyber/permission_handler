

```markdown
# Permission Handler Package

[![pub package](https://img.shields.io/pub/v/permission_handler_package.svg)](https://pub.dev/packages/permission_handler_package)
[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Riverpod](https://img.shields.io/badge/State%20Management-Riverpod-25B6FF)](https://riverpod.dev)
[![Google Fonts](https://img.shields.io/badge/Fonts-Google%20Fonts-4285F4)](https://fonts.google.com)
[![Permission Handler](https://img.shields.io/badge/Permission%20Handler-11.3.0+-green)](https://pub.dev/packages/permission_handler)

A professional Flutter package for handling permissions automatically with **Riverpod** state management, **beautiful UI dialogs**, **permanent denial detection**, **smart permission builder**, and **ScreenUtil** responsive design.

---

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Platform Configuration](#platform-configuration)
  - [Android Setup](#android-setup)
  - [iOS Setup](#ios-setup)
- [Initialization](#initialization)
- [Quick Start](#quick-start)
- [Permission Types & Groups](#permission-types--groups)
  - [Complete Permission Types](#complete-permission-types)
  - [Permission Groups](#permission-groups)
  - [Platform Support Matrix](#platform-support-matrix)
- [Usage Examples](#usage-examples)
  - [1. Request Single Permission](#1-request-single-permission)
  - [2. Request Permission Group](#2-request-permission-group)
  - [3. Permission Wrapper Widget](#3-permission-wrapper-widget)
  - [4. Reactive Permission Builder (Smart)](#4-reactive-permission-builder-smart)
  - [5. Check Permission Status](#5-check-permission-status)
  - [6. Listen to Permission Changes](#6-listen-to-permission-changes)
  - [7. Multiple Permissions with Groups](#8-multiple-permissions-with-groups)
  - [8. Check Group Permission Status](#9-check-group-permission-status)
  - [9. Conditional UI Based on Permissions](#10-conditional-ui-based-on-permissions)
  - [10. Smart Request (Request If Needed)](#11-smart-request-request-if-needed)
  - [11. Reset Permission State](#12-reset-permission-state)
  - [12. Open App Settings](#13-open-app-settings)
  - [13. Clear Permission Cache](#14-clear-permission-cache)
- [API Reference](#api-reference)
  - [PermissionActionNotifier Methods](#permissionactionnotifier-methods)
  - [PermissionManager Methods](#permissionmanager-methods)
  - [PermissionResult Properties](#permissionresult-properties)
  - [PermissionGroup Properties](#permissiongroup-properties)
  - [Widgets](#widgets)
  - [Providers](#providers)
- [Advanced Features](#advanced-features)
  - [Automatic Cache Management](#automatic-cache-management)
  - [Lifecycle Gap Handling](#lifecycle-gap-handling)
  - [Permission Change Listening](#permission-change-listening)
  - [Platform-Specific Notes](#platform-specific-notes)
  - [Permanent Denial Detection](#permanent-denial-detection)
- [Customization](#customization)
  - [Custom Theme Integration](#custom-theme-integration)
  - [Custom Loading Widget](#custom-loading-widget)
  - [Custom Denied Widget](#custom-denied-widget)
  - [Override Default Permission Card](#override-default-permission-card)
- [Cheatsheet](#cheatsheet)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)
- [License](#license)

---

## Features

| Feature | Description |
|---|---|
| **Automatic Permission Handling** | Request and manage permissions seamlessly |
| **Riverpod Integration** | Reactive state management with Riverpod |
| **Permanent Denial Detection** | Handles permanently denied permissions with settings redirection |
| **System Settings Navigation** | One-click redirect to app settings |
| **Beautiful UI Dialogs** | Customizable, theme-aware permission dialogs |
| **Smart Permission Builder** | Automatically shows permission card or open settings based on denial state |
| **Permission Wrapper** | Easy-to-use widget wrapper for protected screens |
| **Reactive Permission Builder** | Real-time permission status updates with built-in UI |
| **Responsive Design** | Built with ScreenUtil for responsive layouts |
| **Custom Theme Support** | Integrates with your existing theme |
| **Cross-Platform** | Fully supports both iOS and Android |
| **Zero Configuration** | Works out of the box with sensible defaults |
| **Type Safety** | Full Dart type safety with enum-based permissions |
| **Permission Groups** | Request multiple related permissions at once |
| **Platform-Specific Support** | Automatically handles iOS/Android differences |
| **Automatic Cache Management** | 3-second TTL cache with auto-invalidation on app resume |
| **Lifecycle Gap Handling** | Safe operation queuing before WidgetsBinding is ready |
| **Permission Change Listening** | Real-time stream of permission status changes |
| **Automatic Permanent Denial Handling** | Auto-redirects to settings when permission is permanently denied |
| **Context-Aware Permission Card** | Permission denied card that detects permanent denial and shows appropriate action |

---

## Installation

Add to `pubspec.yaml`:

```yaml
dependencies:
  permission_handler_package: ^1.0.0
```

Then run:

```bash
flutter pub get
```

**Required dependencies (auto-included):**

```yaml
permission_handler: ^11.3.0     # Platform permission handling
riverpod: ^2.4.0                # State management
flutter_riverpod: ^2.4.0        # Riverpod for Flutter
flutter_screenutil: ^5.9.0      # Responsive design
google_fonts: ^6.1.0            # Google Fonts support
```

---

## Platform Configuration

### Android Setup

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- Storage & Media -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />

    <!-- Camera -->
    <uses-permission android:name="android.permission.CAMERA" />

    <!-- Location -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />

    <!-- Microphone -->
    <uses-permission android:name="android.permission.RECORD_AUDIO" />

    <!-- Contacts -->
    <uses-permission android:name="android.permission.READ_CONTACTS" />
    <uses-permission android:name="android.permission.WRITE_CONTACTS" />

    <!-- Phone & SMS -->
    <uses-permission android:name="android.permission.READ_PHONE_STATE" />
    <uses-permission android:name="android.permission.CALL_PHONE" />
    <uses-permission android:name="android.permission.SEND_SMS" />
    <uses-permission android:name="android.permission.READ_SMS" />
    <uses-permission android:name="android.permission.RECEIVE_SMS" />

    <!-- Notifications (Android 13+) -->
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />

    <!-- Calendar -->
    <uses-permission android:name="android.permission.READ_CALENDAR" />
    <uses-permission android:name="android.permission.WRITE_CALENDAR" />

    <!-- Sensors -->
    <uses-permission android:name="android.permission.BODY_SENSORS" />

    <!-- Bluetooth -->
    <uses-permission android:name="android.permission.BLUETOOTH" />
    <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
    <uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />

    <!-- App-specific -->
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
    <uses-permission android:name="android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS" />
    <uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />
    <uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES" />

    <application
        android:requestLegacyExternalStorage="true"
        ...>
    </application>

</manifest>
```

### iOS Setup

Add to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to take photos and scan documents</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to save and share images</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>This app needs permission to save photos to your library</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to find nearby places</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs location access for background updates and notifications</string>

<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access for voice recording and calls</string>

<key>NSContactsUsageDescription</key>
<string>This app needs contact access to share with friends and family</string>

<key>NSCalendarsUsageDescription</key>
<string>This app needs calendar access to schedule events and reminders</string>

<key>NSRemindersUsageDescription</key>
<string>This app needs reminders access to set notifications</string>

<key>NSBluetoothAlwaysUsageDescription</key>
<string>This app needs bluetooth access to connect to nearby devices</string>

<key>NSUserTrackingUsageDescription</key>
<string>This app needs tracking permission to provide personalized ads</string>

<key>UIBackgroundModes</key>
<array>
    <string>location</string>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

---

## Initialization

Initialize the package **before** `runApp()`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Required: initialize the permission handler package
  await PermissionHandler.initialize();

  runApp(const ProviderScope(child: MyApp()));
}
```

> **Why this is required:** `PermissionHandler.initialize()` sets up the `AppLifecycleObserver` that auto-refreshes the permission cache when the app returns from background (e.g., after the user changes permissions in device settings). Skipping this means stale cache won't be invalidated on resume.

---

## Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler_package/permission_handler_package.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PermissionHandler.initialize();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Permission Demo',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const SplashScreen(),
        );
      },
    );
  }
}

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializePermissions();
  }

  Future<void> _initializePermissions() async {
    final actionNotifier = ref.read(permissionActionProvider.notifier);

    final granted = await actionNotifier.initializeRequiredPermissions(
      context: context,
      requiredPermissions: [
        PermissionType.camera,
        PermissionType.storage,
        PermissionType.location,
      ],
      title: 'Welcome to the App',
      message: 'We need these permissions to provide you with the best experience.',
    );

    if (granted && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
```

---

## Permission Types & Groups

### Complete Permission Types

| Permission Type | Display Name | Platform | Description |
|---|---|---|---|
| `PermissionType.camera` | Camera | Both | Camera access for photos/videos |
| `PermissionType.storage` | Storage | Both | Read/write external storage |
| `PermissionType.photos` | Photos | iOS only | Access photo library |
| `PermissionType.videos` | Videos | iOS only | Access video library |
| `PermissionType.audio` | Audio | iOS only | Access audio/music files |
| `PermissionType.location` | Location | Both | Fine and coarse location |
| `PermissionType.locationAlways` | Location (Always) | Both | Always location access |
| `PermissionType.locationWhenInUse` | Location (While Using) | Both | Location only when app is open |
| `PermissionType.microphone` | Microphone | Both | Audio recording access |
| `PermissionType.contacts` | Contacts | Both | Read/write contacts |
| `PermissionType.notifications` | Notifications | Both | Push notifications |
| `PermissionType.calendarWriteOnly` | Calendar (Write Only) | Both | Write-only calendar access |
| `PermissionType.calendarFullAccess` | Calendar (Full Access) | Both | Full calendar access |
| `PermissionType.reminders` | Reminders | iOS only | Reminders access |
| `PermissionType.bluetooth` | Bluetooth | Both | Bluetooth connectivity |
| `PermissionType.sensors` | Sensors | Both | Body sensors / health data |
| `PermissionType.sms` | SMS | Android only | Send/receive SMS |
| `PermissionType.phone` | Phone | Android only | Make phone calls |
| `PermissionType.appTrackingTransparency` | App Tracking | iOS only | App tracking permission |
| `PermissionType.criticalAlerts` | Critical Alerts | iOS only | Critical alerts |
| `PermissionType.scheduleExactAlarm` | Exact Alarms | Android only | Schedule exact alarms |
| `PermissionType.ignoreBatteryOptimizations` | Battery Optimization | Android only | Ignore battery optimization |
| `PermissionType.manageExternalStorage` | External Storage | Android only | Manage external storage |
| `PermissionType.systemAlertWindow` | System Alerts | Android only | Draw over other apps |
| `PermissionType.requestInstallPackages` | Install Packages | Android only | Install unknown apps |
| `PermissionType.accessNotificationPolicy` | Notification Policy | Android only | Do Not Disturb access |

### Permission Groups

| Group | Display Name | Permissions Included |
|---|---|---|
| `PermissionGroup.media` | Media & Files | `storage`, `photos`, `videos`, `audio` |
| `PermissionGroup.communication` | Communication | `camera`, `microphone`, `contacts` |
| `PermissionGroup.locationServices` | Location Services | `location`, `locationAlways`, `locationWhenInUse` |
| `PermissionGroup.calendar` | Calendar | `calendarWriteOnly`, `calendarFullAccess`, `reminders` |
| `PermissionGroup.bluetooth` | Bluetooth | `bluetooth` |
| `PermissionGroup.sensors` | Sensors | `sensors` |
| `PermissionGroup.phone` | Phone | `phone`, `sms` |
| `PermissionGroup.other` | Other Permissions | *(platform-specific extras)* |

### Platform Support Matrix

| Permission | iOS | Android |
|---|---|---|
| `camera` | ✅ | ✅ |
| `storage` | ⚠️ Limited | ✅ |
| `photos` | ✅ | ❌ |
| `videos` | ✅ | ❌ |
| `audio` | ✅ | ❌ |
| `location` | ✅ | ✅ |
| `microphone` | ✅ | ✅ |
| `contacts` | ✅ | ✅ |
| `notifications` | ✅ | ✅ |
| `calendarWriteOnly` | ✅ | ✅ |
| `calendarFullAccess` | ✅ | ✅ |
| `reminders` | ✅ | ❌ |
| `bluetooth` | ✅ | ✅ |
| `sensors` | ✅ | ✅ |
| `sms` | ❌ | ✅ |
| `phone` | ❌ | ✅ |

---

## Usage Examples

### 1. Request Single Permission

```dart
class CameraButton extends ConsumerWidget {
  const CameraButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final actionNotifier = ref.read(permissionActionProvider.notifier);
        final result = await actionNotifier.requestSinglePermission(
          PermissionType.camera,
          context: context, // optional: pass context for auto dialogs
        );

        if (result.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Camera ready!')),
          );
        }
      },
      child: const Text('Open Camera'),
    );
  }
}
```

### 2. Request Permission Group

```dart
class CommunicationButton extends ConsumerWidget {
  const CommunicationButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final actionNotifier = ref.read(permissionActionProvider.notifier);
        final results = await actionNotifier.requestPermissionGroup(
          PermissionGroup.communication,
          context: context,
        );

        final allGranted = results.values.every((r) => r.isGranted);
        if (allGranted) {
          print('All communication permissions granted!');
        }
      },
      child: const Text('Request Communication Permissions'),
    );
  }
}
```

### 3. Permission Wrapper Widget

```dart
class ProtectedScreen extends StatelessWidget {
  const ProtectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PermissionWrapper(
      requiredPermissions: [PermissionType.camera, PermissionType.storage],
      title: 'Permissions Required',
      message: 'This screen needs camera and storage access to function',
      onPermissionsGranted: () => print('Granted!'),
      onPermissionsDenied: () => print('Denied!'),
      child: Scaffold(
        appBar: AppBar(title: const Text('Camera Screen')),
        body: const CameraWidget(),
      ),
    );
  }
}
```

### 4. Reactive Permission Builder (Smart)

The `PermissionBuilder` automatically handles both denied and permanently denied states:

```dart
class CameraFeature extends ConsumerWidget {
  const CameraFeature({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PermissionBuilder(
      permission: PermissionType.camera,
      builder: (context, isGranted) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isGranted ? Icons.camera_alt : Icons.camera_alt_outlined,
              size: 80,
              color: isGranted ? Colors.green : Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              isGranted ? 'Camera Ready' : 'Camera Permission Required',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            ElevatedButton(
              onPressed: isGranted ? () => _openCamera() : null,
              child: const Text('Take Photo'),
            ),
          ],
        );
      },
    );
  }

  void _openCamera() {}
}
```

**When permission is denied** (not permanent), the PermissionBuilder shows:
- Lock icon with "Camera Required" title
- Permission description
- "Allow Permission" button that triggers the permission flow

**When permission is permanently denied**, it shows:
- Block icon with "Camera Blocked" title
- Message about enabling in settings
- "Open Settings" button that redirects to app settings

### 5. Check Permission Status

```dart
class PermissionStatusWidget extends ConsumerWidget {
  const PermissionStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraStatus = ref.watch(
      permissionStatusProvider(PermissionType.camera),
    );

    return cameraStatus.when(
      data: (isGranted) => ListTile(
        leading: Icon(
          isGranted ? Icons.check_circle : Icons.block,
          color: isGranted ? Colors.green : Colors.red,
        ),
        title: const Text('Camera'),
        trailing: Text(isGranted ? 'Granted' : 'Denied'),
      ),
      loading: () => const ListTile(
        leading: CircularProgressIndicator(),
        title: Text('Loading...'),
      ),
      error: (_, __) => const ListTile(
        leading: Icon(Icons.error, color: Colors.red),
        title: Text('Error'),
      ),
    );
  }
}
```

### 6. Listen to Permission Changes

```dart
class PermissionListener extends ConsumerStatefulWidget {
  const PermissionListener({super.key});

  @override
  ConsumerState<PermissionListener> createState() => _PermissionListenerState();
}

class _PermissionListenerState extends ConsumerState<PermissionListener> {
  @override
  void initState() {
    super.initState();
    _listenToPermissionChanges();
  }

  void _listenToPermissionChanges() {
    final manager = ref.read(permissionManagerProvider);

    manager.onPermissionChanged.listen((event) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${event.permission.displayName} permission '
              '${event.result.isGranted ? "granted" : "denied"}',
            ),
            backgroundColor: event.result.isGranted ? Colors.green : Colors.red,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) => Container();
}
```

### 7. Multiple Permissions with Groups

```dart
class MultiplePermissionsScreen extends ConsumerWidget {
  const MultiplePermissionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multiple Permissions')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final actionNotifier = ref.read(permissionActionProvider.notifier);

            final granted = await actionNotifier.initializeRequiredPermissions(
              context: context,
              requiredPermissions: [
                PermissionType.camera,
                PermissionType.microphone,
              ],
              requiredGroups: [
                PermissionGroup.locationServices,
                PermissionGroup.media,
              ],
              title: 'Permissions Required',
              message: 'This app needs various permissions to function properly.',
            );

            if (granted && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All permissions granted!')),
              );
            }
          },
          child: const Text('Request All Permissions'),
        ),
      ),
    );
  }
}
```

### 8. Check Group Permission Status

```dart
class GroupStatusWidget extends ConsumerWidget {
  const GroupStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaGroupStatus = ref.watch(
      permissionGroupStatusProvider(PermissionGroup.media),
    );

    return mediaGroupStatus.when(
      data: (allGranted) => Card(
        child: ListTile(
          leading: Icon(
            allGranted ? Icons.check_circle : Icons.warning,
            color: allGranted ? Colors.green : Colors.orange,
          ),
          title: const Text('Media Permissions'),
          subtitle: Text(allGranted ? 'All granted' : 'Some permissions missing'),
          trailing: allGranted
              ? const Icon(Icons.check, color: Colors.green)
              : ElevatedButton(
                  onPressed: () => _requestMediaPermissions(ref),
                  child: const Text('Grant All'),
                ),
        ),
      ),
      loading: () => const Card(child: ListTile(title: Text('Loading...'))),
      error: (_, __) => const Card(child: ListTile(title: Text('Error'))),
    );
  }

  Future<void> _requestMediaPermissions(WidgetRef ref) async {
    final actionNotifier = ref.read(permissionActionProvider.notifier);
    await actionNotifier.requestPermissionGroup(PermissionGroup.media);
    ref.invalidate(permissionGroupStatusProvider(PermissionGroup.media));
  }
}
```

### 9. Conditional UI Based on Permissions

```dart
class ConditionalUI extends ConsumerWidget {
  const ConditionalUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraGranted =
        ref.watch(permissionStatusProvider(PermissionType.camera));
    final microphoneGranted =
        ref.watch(permissionStatusProvider(PermissionType.microphone));

    return Column(
      children: [
        if (cameraGranted.value == true)
          const CameraWidget()
        else
          const PermissionBuilder(
            permission: PermissionType.camera,
            builder: (context, granted) => SizedBox(),
          ),
        if (microphoneGranted.value == true)
          const MicrophoneWidget()
        else
          const PermissionBuilder(
            permission: PermissionType.microphone,
            builder: (context, granted) => SizedBox(),
          ),
      ],
    );
  }
}
```

### 10. Smart Request (Request If Needed)

```dart
class SmartCameraButton extends ConsumerWidget {
  const SmartCameraButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final actionNotifier = ref.read(permissionActionProvider.notifier);

        // Only shows the system dialog if permission is not already granted
        final result = await actionNotifier.requestIfNeeded(
          PermissionType.camera,
          context: context,
        );

        if (result.isGranted) {
          _openCamera();
        } else {
          _showPermissionDeniedMessage();
        }
      },
      child: const Text('Open Camera'),
    );
  }

  void _openCamera() {}
  void _showPermissionDeniedMessage() {}
}
```

### 11. Reset Permission State

```dart
class ResetPermissionsButton extends ConsumerWidget {
  const ResetPermissionsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        ref.read(permissionActionProvider.notifier).reset();

        // Optionally invalidate individual providers
        ref.invalidate(permissionStateProvider);
        ref.invalidate(permissionStatusProvider(PermissionType.camera));
        ref.invalidate(permissionStatusProvider(PermissionType.storage));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission state reset')),
        );
      },
      child: const Text('Reset Permission State'),
    );
  }
}
```

### 12. Open App Settings

```dart
class OpenSettingsButton extends ConsumerWidget {
  const OpenSettingsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final manager = ref.read(permissionManagerProvider);
        await manager.openAppSettings();
      },
      child: const Text('Open App Settings'),
    );
  }
}
```

### 13. Clear Permission Cache

```dart
class ClearCacheButton extends ConsumerWidget {
  const ClearCacheButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            final manager = ref.read(permissionManagerProvider);
            manager.clearCache(PermissionType.camera);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Camera cache cleared')),
            );
          },
          child: const Text('Clear Camera Cache'),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            final manager = ref.read(permissionManagerProvider);
            manager.clearAllCache();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('All cache cleared')),
            );
          },
          child: const Text('Clear All Cache'),
        ),
      ],
    );
  }
}
```

---

## API Reference

### PermissionActionNotifier Methods

| Method | Parameters | Returns | Description |
|---|---|---|---|
| `initializeRequiredPermissions()` | `context`, `requiredPermissions`, `requiredGroups?`, `showInitialScreen?`, `title?`, `message?` | `Future<bool>` | Initialize and request all required permissions |
| `requestSinglePermission()` | `permission`, `context?` | `Future<PermissionResult>` | Request a single permission |
| `requestPermissionGroup()` | `group`, `context?` | `Future<Map<PermissionType, PermissionResult>>` | Request all permissions in a group |
| `requestIfNeeded()` | `permission`, `context?` | `Future<PermissionResult>` | Request only if permission is not already granted |
| `autoInitialize()` | — | `Future<void>` | Auto-initialize and cache all permission statuses |
| `reset()` | — | `void` | Reset permission state and clear all cache |

### PermissionManager Methods

| Method | Parameters | Returns | Description |
|---|---|---|---|
| `checkPermissionsStatus()` | `List<PermissionType>`, `bypassCache?` | `Future<Map<PermissionType, PermissionResult>>` | Check status of multiple permissions |
| `requestPermission()` | `PermissionType`, `context?` | `Future<PermissionResult>` | Request a single permission |
| `requestPermissions()` | `List<PermissionType>`, `context?` | `Future<Map<PermissionType, PermissionResult>>` | Request multiple permissions |
| `requestPermissionWithExplanation()` | `PermissionType`, `context?`, `showExplanation?` | `Future<PermissionResult>` | Request with optional explanation dialog |
| `requestPermissionGroup()` | `PermissionGroup`, `context?` | `Future<Map<PermissionType, PermissionResult>>` | Request a permission group |
| `openAppSettings()` | — | `Future<void>` | Open app settings page |
| `isPermissionGranted()` | `PermissionType` | `Future<bool>` | Check if a permission is granted |
| `isPermissionPermanentlyDenied()` | `PermissionType` | `Future<bool>` | Check if permanently denied |
| `checkGroupPermissionsStatus()` | `List<PermissionGroup>` | `Future<Map<PermissionGroup, bool>>` | Check group permissions status |
| `isGroupSupported()` | `PermissionGroup` | `bool` | Check if group is supported on the current platform |
| `getPlatformNote()` | `PermissionType` | `String` | Get a platform-specific note for a permission |
| `clearCache()` | `PermissionType` | `void` | Clear cache for a specific permission |
| `clearAllCache()` | — | `void` | Clear all cached permission results |
| `registerNavigatorKey()` | `GlobalKey<NavigatorState>` | `void` | Register a navigator key for context finding |
| `unregisterNavigatorKey()` | `GlobalKey<NavigatorState>` | `void` | Unregister a navigator key |
| `setCurrentContext()` | `BuildContext` | `void` | Set current context manually |
| `getCurrentContext()` | — | `BuildContext?` | Get the current context |
| `markInitialized()` | — | `void` | Mark manager as initialized |
| `dispose()` | — | `void` | Dispose the manager |

### PermissionResult Properties

| Property | Type | Description |
|---|---|---|
| `permission` | `PermissionType` | The permission type |
| `isGranted` | `bool` | Whether permission is granted |
| `isPermanentlyDenied` | `bool` | Whether permanently denied |
| `status` | `PermissionStatus` | Raw permission status from `permission_handler` |
| `timestamp` | `DateTime` | When the result was created |
| `isDenied` | `bool` | Whether permission is denied |
| `isLimited` | `bool` | Whether permission is limited (iOS) |
| `isRestricted` | `bool` | Whether permission is restricted (iOS) |

### PermissionGroup Properties

| Property | Type | Description |
|---|---|---|
| `displayName` | `String` | User-friendly group name |
| `icon` | `String` | Emoji icon for the group |
| `permissions` | `List<PermissionType>` | All permissions belonging to the group |

### Widgets

| Widget | Purpose |
|---|---|
| `PermissionWrapper` | Wraps any widget tree behind a permission gate; handles loading and denied states automatically |
| `PermissionBuilder` | Rebuilds UI reactively based on a single permission's status; automatically shows permission card for denied state and open settings for permanently denied |
| `PermissionInitialDialog` | Dialog shown on the first permission request — lists all required permissions with icons |
| `PermissionDeniedDialog` | Dialog shown when a permission is denied. |
| `PermissionPermanentDialog` | Dialog shown when a permission is permanently denied — prompts user to open device settings |

### Providers

| Provider | Type | Description |
|---|---|---|
| `permissionManagerProvider` | `Provider<PermissionManager>` | Provides the `PermissionManager` singleton (no auto-dispose - singleton) |
| `permissionStateProvider` | `ChangeNotifierProvider<PermissionNotifier>` | Reactive permission state map across the app |
| `permissionActionProvider` | `StateNotifierProvider<PermissionActionNotifier, AsyncValue<void>>` | All permission request actions and callbacks |
| `permissionStatusProvider` | `FutureProvider.family<bool, PermissionType>` | Watches a single permission's granted status |
| `permissionsStatusProvider` | `FutureProvider.family<Map<PermissionType, bool>, List<PermissionType>>` | Watches multiple permissions at once |
| `permissionGroupStatusProvider` | `FutureProvider.family<bool, PermissionGroup>` | Watches whether all permissions in a group are granted |

---

## Advanced Features

### Automatic Cache Management

The package uses an intelligent caching layer with automatic invalidation:

- **3-second TTL** — cache expires after 3 seconds to ensure fresh data
- **Auto-refresh on resume** — cache clears automatically when the app returns from background (e.g., after the user changes permissions in device settings)
- **Periodic refresh** — cache refreshes every 2 minutes in the background
- **Change detection** — automatically detects and notifies on permission changes

```dart
// Cache is fully automatic. Manual control is available if needed:
final manager = ref.read(permissionManagerProvider);

manager.clearCache(PermissionType.camera);  // Clear one permission
manager.clearAllCache();                    // Clear all

// Bypass cache for an immediate fresh check
final results = await manager.checkPermissionsStatus(
  [PermissionType.camera],
  bypassCache: true,
);
```

### Lifecycle Gap Handling

The package safely handles the window between `WidgetsBinding` initialization and the first available `BuildContext`:

- **Operation queuing** — calls made before initialization completes are queued and replayed automatically
- **Safe context access** — context is found via registered `NavigatorKey` or falls back gracefully
- **Mount checks** — every async operation verifies `context.mounted` before continuing

```dart
// Always initialize before runApp to enable lifecycle handling
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PermissionHandler.initialize();
  runApp(const ProviderScope(child: MyApp()));
}
```

### Permission Change Listening

Subscribe to a real-time stream of permission status changes:

```dart
final manager = ref.read(permissionManagerProvider);

manager.onPermissionChanged.listen((event) {
  print('${event.permission.displayName} → ${event.result.isGranted}');
});
```

You can also listen reactively via Riverpod:

```dart
ref.listen(permissionStateProvider, (previous, next) {
  if (next.isPermissionGranted(PermissionType.camera)) {
    print('Camera was just granted!');
  }
});
```

### Platform-Specific Notes

Get a human-readable note explaining platform limitations for any permission:

```dart
final manager = ref.read(permissionManagerProvider);
final note = manager.getPlatformNote(PermissionType.photos);

if (note.isNotEmpty) {
  print(note); // e.g. "iOS requires separate permission for photos"
}
```

### Permanent Denial Detection

The package automatically detects when a permission is permanently denied and guides users to enable it:

```dart
final manager = ref.read(permissionManagerProvider);
final isPermanentlyDenied = await manager.isPermissionPermanentlyDenied(
  PermissionType.camera,
);

if (isPermanentlyDenied) {
  await manager.openAppSettings();
}
```

The `PermissionBuilder` widget handles this automatically:
- When permission is normally denied → shows "Allow Permission" button
- When permission is permanently denied → shows "Open Settings" button

---

## Customization

### Custom Theme Integration

Dialogs and widgets automatically adopt your app's `ThemeData`:

```dart
ThemeData myTheme() {
  return ThemeData(
    colorScheme: const ColorScheme.light(
      primary: Colors.blue,
      error: Colors.red,
      surface: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}

MaterialApp(
  theme: myTheme(),
  home: const PermissionWrapper(
    requiredPermissions: [PermissionType.camera],
    child: MyHomePage(),
  ),
);
```

### Custom Loading Widget

```dart
PermissionWrapper(
  requiredPermissions: [PermissionType.camera],
  loadingWidget: const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text('Loading permissions...'),
      ],
    ),
  ),
  child: const YourWidget(),
);
```

### Custom Denied Widget

```dart
PermissionWrapper(
  requiredPermissions: [PermissionType.camera],
  permissionDeniedWidget: Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.block, size: 80, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Camera Permission Required'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Open Settings'),
          ),
        ],
      ),
    ),
  ),
  child: const YourWidget(),
);
```

### Override Default Permission Card

The `PermissionBuilder` allows you to provide a completely custom denied widget:

```dart
PermissionBuilder(
  permission: PermissionType.camera,
  deniedWidget: YourCustomPermissionCard(
    permission: PermissionType.camera,
    onRequest: () => _requestPermission(),
  ),
  builder: (context, granted) {
    return YourFeatureWidget();
  },
);
```

---

## Cheatsheet

**One-line permission requests:**

```dart
// Single permission
final result = await ref.read(permissionActionProvider.notifier)
    .requestSinglePermission(PermissionType.camera, context: context);

// Permission group
final results = await ref.read(permissionActionProvider.notifier)
    .requestPermissionGroup(PermissionGroup.communication, context: context);

// Multiple permissions + groups
final granted = await ref.read(permissionActionProvider.notifier)
    .initializeRequiredPermissions(
      context: context,
      requiredPermissions: [PermissionType.camera, PermissionType.microphone],
      requiredGroups: [PermissionGroup.media],
    );

// Smart request — only if not already granted
final result = await ref.read(permissionActionProvider.notifier)
    .requestIfNeeded(PermissionType.camera, context: context);
```

**Permission status checks:**

```dart
// Watch single permission reactively
final isGranted = ref.watch(
  permissionStatusProvider(PermissionType.camera),
).value ?? false;

// Watch group permission reactively
final groupGranted = ref.watch(
  permissionGroupStatusProvider(PermissionGroup.media),
).value ?? false;

// Manual async check
final manager = ref.read(permissionManagerProvider);
final isGranted = await manager.isPermissionGranted(PermissionType.camera);

// Check permanent denial
final isPermanentlyDenied = await manager.isPermissionPermanentlyDenied(
  PermissionType.camera,
);

// Bypass cache for a fresh check
final results = await manager.checkPermissionsStatus(
  [PermissionType.camera],
  bypassCache: true,
);
```

**Quick widget wrappers:**

```dart
PermissionWrapper(
  requiredPermissions: [PermissionType.camera],
  child: YourWidget(),
)

// Smart builder - auto handles denied/permanently denied states
PermissionBuilder(
  permission: PermissionType.camera,
  builder: (context, isGranted) => YourWidget(isGranted),
)
```

**Platform-specific handling:**

```dart
import 'dart:io';

if (Platform.isIOS) {
  await actionNotifier.requestSinglePermission(PermissionType.photos);
} else {
  await actionNotifier.requestSinglePermission(PermissionType.storage);
}
```

**Cache management:**

```dart
final manager = ref.read(permissionManagerProvider);
manager.clearCache(PermissionType.camera);  // Clear specific
manager.clearAllCache();                    // Clear all
```

**Reset state:**

```dart
ref.read(permissionActionProvider.notifier).reset();
ref.invalidate(permissionStateProvider);
```

**Open settings:**

```dart
await ref.read(permissionManagerProvider).openAppSettings();
```

**Common app permission combinations:**

```dart
// Camera app
requiredPermissions: [PermissionType.camera, PermissionType.storage]

// Voice recorder
requiredPermissions: [PermissionType.microphone, PermissionType.storage]

// Navigation app
requiredGroups: [PermissionGroup.locationServices]

// Social media
requiredGroups: [PermissionGroup.communication, PermissionGroup.media]

// Health app
requiredPermissions: [PermissionType.sensors]

// Calendar app
requiredGroups: [PermissionGroup.calendar]
```

---

## Troubleshooting

**Permission dialog not showing**

Ensure the required permissions are declared in your platform files — `AndroidManifest.xml` for Android, `Info.plist` for iOS.

**Permanently denied not detected**

Clear the app's data or reinstall to reset all permission states.

```bash
# Android
adb uninstall com.yourapp.package

# iOS — delete and reinstall the app from the device
```

**Riverpod provider not found**

Wrap your app root with `ProviderScope`:

```dart
void main() {
  runApp(const ProviderScope(child: MyApp()));
}
```

**ScreenUtil errors**

Initialize `ScreenUtilInit` at the top of your widget tree:

```dart
return ScreenUtilInit(
  designSize: const Size(375, 812),
  builder: (context, child) => MaterialApp(home: child),
  child: const HomePage(),
);
```

**Memory leaks**

`PermissionManager` is a singleton and does not need disposal. For manual usage:

```dart
// No need to dispose - singleton pattern
final manager = PermissionManager();
```

**Context not available errors**

Always call `PermissionHandler.initialize()` before `runApp()`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PermissionHandler.initialize();
  runApp(const ProviderScope(child: MyApp()));
}
```

**Cache not updating after settings change**

Cache auto-refreshes on app resume when properly initialized. For an immediate forced refresh:

```dart
final results = await manager.checkPermissionsStatus(
  [PermissionType.camera],
  bypassCache: true,
);
```

**Permission card shows wrong button after returning from settings**

The `PermissionBuilder` automatically rechecks permanent denial status after `openAppSettings()` returns. If issues persist, manually invalidate:

```dart
ref.invalidate(permissionStatusProvider(PermissionType.camera));
```

---

## FAQ

**Q: How do I initialize the package?**

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PermissionHandler.initialize();
  runApp(const ProviderScope(child: MyApp()));
}
```

**Q: How do I request permissions on app startup?**

```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _requestPermissions();
  });
}

Future<void> _requestPermissions() async {
  final notifier = ref.read(permissionActionProvider.notifier);
  await notifier.initializeRequiredPermissions(
    context: context,
    requiredPermissions: [PermissionType.camera, PermissionType.storage],
  );
}
```

**Q: How do I handle multiple permissions independently?**

```dart
final cameraStatus  = ref.watch(permissionStatusProvider(PermissionType.camera));
final storageStatus = ref.watch(permissionStatusProvider(PermissionType.storage));
// Each provider updates independently — no coupling between them
```

**Q: Can I use this without Riverpod?**

Yes, use `PermissionManager` directly:

```dart
final manager = PermissionManager();
final granted = await manager.isPermissionGranted(PermissionType.camera);
```

Note: you lose reactive updates and automatic disposal — Riverpod is strongly recommended.

**Q: How do I test permissions in development?**

```dart
// In your test setup
await Permission.camera.request();
```

**Q: Does this work with Flutter Web?**

No. This package targets mobile platforms (iOS and Android) only.

**Q: How do I reset permission state?**

```dart
ref.read(permissionActionProvider.notifier).reset();
ref.invalidate(permissionStateProvider);
```

**Q: How do I open app settings manually?**

```dart
await ref.read(permissionManagerProvider).openAppSettings();
```

**Q: How do I check if a permission group is supported on the current platform?**

```dart
final isSupported = ref.read(permissionManagerProvider)
    .isGroupSupported(PermissionGroup.media);
```

**Q: How do I clear the permission cache?**

```dart
final manager = ref.read(permissionManagerProvider);
manager.clearCache(PermissionType.camera); // Clear one
manager.clearAllCache();                   // Clear all
```

**Q: How do I get platform-specific notes for a permission?**

```dart
final note = ref.read(permissionManagerProvider)
    .getPlatformNote(PermissionType.photos);
if (note.isNotEmpty) print(note);
```

**Q: How do I listen to permission changes in real-time?**

```dart
ref.read(permissionManagerProvider).onPermissionChanged.listen((event) {
  print('${event.permission.displayName} changed!');
});
```

**Q: What is the difference between `requestSinglePermission` and `requestIfNeeded`?**

`requestSinglePermission` always shows the system permission dialog. `requestIfNeeded` checks first and skips the dialog if the permission is already granted — useful for buttons that should work silently when permission is already in place.

**Q: How does automatic cache invalidation work on app resume?**

When `PermissionHandler.initialize()` is called, it registers a `WidgetsBindingObserver`. When `AppLifecycleState.resumed` fires (i.e., the user returns from device settings), the cache is cleared and all permissions are re-checked automatically.

**Q: What happens if I call methods before initialization completes?**

Operations are queued internally and executed automatically once initialization finishes — nothing is dropped.

**Q: How does the PermissionBuilder detect permanent denial?**

The `PermissionBuilder` checks `isPermissionPermanentlyDenied()` during initialization and after each permission request. If permanently denied, it shows an "Open Settings" button instead of "Allow Permission".

---

## License

MIT License — see [LICENSE](LICENSE) for details.

---

## Contributing

Pull requests and issues are welcome. Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## Support

- Issues: [GitHub Issues](#)
- Discussions: [GitHub Discussions](#)
- Documentation: [Wiki](#)

---

*Made with ❤️ for the Flutter community*
```

## Summary of Changes Made

1. **Introduction** - Removed "retry logic" from the first paragraph

2. **Table of Contents** - Removed entries for:
   - "7. Custom Explanation Dialog"
   - "Smart Retry Logic"
   - "Custom Explanation Dialogs"

3. **Features Table** - Removed rows for:
   - "Smart Retry Logic"
   - "Custom Explanation Dialogs"

4. **Usage Examples** - Removed the entire "7. Custom Explanation Dialog" section

5. **API Reference (PermissionActionNotifier)** - Removed methods:
   - `setPermissionExplanationCallback()`
   - `setGroupExplanationCallback()`
   - `removePermissionExplanationCallback()`
   - `removeGroupExplanationCallback()`

6. **Widgets** - Updated `PermissionDeniedDialog` description to remove "includes retry count" reference

7. **Advanced Features** - Removed the entire "Smart Retry Logic" section

8. **Customization** - Removed the entire "Custom Explanation Dialogs" section

9. **FAQ** - Removed "How many retries are attempted..." question and answer

All other sections remain unchanged and accurately reflect the current package implementation.