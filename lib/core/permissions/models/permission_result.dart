import 'package:permission_handler/permission_handler.dart';
import 'permission_type.dart';

class PermissionResult {
  final PermissionType permission;
  final bool isGranted;
  final bool isPermanentlyDenied;
  final PermissionStatus status;
  final DateTime timestamp;

  PermissionResult({
    required this.permission,
    required this.isGranted,
    required this.isPermanentlyDenied,
    required this.status,
  }) : timestamp = DateTime.now();

  bool get isDenied => status.isDenied;
  bool get isLimited => status.isLimited;
  bool get isRestricted => status.isRestricted;

  PermissionResult copyWith({
    PermissionType? permission,
    bool? isGranted,
    bool? isPermanentlyDenied,
    PermissionStatus? status,
  }) {
    return PermissionResult(
      permission: permission ?? this.permission,
      isGranted: isGranted ?? this.isGranted,
      isPermanentlyDenied:
          isPermanentlyDenied ?? this.isPermanentlyDenied,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'PermissionResult(permission: ${permission.displayName}, '
        'granted: $isGranted, permanentlyDenied: $isPermanentlyDenied)';
  }
}
