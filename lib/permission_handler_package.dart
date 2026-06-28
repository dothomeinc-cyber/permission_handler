/// Permission Handler Package - Fully Automatic
/// No manual handling required. Just add to your pubspec.yaml and it works.
// ignore: unnecessary_library_name
library permission_handler_package;

import 'package:flutter/widgets.dart';
import 'core/permissions/permission_manager.dart';

// Core exports
export 'core/permissions/permission_manager.dart';
export 'core/permissions/permission_provider.dart';
export 'core/permissions/permission_state.dart';

// Models
export 'core/permissions/models/permission_type.dart';
export 'core/permissions/models/permission_result.dart';

// Widgets
export 'core/permissions/widgets/permission_builder.dart';
export 'core/permissions/widgets/permission_wrapper.dart';
export 'core/permissions/widgets/permission_denied_dialog.dart';
export 'core/permissions/widgets/permission_initial_dialog.dart';
export 'core/permissions/widgets/permission_permanent_dialog.dart';


/// Initialize the permission handler package
/// Call this as early as possible in your app, ideally before runApp()
/// Example:
/// ```
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await PermissionHandler.initialize();
///   runApp(MyApp());
/// }
/// ```
class PermissionHandler {
  static bool _initialized = false;

  /// Initialize the permission handler package
  /// Call this before using any permission features
  static Future<void> initialize() async {
    if (_initialized) return;

    // Ensure Flutter binding is initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Mark the manager as initialized
    final manager = PermissionManager();
    manager.markInitialized();

    _initialized = true;
  }

  /// Check if the package is initialized
  static bool get isInitialized => _initialized;
}
