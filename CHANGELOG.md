# Changelog

All notable changes to the `permission_handler_package` package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0]
- Most Exsisting error cleared
- updated
---


## [1.0.9]
- Most Exsisting error cleared
---

## [1.0.8]
- updated the global errors
---

## [1.0.7]
- Added screen util
---

## [1.0.6] - 2024-01-16

### 🚀 Major Features & Improvements

#### ✨ New Features
- **Smart Permission Builder** - Now automatically detects permanent denial and shows appropriate UI
  - Shows "Allow Permission" button for normal denied state
  - Shows "Open Settings" button for permanently denied state
  - Automatically refreshes state after returning from settings
- **Intelligent Retry Tracking** - Proper retry count tracking (0, 1) in denial dialogs
  - First denial: "Attempt 1 of 2"
  - Second denial: "Attempt 2 of 2"
- **Permanent Denial Detection** - Built-in detection with automatic settings redirection
- **Improved Permission Flow** - Complete flow from initial request to permanent denial handling

#### 🔧 Critical Fixes
- **Removed `ref.onDispose(() => manager.dispose())`** - PermissionManager is now correctly implemented as singleton
- **Fixed provider memory leaks** - No more unnecessary disposal of singleton instance
- **Added mounted checks** - Prevents calling `ref.invalidate` on disposed widgets in PermissionBuilder
- **Fixed retry dialog display** - Now shows correct attempt number instead of always showing "1 of 2"

#### 🎨 UI Improvements
- **Redesigned PermissionBuilder denied card** - Professional, modern card design
  - Circular icon background with adaptive colors
  - Permission-specific title and description
  - Dynamic button text and color based on denial state
  - Loading state while checking permanent denial status
- **Enhanced visual feedback** - Different icons for denied vs permanently denied states
- **Better error handling** - Graceful fallbacks for edge cases

#### 📦 Package Structure
- **Removed unnecessary imports** - Cleaned up `permission_builder.dart` imports
- **Improved code organization** - Better separation of concerns
- **Simplified widget API** - Cleaner, more intuitive interface

#### 🔄 Permission Flow Improvements
- **Pre-flight status check** - Checks current permission status before showing dialogs
- **Permanent denial shortcut** - Immediately shows settings dialog without unnecessary requests
- **Smart retry loop** - While loop with proper retry counting (max 2 attempts)
- **State refresh after settings** - Automatically rechecks permission status when returning from settings

### 📝 Example Updates

#### New Smart PermissionBuilder
```dart
PermissionBuilder(
  permission: PermissionType.camera,
  builder: (context, isGranted) {
    // Your widget when permission is granted
    return CameraWidget();
  },
)
// Automatically shows:
// - Permission card with "Allow Permission" when denied
// - Settings card with "Open Settings" when permanently denied