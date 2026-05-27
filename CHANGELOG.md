# Changelog

# Changelog

All notable changes to the `permission_handler_package` package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.5] - 2024-01-16

### 🚀 Major Fixes & Improvements

#### 🔧 Critical Fixes
- **Removed plugin declaration** - Package is now correctly identified as a pure Dart package (no native Android/iOS code)
- **Fixed Android build error** - Resolved "plugin doesn't have a main class defined" error
- **Fixed iOS build error** - Removed unnecessary native plugin requirements

#### 📦 Package Structure Changes
- **Removed `flutter.plugin` section** from `pubspec.yaml` - No longer declares as native plugin
- **Pure Dart package** - Correctly wraps `permission_handler` without duplicating native code
- **Simplified installation** - No more native file conflicts

#### 🎯 What Changed
```diff
- flutter:
-   plugin:
-     platforms:
-       android:
-         package: com.permission.handler.package
-         pluginClass: PermissionHandlerPackagePlugin
-       ios:
-         pluginClass: PermissionHandlerPackagePlugin
+ # No plugin declaration - pure Dart package

All notable changes to the `permission_handler_package` package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.4] - 2024-01-15

### 🎯 Major Improvements

#### 🧹 Code Cleanup & Simplification
- **Removed redundant screens** - `PermissionInitialScreen`, `PermissionDeniedScreen`, `PermissionPermanentScreen`, `PermissionSettingsScreen` removed
- **Consolidated UI** - Now only dialogs handle all permission flows (no duplication)
- **Simplified architecture** - Cleaner, more maintainable codebase

#### 🐛 Bug Fixes
- Fixed deprecated `withOpacity()` warnings → replaced with `withAlpha()`
- Fixed incorrect import paths across all files
- Fixed missing `permission_provider.dart` import in settings widget
- Fixed all circular dependency issues

#### 🔧 Dependency Updates
- Updated `permission_handler` to latest version
- Updated `flutter_riverpod` compatibility
- Updated `flutter_screenutil` integration

#### 📁 Structure Changes