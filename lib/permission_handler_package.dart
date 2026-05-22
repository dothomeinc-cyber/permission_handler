/// Permission Handler Package
/// A professional Flutter package for handling permissions automatically
/// with Riverpod state management, retry logic, and beautiful UI dialogs.
library permission_handler_package;

// Core exports
export 'core/permissions/permission_manager.dart';
export 'core/permissions/permission_provider.dart';
export 'core/permissions/permission_state.dart';

// Models
export 'core/permissions/models/permission_type.dart';
export 'core/permissions/models/permission_result.dart';

// Widgets (Dialogs only - screens are internal)
export 'core/permissions/widgets/permission_builder.dart';
export 'core/permissions/widgets/permission_wrapper.dart';
export 'core/permissions/widgets/permission_initial_dialog.dart';
export 'core/permissions/widgets/permission_denied_dialog.dart';
export 'core/permissions/widgets/permission_permanent_dialog.dart';

// Note: Screen files are not exported as they are internal implementation
