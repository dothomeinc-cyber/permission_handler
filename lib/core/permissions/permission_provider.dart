import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:permission_handler/permission_handler.dart'
    as ph;
import 'permission_manager.dart';
import 'permission_state.dart';
import 'models/permission_type.dart';
import 'models/permission_result.dart';
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

final permissionGroupStatusProvider =
    FutureProvider.family<bool, PermissionGroup>((
      ref,
      group,
    ) async {
      final manager = ref.read(permissionManagerProvider);
      final results = await manager
          .checkGroupPermissionsStatus([group]);
      return results[group] ?? false;
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
  ) : super(const AsyncValue.data(null)) {
    _setupAutoListeners();
  }

  final PermissionManager _manager;
  final PermissionNotifier _stateNotifier;
  bool _isDisposed = false;

  void _setupAutoListeners() {
    _manager.onPermissionChanged.listen((event) {
      if (!_isDisposed) {
        _stateNotifier.updatePermissions({
          event.permission: event.result,
        });
      }
    });
  }


  Future<void> autoInitialize() async {
    if (_isDisposed) return;
    _stateNotifier.setLoading(true);
    try {
      final allPermissions = PermissionType.values;
      final results = await _manager.checkPermissionsStatus(
        allPermissions,
      );
      if (!_isDisposed) {
        _stateNotifier.updatePermissions(results);
      }
    } catch (e) {
      if (!_isDisposed) {
        _stateNotifier.setError(e.toString());
      }
    } finally {
      if (!_isDisposed) {
        _stateNotifier.setLoading(false);
      }
    }
  }

  Future<bool> initializeRequiredPermissions({
    required BuildContext context,
    required List<PermissionType> requiredPermissions,
    List<PermissionGroup>? requiredGroups,
    bool showInitialScreen = true,
    String? title,
    String? message,
  }) async {
    if (_isDisposed) return false;

    _stateNotifier.setLoading(true);

    try {
      List<PermissionType> allPermissions = List.from(
        requiredPermissions,
      );
      if (requiredGroups != null) {
        for (var group in requiredGroups) {
          allPermissions.addAll(group.permissions);
        }
      }

      final results = await _manager.checkPermissionsStatus(
        allPermissions,
      );

      if (!_isDisposed && context.mounted) {
        _stateNotifier.updatePermissions(results);
      }

      final allGranted = results.values.every(
        (r) => r.isGranted,
      );

      if (allGranted) {
        if (!_isDisposed && context.mounted) {
          _stateNotifier.setLoading(false);
        }
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
                  allPermissions
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

          if (!_isDisposed && context.mounted) {
            final newResults = await _manager
                .checkPermissionsStatus(allPermissions);
            _stateNotifier.updatePermissions(newResults);
            final allGrantedNow = newResults.values.every(
              (r) => r.isGranted,
            );
            _stateNotifier.setLoading(false);
            return allGrantedNow;
          }
        }

        if (!_isDisposed && context.mounted) {
          _stateNotifier.setLoading(false);
        }
        return false;
      }

      final missingPermissions =
          allPermissions
              .where((p) => !results[p]!.isGranted)
              .toList();

      if (missingPermissions.isNotEmpty &&
          context.mounted) {
        final requestResults = await _manager
            .requestPermissions(
              missingPermissions,
              context: context,
            );

        if (!_isDisposed && context.mounted) {
          _stateNotifier.updatePermissions(requestResults);
          final allGrantedNow = requestResults.values.every(
            (r) => r.isGranted,
          );
          _stateNotifier.setLoading(false);
          return allGrantedNow;
        }
      }

      if (!_isDisposed && context.mounted) {
        _stateNotifier.setLoading(false);
      }
      return false;
    } catch (e) {
      if (!_isDisposed && context.mounted) {
        _stateNotifier.setError(e.toString());
        _stateNotifier.setLoading(false);
      }
      return false;
    }
  }

  Future<bool> _showPermanentDenialDialog({
    required BuildContext context,
    required List<PermissionType> permissions,
    String? title,
    String? message,
  }) async {
    if (!context.mounted) return false;

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder:
              (_) => PermissionPermanentDialog(
                permissions: permissions,
                title: title,
                message: message,
              ),
        ) ??
        false;
  }

  Future<PermissionResult> requestIfNeeded(
    PermissionType permission, {
    BuildContext? context,
  }) async {
    if (_isDisposed) {
      return PermissionResult(
        permission: permission,
        isGranted: false,
        isPermanentlyDenied: false,
        status: ph.PermissionStatus.denied,
      );
    }

    final isGranted = await _manager.isPermissionGranted(
      permission,
    );
    if (isGranted) {
      return PermissionResult(
        permission: permission,
        isGranted: true,
        isPermanentlyDenied: false,
        status: ph.PermissionStatus.granted,
      );
    }

    final localContext = context;
    return await _manager.requestPermission(
      permission,
      // ignore: use_build_context_synchronously
      context: localContext,
    );
  }

  Future<PermissionResult> requestSinglePermission(
    PermissionType permission, {
    BuildContext? context,
  }) async {
    if (_isDisposed) {
      return PermissionResult(
        permission: permission,
        isGranted: false,
        isPermanentlyDenied: false,
        status: ph.PermissionStatus.denied,
      );
    }

    final localContext = context;
    return await _manager.requestPermission(
      permission,
      context: localContext,
    );
  }

  Future<Map<PermissionType, PermissionResult>>
  requestPermissionGroup(
    PermissionGroup group, {
    BuildContext? context,
  }) async {
    if (_isDisposed) return {};

    final localContext = context;
    return await _manager.requestPermissionGroup(
      group,
      context: localContext,
    );
  }

  void reset() {
    if (!_isDisposed) {
      _stateNotifier.reset();
      _manager.clearAllCache();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}

final permissionActionProvider = StateNotifierProvider<
  PermissionActionNotifier,
  AsyncValue<void>
>((ref) {
  final manager = ref.watch(permissionManagerProvider);
  final stateNotifier = ref.watch(
    permissionStateProvider.notifier,
  );
  final notifier = PermissionActionNotifier(
    manager,
    stateNotifier,
  );

  // addPostFrameCallback runs after the first frame, which is always after
  // PermissionHandler.initialize() has been awaited in main(). This avoids
  // the race where autoInitialize() checks _isInitialized before
  // markInitialized() has been called.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    try {
      notifier.autoInitialize();
    } catch (_) {
      // Notifier may already be disposed if the provider was invalidated
      // before the first frame completed.
    }
  });

  ref.onDispose(() => notifier.dispose());
  return notifier;
});
