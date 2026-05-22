import 'dart:async';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart'
    as ph;
import 'models/permission_type.dart';
import 'models/permission_result.dart';

class PermissionManager {
  static final PermissionManager _instance =
      PermissionManager._internal();
  factory PermissionManager() => _instance;
  PermissionManager._internal();

  final Map<PermissionType, PermissionResult>
  _permissionCache = {};
  final StreamController<PermissionChangeEvent>
  _onPermissionChanged =
      StreamController<PermissionChangeEvent>.broadcast();

  Stream<PermissionChangeEvent> get onPermissionChanged =>
      _onPermissionChanged.stream;

  bool _isDisposed = false;

  Future<Map<PermissionType, PermissionResult>>
  checkPermissionsStatus(
    List<PermissionType> permissions,
  ) async {
    if (_isDisposed) return {};

    final results = <PermissionType, PermissionResult>{};

    for (var permission in permissions) {
      final status = await permission.permission.status;
      final result = PermissionResult(
        permission: permission,
        isGranted: status.isGranted,
        isPermanentlyDenied: status.isPermanentlyDenied,
        status: status,
      );

      results[permission] = result;
      _permissionCache[permission] = result;
    }

    return results;
  }

  /// Request single permission
  Future<PermissionResult> requestPermission(
    PermissionType permission,
  ) async {
    if (_isDisposed) {
      throw StateError(
        'PermissionManager has been disposed',
      );
    }

    final status = await permission.permission.request();
    final result = PermissionResult(
      permission: permission,
      isGranted: status.isGranted,
      isPermanentlyDenied: status.isPermanentlyDenied,
      status: status,
    );

    _permissionCache[permission] = result;
    if (!_isDisposed) {
      _onPermissionChanged.add(
        PermissionChangeEvent(
          permission: permission,
          result: result,
        ),
      );
    }

    return result;
  }

  /// Request multiple permissions in batch for better performance
  Future<Map<PermissionType, PermissionResult>>
  requestPermissions(
    List<PermissionType> permissions,
  ) async {
    if (_isDisposed) return {};

    // Use batch request for better performance
    final phPermissions =
        permissions.map((p) => p.permission).toList();
    final statuses = await phPermissions.request();

    final results = <PermissionType, PermissionResult>{};

    for (var i = 0; i < permissions.length; i++) {
      final permission = permissions[i];
      final status = statuses[phPermissions[i]];

      if (status != null) {
        final result = PermissionResult(
          permission: permission,
          isGranted: status.isGranted,
          isPermanentlyDenied: status.isPermanentlyDenied,
          status: status,
        );

        results[permission] = result;
        _permissionCache[permission] = result;

        if (!_isDisposed) {
          _onPermissionChanged.add(
            PermissionChangeEvent(
              permission: permission,
              result: result,
            ),
          );
        }
      }
    }

    return results;
  }

  /// Open app settings
  Future<void> openAppSettings() async {
    if (!_isDisposed) {
      await ph.openAppSettings();
    }
  }

  /// Check if permission is granted with platform support check
  Future<bool> isPermissionGranted(
    PermissionType permission,
  ) async {
    if (_isDisposed) return false;

    // Platform-specific permission checks
    if (!_isPermissionSupported(permission)) {
      return false;
    }

    final status = await permission.permission.status;
    return status.isGranted;
  }

  /// Check if permission is permanently denied with platform support check
  Future<bool> isPermissionPermanentlyDenied(
    PermissionType permission,
  ) async {
    if (_isDisposed) return false;

    // Platform-specific permission checks
    if (!_isPermissionSupported(permission)) {
      return false;
    }

    final status = await permission.permission.status;
    return status.isPermanentlyDenied;
  }

  /// Check if permission is supported on current platform
  bool _isPermissionSupported(PermissionType permission) {
    // iOS-specific permissions
    if (Platform.isIOS) {
      switch (permission) {
        case PermissionType.photos:
        case PermissionType.reminders:
        case PermissionType.locationAlways:
        case PermissionType.locationWhenInUse:
        case PermissionType.notifications:
        case PermissionType.camera:
        case PermissionType.microphone:
        case PermissionType.contacts:
        case PermissionType.calendar:
        case PermissionType.bluetooth:
        case PermissionType.sensors:
          return true;
        case PermissionType.sms:
        case PermissionType.phone:
        case PermissionType.storage:
          return false; // Not supported or different on iOS
        default:
          return true;
      }
    }

    // Android-specific permissions
    if (Platform.isAndroid) {
      switch (permission) {
        case PermissionType.photos:
          return false; // Uses storage on Android
        case PermissionType.reminders:
          return false; // Uses calendar on Android
        default:
          return true;
      }
    }

    return false; // Unsupported platform
  }

  /// Check if platform is supported
  bool isPlatformSupported() {
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Dispose resources safely
  void dispose() {
    if (!_isDisposed) {
      _isDisposed = true;
      _onPermissionChanged.close();
      _permissionCache.clear();
    }
  }
}

class PermissionChangeEvent {
  final PermissionType permission;
  final PermissionResult result;

  PermissionChangeEvent({
    required this.permission,
    required this.result,
  });
}
