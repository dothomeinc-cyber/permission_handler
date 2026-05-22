import 'dart:async';

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

  Future<Map<PermissionType, PermissionResult>>
  checkPermissionsStatus(
    List<PermissionType> permissions,
  ) async {
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
    final status = await permission.permission.request();
    final result = PermissionResult(
      permission: permission,
      isGranted: status.isGranted,
      isPermanentlyDenied: status.isPermanentlyDenied,
      status: status,
    );

    _permissionCache[permission] = result;
    _onPermissionChanged.add(
      PermissionChangeEvent(
        permission: permission,
        result: result,
      ),
    );

    return result;
  }

  Future<Map<PermissionType, PermissionResult>>
  requestPermissions(
    List<PermissionType> permissions,
  ) async {
    final results = <PermissionType, PermissionResult>{};

    for (var permission in permissions) {
      final result = await requestPermission(permission);
      results[permission] = result;
    }

    return results;
  }

  Future<void> openAppSettings() async {
    await ph.openAppSettings();
  }

  Future<bool> isPermissionGranted(
    PermissionType permission,
  ) async {
    final status = await permission.permission.status;
    return status.isGranted;
  }

  Future<bool> isPermissionPermanentlyDenied(
    PermissionType permission,
  ) async {
    final status = await permission.permission.status;
    return status.isPermanentlyDenied;
  }

  void dispose() {
    _onPermissionChanged.close();
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
