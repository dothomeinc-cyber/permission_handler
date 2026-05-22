# Permission Handler Package

[![pub package](https://img.shields.io/pub/v/permission_handler_package.svg)](https://pub.dev/packages/permission_handler_package)
[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Riverpod](https://img.shields.io/badge/State%20Management-Riverpod-25B6FF)](https://riverpod.dev)
[![Style: Google Fonts](https://img.shields.io/badge/Fonts-Google%20Fonts-4285F4)](https://fonts.google.com)

A professional Flutter package for handling permissions automatically with **Riverpod** state management, **retry logic**, **beautiful UI dialogs**, and **ScreenUtil** responsive design.

---

## Features

- **Automatic Permission Handling** — Request and manage permissions seamlessly
- **Riverpod Integration** — Reactive state management with Riverpod
- **Smart Retry Logic** — Configurable retry attempts with user prompts
- **Permanent Denial Detection** — Handles permanently denied permissions gracefully
- **System Settings Navigation** — One-click redirect to app settings
- **Beautiful UI Dialogs** — Customizable, theme-aware permission dialogs
- **Permission Wrapper** — Easy-to-use widget wrapper for protected screens
- **Reactive Permission Builder** — Real-time permission status updates
- **Responsive Design** — Built with ScreenUtil for responsive layouts
- **Custom Theme Support** — Integrates with your existing theme
- **Cross-Platform** — Fully supports both iOS and Android
- **Zero Configuration** — Works out of the box with sensible defaults
- **Type Safety** — Full Dart type safety with enum-based permissions

---

## Table of Contents

- [Installation](#installation)
- [Platform Configuration](#platform-configuration)
  - [Android Setup](#android-setup)
  - [iOS Setup](#ios-setup)
- [Quick Start](#quick-start)
- [Core Concepts](#core-concepts)
  - [Permission Types](#permission-types)
- [Usage Examples](#usage-examples)
- [API Reference](#api-reference)
  - [PermissionActionNotifier Methods](#permissionactionnotifier-methods)
  - [PermissionManager Methods](#permissionmanager-methods)
  - [Widgets](#widgets)
  - [Providers](#providers)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)
- [License](#license)

---

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  permission_handler_package: ^1.0.0
```

Then run:

```bash
flutter pub get
```

The package automatically includes these dependencies:

```yaml
permission_handler: ^11.0.0
riverpod: ^2.4.0
flutter_riverpod: ^2.4.0
flutter_screenutil: ^5.9.0
google_fonts: ^6.1.0
```

---

## Platform Configuration

### Android Setup

Add the required permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- Storage -->
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

    <!-- Phone -->
    <uses-permission android:name="android.permission.READ_PHONE_STATE" />
    <uses-permission android:name="android.permission.CALL_PHONE" />

    <!-- SMS -->
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

    <application
        android:requestLegacyExternalStorage="true"
        ...>
    </application>

</manifest>
```

### iOS Setup

Add permission descriptions to `ios/Runner/Info.plist`:

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
          theme: yourTheme(),
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

## Core Concepts

### Permission Types

| Permission Type | Description | Platform |
|---|---|---|
| `PermissionType.camera` | Camera access for photos/videos | Both |
| `PermissionType.storage` | Read/write external storage | Both |
| `PermissionType.location` | Fine and coarse location | Both |
| `PermissionType.locationAlways` | Always location access | Both |
| `PermissionType.locationWhenInUse` | Location only when using the app | Both |
| `PermissionType.microphone` | Microphone/audio recording | Both |
| `PermissionType.contacts` | Read/write contacts | Both |
| `PermissionType.notifications` | Push notifications | Both |
| `PermissionType.photos` | Photo library access | iOS only |
| `PermissionType.calendar` | Calendar events | Both |
| `PermissionType.reminders` | Reminders access | iOS only |
| `PermissionType.bluetooth` | Bluetooth connectivity | Both |
| `PermissionType.sensors` | Body sensors / health data | Both |
| `PermissionType.sms` | Send/receive SMS | Android only |
| `PermissionType.phone` | Make phone calls | Android only |

---

## Usage Examples

### 1. Simple Permission Request

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
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Camera permission required')),
          );
        }
      },
      child: const Text('Open Camera'),
    );
  }
}
```

### 2. Permission Wrapper Widget

```dart
class ProtectedScreen extends StatelessWidget {
  const ProtectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PermissionWrapper(
      requiredPermissions: [
        PermissionType.camera,
        PermissionType.storage,
      ],
      title: 'Permissions Required',
      message: 'This screen needs camera and storage access to function',
      onPermissionsGranted: () {
        print('All permissions granted!');
      },
      onPermissionsDenied: () {
        print('Permissions denied');
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Camera Screen')),
        body: const CameraWidget(),
      ),
    );
  }
}
```

### 3. Reactive Permission Builder

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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isGranted ? () => _openCamera() : null,
              child: const Text('Take Photo'),
            ),
          ],
        );
      },
      deniedWidget: const CustomDeniedWidget(),
      loadingWidget: const CircularProgressIndicator(),
    );
  }

  void _openCamera() {
    // Camera implementation
  }
}
```

### 4. Multiple Permissions Request

```dart
class MultiPermissionScreen extends ConsumerWidget {
  const MultiPermissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multi Permission Demo')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final actionNotifier = ref.read(permissionActionProvider.notifier);

            final results = await actionNotifier.initializeRequiredPermissions(
              context: context,
              requiredPermissions: [
                PermissionType.camera,
                PermissionType.microphone,
                PermissionType.location,
              ],
              title: 'Multiple Permissions Required',
              message: 'This feature needs access to camera, microphone, and location',
            );

            if (results) {
              _startFeature();
            } else {
              _showPartialAccessDialog();
            }
          },
          child: const Text('Start Video Call'),
        ),
      ),
    );
  }

  void _startFeature() { /* start video call feature */ }

  void _showPartialAccessDialog() { /* show limited functionality dialog */ }
}
```

### 5. Check Permission Status

```dart
class PermissionStatusWidget extends ConsumerWidget {
  const PermissionStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraStatus  = ref.watch(permissionStatusProvider(PermissionType.camera));
    final storageStatus = ref.watch(permissionStatusProvider(PermissionType.storage));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatusTile('Camera', cameraStatus),
            const Divider(),
            _buildStatusTile('Storage', storageStatus),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTile(String title, AsyncValue<bool> status) {
    return status.when(
      data: (isGranted) => ListTile(
        leading: Icon(
          isGranted ? Icons.check_circle : Icons.block,
          color: isGranted ? Colors.green : Colors.red,
        ),
        title: Text(title),
        trailing: Text(
          isGranted ? 'Granted' : 'Denied',
          style: TextStyle(
            color: isGranted ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      loading: () => const ListTile(
        leading: CircularProgressIndicator(),
        title: Text('Loading...'),
      ),
      error: (_, __) => const ListTile(
        leading: Icon(Icons.error, color: Colors.red),
        title: Text('Error checking permission'),
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
  Widget build(BuildContext context) {
    return Container(); // Your widget tree
  }
}
```

### 7. Custom Dialog Styling

```dart
class CustomPermissionDialog extends StatelessWidget {
  const CustomPermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return PermissionWrapper(
      requiredPermissions: [PermissionType.camera],
      title: 'Custom Title',
      message: 'Custom message with your branding',
      // Dialogs automatically adopt your app's MaterialApp theme
      child: const YourWidget(),
    );
  }
}
```

### 8. Background Location Permission

```dart
class LocationService extends ConsumerWidget {
  const LocationService({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildLocationButton(
          context, ref,
          PermissionType.locationWhenInUse,
          'Enable While Using',
          'Get location only when app is open',
        ),
        const SizedBox(height: 16),
        _buildLocationButton(
          context, ref,
          PermissionType.locationAlways,
          'Enable Always',
          'Get location even when app is in the background',
        ),
      ],
    );
  }

  Widget _buildLocationButton(
    BuildContext context,
    WidgetRef ref,
    PermissionType permission,
    String title,
    String subtitle,
  ) {
    final status = ref.watch(permissionStatusProvider(permission));

    return Card(
      child: ListTile(
        leading: const Icon(Icons.location_on),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: status.when(
          data: (isGranted) => ElevatedButton(
            onPressed: isGranted ? null : () => _requestLocation(ref, permission),
            child: Text(isGranted ? 'Granted' : 'Request'),
          ),
          loading: () => const SizedBox(
            width: 20, height: 20,
            child: CircularProgressIndicator(),
          ),
          error: (_, __) => const Text('Error'),
        ),
      ),
    );
  }

  Future<void> _requestLocation(WidgetRef ref, PermissionType permission) async {
    final actionNotifier = ref.read(permissionActionProvider.notifier);
    final result = await actionNotifier.requestSinglePermission(permission);
    if (result.isGranted) {
      // Start location tracking
    }
  }
}
```

### 9. Conditional UI Based on Permissions

```dart
class ConditionalUI extends ConsumerWidget {
  const ConditionalUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraGranted     = ref.watch(permissionStatusProvider(PermissionType.camera));
    final microphoneGranted = ref.watch(permissionStatusProvider(PermissionType.microphone));

    return Column(
      children: [
        cameraGranted.when(
          data: (hasCamera) => hasCamera
              ? const CameraWidget()
              : const PermissionRequestCard(permission: PermissionType.camera),
          loading: () => const CircularProgressIndicator(),
          error: (_, __) => const Text('Error checking camera'),
        ),
        microphoneGranted.when(
          data: (hasMic) => hasMic
              ? const MicrophoneWidget()
              : const PermissionRequestCard(permission: PermissionType.microphone),
          loading: () => const CircularProgressIndicator(),
          error: (_, __) => const Text('Error checking microphone'),
        ),
      ],
    );
  }
}

class PermissionRequestCard extends StatelessWidget {
  final PermissionType permission;

  const PermissionRequestCard({super.key, required this.permission});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('${permission.displayName} Permission Required'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final container = ProviderScope.containerOf(context);
                final actionNotifier = container.read(permissionActionProvider.notifier);
                await actionNotifier.requestSinglePermission(permission);
              },
              child: const Text('Grant Permission'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 10. Permission Gate with Redirection

```dart
class PermissionGate extends ConsumerWidget {
  const PermissionGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PermissionWrapper(
      requiredPermissions: [
        PermissionType.camera,
        PermissionType.storage,
        PermissionType.location,
      ],
      title: 'Setup Required',
      message: 'Please grant these permissions to continue using the app',
      onPermissionsGranted: () {
        Navigator.of(context).pushReplacementNamed('/home');
      },
      onPermissionsDenied: () {
        _showExitDialog(context);
      },
      child: const SizedBox(),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Permissions Required'),
        content: const Text(
          'This app cannot function without the required permissions.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Try Again'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}
```

---

## API Reference

### PermissionActionNotifier Methods

| Method | Description | Returns |
|---|---|---|
| `initializeRequiredPermissions()` | Initialize and request all required permissions | `Future<bool>` |
| `requestSinglePermission()` | Request a single permission | `Future<PermissionResult>` |
| `reset()` | Reset permission state | `void` |

### PermissionManager Methods

| Method | Description | Returns |
|---|---|---|
| `checkPermissionsStatus()` | Check current status of permissions | `Future<Map<PermissionType, PermissionResult>>` |
| `requestPermission()` | Request a single permission | `Future<PermissionResult>` |
| `requestPermissions()` | Request multiple permissions | `Future<Map<PermissionType, PermissionResult>>` |
| `openAppSettings()` | Open the app settings page | `Future<void>` |
| `isPermissionGranted()` | Check if a permission is granted | `Future<bool>` |
| `isPermissionPermanentlyDenied()` | Check if a permission is permanently denied | `Future<bool>` |

### Widgets

| Widget | Description |
|---|---|
| `PermissionWrapper` | Wraps widgets that require permissions before rendering |
| `PermissionBuilder` | Rebuilds UI reactively based on permission status |
| `PermissionInitialDialog` | Dialog shown on initial permission request |
| `PermissionDeniedDialog` | Dialog shown when a permission is denied |
| `PermissionPermanentDialog` | Dialog shown when a permission is permanently denied |

### Providers

| Provider | Description |
|---|---|
| `permissionManagerProvider` | Provides a `PermissionManager` instance |
| `permissionStateProvider` | Provides the current permission state |
| `permissionActionProvider` | Provides permission actions (notifier) |
| `permissionStatusProvider` | Watches a single permission status |
| `permissionsStatusProvider` | Watches multiple permission statuses |

---

## Customization

### Custom Theme Integration

The package automatically adopts your app's `ThemeData`:

```dart
ThemeData myTheme() {
  return ThemeData(
    colorScheme: const ColorScheme.light(
      primary: Colors.blue,
      error: Colors.red,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
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

### Custom Dialogs

```dart
class CustomPermissionDialog extends StatelessWidget {
  const CustomPermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Custom Dialog'),
      content: const Text('This is your custom permission dialog'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Allow'),
        ),
      ],
    );
  }
}
```

### Custom Loading Widget

```dart
PermissionWrapper(
  requiredPermissions: [PermissionType.camera],
  loadingWidget: const CustomLoadingAnimation(),
  child: const YourWidget(),
)
```

### Custom Denied Widget

```dart
PermissionWrapper(
  requiredPermissions: [PermissionType.camera],
  permissionDeniedWidget: const CustomPermissionDeniedScreen(),
  child: const YourWidget(),
)
```

---

## Troubleshooting

**Permission dialog not showing**

Ensure the correct permissions are declared in your platform-specific files. On Android, check `AndroidManifest.xml`; on iOS, check `Info.plist`.

**Permanently denied not detected**

Clear the app's data or reinstall it to reset permission state.

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

---

## FAQ

**Q: How do I request permissions on app startup?**

```dart
class _MyAppState extends ConsumerState<MyApp> {
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
}
```

**Q: How do I handle multiple permissions independently?**

```dart
final cameraStatus  = ref.watch(permissionStatusProvider(PermissionType.camera));
final storageStatus = ref.watch(permissionStatusProvider(PermissionType.storage));

// Each provider updates independently
```

**Q: Can I use this without Riverpod?**

Yes. You can use `PermissionManager` directly, though Riverpod is recommended for reactive UI:

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

---

## License

MIT License — see [LICENSE](LICENSE) for details.

---

## Support

- Issues: [GitHub Issues](#)
- Documentation: [Wiki](#)

---

*Made with ❤️ for the Flutter community*