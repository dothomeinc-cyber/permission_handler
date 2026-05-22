import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'permission_manager.dart';
import 'permission_state.dart';
import 'models/permission_type.dart';
import 'models/permission_result.dart';
import 'widgets/permission_initial_dialog.dart';
import 'widgets/permission_denied_dialog.dart';
import 'widgets/permission_permanent_dialog.dart';

final permissionManagerProvider =
    Provider<PermissionManager>((ref) {
      return PermissionManager();
    });

final permissionStateProvider =
    ChangeNotifierProvider<PermissionNotifier>((ref) {
      return PermissionNotifier();
    });

final permissionStatusProvider =
    FutureProvider.family<bool, PermissionType>((
      ref,
      permission,
    ) async {
      final manager = ref.read(permissionManagerProvider);
      return await manager.isPermissionGranted(permission);
    });

final permissionsStatusProvider = FutureProvider.family<
  Map<PermissionType, bool>,
  List<PermissionType>
>((ref, permissions) async {
  final manager = ref.read(permissionManagerProvider);
  final results = <PermissionType, bool>{};

  for (var permission in permissions) {
    final isGranted = await manager.isPermissionGranted(
      permission,
    );
    results[permission] = isGranted;
  }

  return results;
});

class PermissionActionNotifier
    extends StateNotifier<AsyncValue<void>> {
  PermissionActionNotifier(
    this._manager,
    this._stateNotifier,
  ) : super(const AsyncValue.data(null));

  final PermissionManager _manager;
  final PermissionNotifier _stateNotifier;

  Future<bool> initializeRequiredPermissions({
    required BuildContext context,
    required List<PermissionType> requiredPermissions,
    bool showInitialScreen = true,
    String? title,
    String? message,
  }) async {
    _stateNotifier.setLoading(true);

    try {
      final results = await _manager.checkPermissionsStatus(
        requiredPermissions,
      );
      _stateNotifier.updatePermissions(results);

      final allGranted = results.values.every(
        (r) => r.isGranted,
      );

      if (allGranted) {
        _stateNotifier.setLoading(false);
        return true;
      }

      final hasPermanentDenial = results.values.any(
        (r) => r.isPermanentlyDenied,
      );

      if (hasPermanentDenial && context.mounted) {
        final shouldOpenSettings =
            await _showPermanentDenialDialog(
              context: context,
              permissions:
                  requiredPermissions
                      .where(
                        (p) =>
                            results[p]
                                ?.isPermanentlyDenied ==
                            true,
                      )
                      .toList(),
              title: title,
              message: message,
            );

        if (shouldOpenSettings && context.mounted) {
          await _manager.openAppSettings();
          await Future.delayed(
            const Duration(milliseconds: 500),
          );

          final newResults = await _manager
              .checkPermissionsStatus(requiredPermissions);
          _stateNotifier.updatePermissions(newResults);

          final allGrantedNow = newResults.values.every(
            (r) => r.isGranted,
          );
          _stateNotifier.setLoading(false);
          return allGrantedNow;
        }

        _stateNotifier.setLoading(false);
        return false;
      }

      if (showInitialScreen && context.mounted) {
        final shouldRequest =
            await _showInitialPermissionScreen(
              context: context,
              permissions: requiredPermissions,
              title: title,
              message: message,
            );

        if (shouldRequest && context.mounted) {
          final requestResults =
              await _requestPermissionsWithRetry(
                context: context,
                permissions: requiredPermissions,
              );

          _stateNotifier.updatePermissions(requestResults);
          final allGrantedNow = requestResults.values.every(
            (r) => r.isGranted,
          );

          _stateNotifier.setLoading(false);
          return allGrantedNow;
        }
      }

      _stateNotifier.setLoading(false);
      return false;
    } catch (e) {
      _stateNotifier.setError(e.toString());
      _stateNotifier.setLoading(false);
      return false;
    }
  }

  Future<Map<PermissionType, PermissionResult>>
  _requestPermissionsWithRetry({
    required BuildContext context,
    required List<PermissionType> permissions,
    int maxRetries = 2,
  }) async {
    int retryCount = 0;

    while (retryCount < maxRetries) {
      final results = await _manager.requestPermissions(
        permissions,
      );
      final allGranted = results.values.every(
        (r) => r.isGranted,
      );

      if (allGranted) {
        return results;
      }

      final hasPermanentDenial = results.values.any(
        (r) => r.isPermanentlyDenied,
      );

      if (hasPermanentDenial && context.mounted) {
        final shouldOpenSettings =
            await _showPermanentDenialDialog(
              context: context,
              permissions:
                  permissions
                      .where(
                        (p) =>
                            results[p]
                                ?.isPermanentlyDenied ==
                            true,
                      )
                      .toList(),
            );

        if (shouldOpenSettings && context.mounted) {
          await _manager.openAppSettings();
          await Future.delayed(
            const Duration(milliseconds: 500),
          );
          retryCount++;
          continue;
        }
        return results;
      }

      if (context.mounted) {
        final shouldRetry = await _showDenialDialog(
          context: context,
          permissions:
              permissions
                  .where((p) => !results[p]!.isGranted)
                  .toList(),
          retryCount: retryCount,
          maxRetries: maxRetries,
        );

        if (!shouldRetry) {
          return results;
        }
      }

      retryCount++;
    }

    return await _manager.checkPermissionsStatus(
      permissions,
    );
  }

  Future<bool> _showInitialPermissionScreen({
    required BuildContext context,
    required List<PermissionType> permissions,
    String? title,
    String? message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => PermissionInitialDialog(
            permissions: permissions,
            title: title,
            message: message,
          ),
    );
    return result ?? false;
  }

  Future<bool> _showDenialDialog({
    required BuildContext context,
    required List<PermissionType> permissions,
    required int retryCount,
    required int maxRetries,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => PermissionDeniedDialog(
            permissions: permissions,
            retryCount: retryCount,
            maxRetries: maxRetries,
          ),
    );
    return result ?? false;
  }

  Future<bool> _showPermanentDenialDialog({
    required BuildContext context,
    required List<PermissionType> permissions,
    String? title,
    String? message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => PermissionPermanentDialog(
            permissions: permissions,
            title: title,
            message: message,
          ),
    );
    return result ?? false;
  }

  Future<PermissionResult> requestSinglePermission(
    PermissionType permission,
  ) async {
    try {
      final result = await _manager.requestPermission(
        permission,
      );
      _stateNotifier.updatePermissions({
        permission: result,
      });
      return result;
    } catch (e) {
      rethrow;
    }
  }

  void reset() {
    _stateNotifier.reset();
  }
}

final permissionActionProvider = StateNotifierProvider<
  PermissionActionNotifier,
  AsyncValue<void>
>((ref) {
  final manager = ref.read(permissionManagerProvider);
  final stateNotifier = ref.read(
    permissionStateProvider.notifier,
  );
  return PermissionActionNotifier(manager, stateNotifier);
});
