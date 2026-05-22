import 'dart:async';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart'
    as ph;
import 'models/permission_type.dart';
import 'models/permission_result.dart';

typedef PermissionExplanationCallback =
    Future<bool> Function(PermissionType permission);
typedef PermissionGroupExplanationCallback =
    Future<bool> Function(PermissionGroup group);

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

  // Custom explanation callbacks
  PermissionExplanationCallback? _onBeforePermissionRequest;
  PermissionGroupExplanationCallback? _onBeforeGroupRequest;

  /// Set callback for showing custom explanation before requesting permission
  void setOnBeforePermissionRequest(
    PermissionExplanationCallback callback,
  ) {
    _onBeforePermissionRequest = callback;
  }

  /// Set callback for showing custom explanation before requesting permission group
  void setOnBeforeGroupRequest(
    PermissionGroupExplanationCallback callback,
  ) {
    _onBeforeGroupRequest = callback;
  }

  /// Request permission with optional explanation
  Future<PermissionResult> requestPermissionWithExplanation(
    PermissionType permission, {
    bool showExplanation = true,
  }) async {
    if (_isDisposed) {
      throw StateError(
        'PermissionManager has been disposed',
      );
    }

    // Show custom explanation if requested and callback is set
    if (showExplanation &&
        _onBeforePermissionRequest != null) {
      final shouldContinue =
          await _onBeforePermissionRequest!(permission);
      if (!shouldContinue) {
        return PermissionResult(
          permission: permission,
          isGranted: false,
          isPermanentlyDenied: false,
          status: ph.PermissionStatus.denied,
        );
      }
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

  /// Request permission group with explanation
  Future<Map<PermissionType, PermissionResult>>
  requestPermissionGroup(
    PermissionGroup group, {
    bool showExplanation = true,
  }) async {
    if (_isDisposed) return {};

    // Show custom group explanation if requested and callback is set
    if (showExplanation && _onBeforeGroupRequest != null) {
      final shouldContinue = await _onBeforeGroupRequest!(
        group,
      );
      if (!shouldContinue) {
        return {};
      }
    }

    final permissions = group.permissions;
    final results = <PermissionType, PermissionResult>{};

    for (var permission in permissions) {
      final result = await requestPermissionWithExplanation(
        permission,
        showExplanation: false, // Already shown for group
      );
      results[permission] = result;
    }

    return results;
  }

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

  Future<PermissionResult> requestPermission(
    PermissionType permission,
  ) async {
    return await requestPermissionWithExplanation(
      permission,
    );
  }

  Future<Map<PermissionType, PermissionResult>>
  requestPermissions(
    List<PermissionType> permissions,
  ) async {
    if (_isDisposed) return {};

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

  Future<void> openAppSettings() async {
    if (!_isDisposed) {
      await ph.openAppSettings();
    }
  }

  Future<bool> isPermissionGranted(
    PermissionType permission,
  ) async {
    if (_isDisposed) return false;

    if (!_isPermissionSupported(permission)) {
      return false;
    }

    final status = await permission.permission.status;
    return status.isGranted;
  }

  Future<bool> isPermissionPermanentlyDenied(
    PermissionType permission,
  ) async {
    if (_isDisposed) return false;

    if (!_isPermissionSupported(permission)) {
      return false;
    }

    final status = await permission.permission.status;
    return status.isPermanentlyDenied;
  }

  Future<Map<PermissionGroup, bool>>
  checkGroupPermissionsStatus(
    List<PermissionGroup> groups,
  ) async {
    final results = <PermissionGroup, bool>{};

    for (var group in groups) {
      final permissions = group.permissions;
      if (permissions.isEmpty) {
        results[group] = false;
        continue;
      }

      final statuses = await checkPermissionsStatus(
        permissions,
      );
      final allGranted = statuses.values.every(
        (r) => r.isGranted,
      );
      results[group] = allGranted;
    }

    return results;
  }

  bool _isPermissionSupported(PermissionType permission) {
    if (Platform.isIOS) {
      switch (permission) {
        // Supported on iOS
        case PermissionType.photos:
        case PermissionType.videos:
        case PermissionType.audio:
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
        case PermissionType.appTrackingTransparency:
        case PermissionType.criticalAlerts:
          return true;

        // Not supported or different on iOS
        case PermissionType.sms:
        case PermissionType.phone:
        case PermissionType.storage:
          return false;

        default:
          return true;
      }
    }

    if (Platform.isAndroid) {
      switch (permission) {
        // Not supported on Android (iOS only)
        case PermissionType.photos:
        case PermissionType.videos:
        case PermissionType.audio:
        case PermissionType.reminders:
          return false;

        // Supported on Android
        case PermissionType.storage:
        case PermissionType.camera:
        case PermissionType.microphone:
        case PermissionType.contacts:
        case PermissionType.location:
        case PermissionType.locationAlways:
        case PermissionType.locationWhenInUse:
        case PermissionType.notifications:
        case PermissionType.calendar:
        case PermissionType.bluetooth:
        case PermissionType.sensors:
        case PermissionType.phone:
        case PermissionType.sms:
        case PermissionType.scheduleExactAlarm:
        case PermissionType.ignoreBatteryOptimizations:
        case PermissionType.manageExternalStorage:
        case PermissionType.systemAlertWindow:
        case PermissionType.requestInstallPackages:
        case PermissionType.accessNotificationPolicy:
          return true;

        default:
          return true;
      }
    }

    return false;
  }

  /// Check if a permission group is supported on current platform
  bool isGroupSupported(PermissionGroup group) {
    if (Platform.isIOS) {
      switch (group) {
        case PermissionGroup.media:
          return true; // photos, videos, audio are supported on iOS
        case PermissionGroup.communication:
          return true;
        case PermissionGroup.locationServices:
          return true;
        case PermissionGroup.calendar:
          return true;
        case PermissionGroup.bluetooth:
          return true;
        case PermissionGroup.sensors:
          return true;
        case PermissionGroup.phone:
          return false; // Phone/SMS not fully supported on iOS
        case PermissionGroup.other:
          return true;
      }
    }

    if (Platform.isAndroid) {
      switch (group) {
        case PermissionGroup.media:
          return true; // storage permission on Android
        case PermissionGroup.communication:
          return true;
        case PermissionGroup.locationServices:
          return true;
        case PermissionGroup.calendar:
          return true;
        case PermissionGroup.bluetooth:
          return true;
        case PermissionGroup.sensors:
          return true;
        case PermissionGroup.phone:
          return true;
        case PermissionGroup.other:
          return true;
      }
    }

    return false;
  }

  /// Get platform-specific permission note
  String getPlatformNote(PermissionType permission) {
    if (Platform.isIOS) {
      switch (permission) {
        case PermissionType.photos:
          return 'iOS requires separate permission for photos';
        case PermissionType.videos:
          return 'iOS requires separate permission for videos';
        case PermissionType.audio:
          return 'iOS requires separate permission for audio';
        case PermissionType.storage:
          return 'iOS uses limited file system access';
        default:
          return '';
      }
    }

    if (Platform.isAndroid) {
      switch (permission) {
        case PermissionType.photos:
        case PermissionType.videos:
        case PermissionType.audio:
          return 'Android uses storage permission for media access';
        default:
          return '';
      }
    }

    return '';
  }

  bool isPlatformSupported() {
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Clear cache for specific permission
  void clearCache(PermissionType permission) {
    _permissionCache.remove(permission);
  }

  /// Clear all cache
  void clearAllCache() {
    _permissionCache.clear();
  }

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
