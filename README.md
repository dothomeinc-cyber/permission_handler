# Permission Handler Package

[![pub package](https://img.shields.io/pub/v/permission_handler_package.svg)](https://pub.dev/packages/permission_handler_package)
[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Riverpod](https://img.shields.io/badge/State%20Management-Riverpod-25B6FF)](https://riverpod.dev)
[![Google Fonts](https://img.shields.io/badge/Fonts-Google%20Fonts-4285F4)](https://fonts.google.com)
[![Permission Handler](https://img.shields.io/badge/Permission%20Handler-11.3.0+-green)](https://pub.dev/packages/permission_handler)
[![Code Size](https://img.shields.io/github/languages/code-size/yourusername/permission_handler_package)](https://github.com/yourusername/permission_handler_package)

A professional Flutter package for handling permissions automatically with **Riverpod** state management, **retry logic**, **beautiful UI dialogs**, and **ScreenUtil** responsive design.

---

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Platform Configuration](#platform-configuration)
  - [Android Setup](#android-setup)
  - [iOS Setup](#ios-setup)
- [Quick Start](#quick-start)
- [Permission Types & Groups](#permission-types--groups)
  - [Complete Permission Types](#complete-permission-types)
  - [Permission Groups](#permission-groups)
  - [Platform Support Matrix](#platform-support-matrix)
- [Usage Examples](#usage-examples)
- [API Reference](#api-reference)
  - [PermissionActionNotifier Methods](#permissionactionnotifier-methods)
  - [PermissionManager Methods](#permissionmanager-methods)
  - [PermissionResult Properties](#permissionresult-properties)
  - [PermissionGroup Properties](#permissiongroup-properties)
  - [Widgets](#widgets)
  - [Providers](#providers)
- [Customization](#customization)
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
| **Smart Retry Logic** | Configurable retry attempts with user prompts (max 2 retries default) |
| **Permanent Denial Detection** | Handles permanently denied permissions with settings redirection |
| **System Settings Navigation** | One-click redirect to app settings |
| **Beautiful UI Dialogs** | Customizable, theme-aware permission dialogs |
| **Permission Wrapper** | Easy-to-use widget wrapper for protected screens |
| **Reactive Permission Builder** | Real-time permission status updates |
| **Responsive Design** | Built with ScreenUtil for responsive layouts |
| **Custom Theme Support** | Integrates with your existing theme |
| **Cross-Platform** | Fully supports both iOS and Android |
| **Zero Configuration** | Works out of the box with sensible defaults |
| **Type Safety** | Full Dart type safety with enum-based permissions |
| **Custom Explanation Dialogs** | Show custom messages before requesting permissions |
| **Permission Groups** | Request multiple related permissions at once |
| **Platform-Specific Support** | Automatically handles iOS/Android differences |

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

## Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler_package/permission_handler_package.dart';

void main() {
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
| `PermissionType.calendar` | Calendar | Both | Calendar events access |
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
| `PermissionGroup.calendar` | Calendar | `calendar`, `reminders` |
| `PermissionGroup.bluetooth` | Bluetooth | `bluetooth` |
| `PermissionGroup.sensors` | Sensors | `sensors` |
| `PermissionGroup.phone` | Phone | `phone`, `sms` |

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
| `calendar` | ✅ | ✅ |
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

### 4. Reactive Permission Builder

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

### 5. Check Permission Status

```dart
class PermissionStatusWidget extends ConsumerWidget {
  const PermissionStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraStatus = ref.watch(permissionStatusProvider(PermissionType.camera));

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

### 7. Custom Explanation Dialog

```dart
class CustomPermissionExample extends ConsumerStatefulWidget {
  const CustomPermissionExample({super.key});

  @override
  ConsumerState<CustomPermissionExample> createState() =>
      _CustomPermissionExampleState();
}

class _CustomPermissionExampleState
    extends ConsumerState<CustomPermissionExample> {
  @override
  void initState() {
    super.initState();
    _setupPermissionCallbacks();
  }

  void _setupPermissionCallbacks() {
    final actionNotifier = ref.read(permissionActionProvider.notifier);

    actionNotifier.setPermissionExplanationCallback((permission) async {
      return await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text('Why do we need ${permission.displayName}?'),
              content: Text(permission.description),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Not Now'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Allow'),
                ),
              ],
            ),
          ) ??
          false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Permission')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final actionNotifier = ref.read(permissionActionProvider.notifier);
            await actionNotifier.requestSinglePermission(PermissionType.camera);
          },
          child: const Text('Request Camera with Explanation'),
        ),
      ),
    );
  }
}
```

### 8. Multiple Permissions with Groups

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

### 9. Check Group Permission Status

```dart
class GroupStatusWidget extends ConsumerWidget {
  const GroupStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaGroupStatus =
        ref.watch(permissionGroupStatusProvider(PermissionGroup.media));

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

### 10. Conditional UI Based on Permissions

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
          const PermissionRequestCard(permission: PermissionType.camera),
        if (microphoneGranted.value == true)
          const MicrophoneWidget()
        else
          const PermissionRequestCard(permission: PermissionType.microphone),
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
| `requestSinglePermission()` | `permission` | `Future<PermissionResult>` | Request a single permission |
| `requestPermissionGroup()` | `group`, `showExplanation?` | `Future<Map<PermissionType, PermissionResult>>` | Request all permissions in a group |
| `setPermissionExplanationCallback()` | `callback` | `void` | Set custom explanation callback for permissions |
| `setGroupExplanationCallback()` | `callback` | `void` | Set custom explanation callback for groups |
| `reset()` | — | `void` | Reset permission state |

### PermissionManager Methods

| Method | Parameters | Returns | Description |
|---|---|---|---|
| `checkPermissionsStatus()` | `List<PermissionType>` | `Future<Map<PermissionType, PermissionResult>>` | Check status of multiple permissions |
| `requestPermission()` | `PermissionType` | `Future<PermissionResult>` | Request a single permission |
| `requestPermissions()` | `List<PermissionType>` | `Future<Map<PermissionType, PermissionResult>>` | Request multiple permissions |
| `requestPermissionWithExplanation()` | `PermissionType`, `showExplanation?` | `Future<PermissionResult>` | Request with optional explanation dialog |
| `requestPermissionGroup()` | `PermissionGroup`, `showExplanation?` | `Future<Map<PermissionType, PermissionResult>>` | Request a permission group |
| `openAppSettings()` | — | `Future<void>` | Open app settings page |
| `isPermissionGranted()` | `PermissionType` | `Future<bool>` | Check if a permission is granted |
| `isPermissionPermanentlyDenied()` | `PermissionType` | `Future<bool>` | Check if permanently denied |
| `checkGroupPermissionsStatus()` | `List<PermissionGroup>` | `Future<Map<PermissionGroup, bool>>` | Check group permissions status |
| `isGroupSupported()` | `PermissionGroup` | `bool` | Check if group is supported on platform |
| `getPlatformNote()` | `PermissionType` | `String` | Get platform-specific note |
| `clearCache()` | `PermissionType` | `void` | Clear cache for a specific permission |
| `clearAllCache()` | — | `void` | Clear all cached permission results |
| `dispose()` | — | `void` | Dispose the manager |

### PermissionResult Properties

| Property | Type | Description |
|---|---|---|
| `permission` | `PermissionType` | The permission type |
| `isGranted` | `bool` | Whether permission is granted |
| `isPermanentlyDenied` | `bool` | Whether permanently denied |
| `status` | `PermissionStatus` | Raw permission status |
| `timestamp` | `DateTime` | When the result was created |
| `isDenied` | `bool` | Whether permission is denied |
| `isLimited` | `bool` | Whether permission is limited (iOS) |
| `isRestricted` | `bool` | Whether permission is restricted (iOS) |

### PermissionGroup Properties

| Property | Type | Description |
|---|---|---|
| `displayName` | `String` | User-friendly group name |
| `icon` | `String` | Emoji icon for the group |
| `permissions` | `List<PermissionType>` | All permissions in the group |

### Widgets

| Widget | Purpose |
|---|---|
| `PermissionWrapper` | Wraps widgets that require permissions before rendering |
| `PermissionBuilder` | Rebuilds UI reactively based on permission status |
| `PermissionInitialDialog` | Dialog shown on initial permission request |
| `PermissionDeniedDialog` | Dialog shown when a permission is denied |
| `PermissionPermanentDialog` | Dialog shown when a permission is permanently denied |

### Providers

| Provider | Type | Description |
|---|---|---|
| `permissionManagerProvider` | `Provider<PermissionManager>` | Provides `PermissionManager` instance |
| `permissionStateProvider` | `ChangeNotifierProvider<PermissionNotifier>` | Provides permission state |
| `permissionActionProvider` | `StateNotifierProvider<PermissionActionNotifier, AsyncValue<void>>` | Provides permission actions |
| `permissionStatusProvider` | `FutureProvider.family<bool, PermissionType>` | Watches a single permission status |
| `permissionsStatusProvider` | `FutureProvider.family<Map<PermissionType, bool>, List<PermissionType>>` | Watches multiple permissions |
| `permissionGroupStatusProvider` | `FutureProvider.family<bool, PermissionGroup>` | Watches group permission status |

---

## Customization

### Custom Theme Integration

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

---

## Cheatsheet

**One-line permission requests:**

```dart
// Single permission
final result = await ref.read(permissionActionProvider.notifier)
    .requestSinglePermission(PermissionType.camera);

// Permission group
final results = await ref.read(permissionActionProvider.notifier)
    .requestPermissionGroup(PermissionGroup.communication);

// Initialize multiple permissions
final granted = await ref.read(permissionActionProvider.notifier)
    .initializeRequiredPermissions(
      context: context,
      requiredPermissions: [PermissionType.camera, PermissionType.microphone],
    );
```

**Permission status checks:**

```dart
// Watch single permission reactively
final isGranted = ref.watch(permissionStatusProvider(PermissionType.camera)).value ?? false;

// Watch group permission reactively
final groupGranted = ref.watch(permissionGroupStatusProvider(PermissionGroup.media)).value ?? false;

// Manual async check
final manager = ref.read(permissionManagerProvider);
final isGranted = await manager.isPermissionGranted(PermissionType.camera);
```

**Quick widget wrappers:**

```dart
// Wrapper for protected screens
PermissionWrapper(
  requiredPermissions: [PermissionType.camera],
  child: YourWidget(),
)

// Reactive builder
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

**Custom explanation callbacks:**

```dart
actionNotifier.setPermissionExplanationCallback((permission) async {
  return await showMyCustomDialog();
});

actionNotifier.setGroupExplanationCallback((group) async {
  return await showMyGroupDialog();
});
```

**Quick check and request:**

```dart
final manager = ref.read(permissionManagerProvider);
final hasPermission = await manager.isPermissionGranted(PermissionType.camera);

if (!hasPermission) {
  final result = await manager.requestPermission(PermissionType.camera);
  if (result.isGranted) {
    // Proceed
  }
}
```

**Listen to permission changes:**

```dart
ref.listen(permissionStateProvider, (previous, next) {
  if (next.isPermissionGranted(PermissionType.camera)) {
    print('Camera permission granted!');
  }
});
```

**Common permission combinations:**

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
```

---

## Troubleshooting

**Permission dialog not showing**

Ensure permissions are declared in your platform-specific files — `AndroidManifest.xml` for Android, `Info.plist` for iOS.

**Permanently denied not detected**

Clear app data or reinstall to reset permission state.

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
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MaterialApp(home: child),
      child: const HomePage(),
    );
  }
}
```

**Memory leaks**

Dispose `PermissionManager` when done:

```dart
@override
void dispose() {
  ref.read(permissionManagerProvider).dispose();
  super.dispose();
}
```

---

## FAQ

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
// Each provider updates independently
```

**Q: Can I use this without Riverpod?**

Yes, use `PermissionManager` directly:

```dart
final manager = PermissionManager();
final granted = await manager.isPermissionGranted(PermissionType.camera);
```

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
```

**Q: How do I open app settings manually?**

```dart
final manager = ref.read(permissionManagerProvider);
await manager.openAppSettings();
```

**Q: How do I check if a permission group is supported on the current platform?**

```dart
final manager = ref.read(permissionManagerProvider);
final isSupported = manager.isGroupSupported(PermissionGroup.media);
```

**Q: How do I clear the permission cache?**

```dart
final manager = ref.read(permissionManagerProvider);
manager.clearCache(PermissionType.camera); // Clear specific permission
manager.clearAllCache();                   // Clear all
```

**Q: How do I get platform-specific notes for a permission?**

```dart
final manager = ref.read(permissionManagerProvider);
final note = manager.getPlatformNote(PermissionType.photos);
if (note.isNotEmpty) {
  print(note); // e.g. "iOS requires separate permission for photos"
}
```

---

## License

MIT License — see [LICENSE](LICENSE) for details.

---

## Contributing

Pull requests and issues are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## Support

- Issues: [GitHub Issues](#)
- Discussions: [GitHub Discussions](#)
- Documentation: [Wiki](#)

---

*Made with ❤️ for the Flutter community*