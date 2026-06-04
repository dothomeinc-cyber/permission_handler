// ignore_for_file: unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'
    as ph;
import 'models/permission_type.dart';
import 'models/permission_result.dart';
import 'widgets/permission_initial_dialog.dart';
import 'widgets/permission_denied_dialog.dart';
import 'widgets/permission_permanent_dialog.dart';

typedef PermissionExplanationCallback =
    Future<bool> Function(PermissionType permission);
typedef PermissionGroupExplanationCallback =
    Future<bool> Function(PermissionGroup group);

class PermissionManager {
  static final PermissionManager _instance =
      PermissionManager._internal();
  factory PermissionManager() => _instance;
  PermissionManager._internal() {
    _setupAutomaticLifecycleHandler();
    _startAutomaticCacheInvalidation();
  }

  final Map<PermissionType, _CachedPermission>
  _permissionCache = {};
  final StreamController<PermissionChangeEvent>
  _onPermissionChanged =
      StreamController<PermissionChangeEvent>.broadcast();

  Stream<PermissionChangeEvent> get onPermissionChanged =>
      _onPermissionChanged.stream;

  bool _isDisposed = false;
  bool _isInitialized = false; // Track initialization state
  AppLifecycleState _appLifecycleState =
      AppLifecycleState.resumed;
  Timer? _autoRefreshTimer;

  BuildContext? _currentContext;
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [];
  final List<VoidCallback> _pendingCallbacks =
      []; // Queue for pending operations

  final bool _autoInvalidateOnResume = true;
  final bool _autoRefreshPeriodically = true;
  final int _cacheTTLSeconds = 3;
  final int _periodicRefreshMinutes = 2;

  PermissionExplanationCallback? _onBeforePermissionRequest;
  PermissionGroupExplanationCallback? _onBeforeGroupRequest;

  final Map<PermissionType, String> _defaultExplanations = {
    PermissionType.camera:
        'We need camera access to take photos and scan documents',
    PermissionType.microphone:
        'We need microphone access for voice recording and calls',
    PermissionType.location:
        'We need location access to find nearby places',
    PermissionType.storage:
        'We need storage access to save and manage files',
    PermissionType.photos:
        'We need photo access to select and save images',
    PermissionType.videos:
        'We need video access to record and share videos',
    PermissionType.audio:
        'We need audio access to play and manage music',
    PermissionType.contacts:
        'We need contact access to share with friends',
    PermissionType.notifications:
        'We need notification access to send you alerts',
    PermissionType.calendarWriteOnly:
        'We need calendar access to schedule events',
    PermissionType.calendarFullAccess:
        'We need calendar access to manage events',
    PermissionType.reminders:
        'We need reminder access to set notifications',
    PermissionType.bluetooth:
        'We need bluetooth access to connect to devices',
    PermissionType.sensors:
        'We need sensor access for health tracking',
    PermissionType.sms:
        'We need SMS access to verify your number',
    PermissionType.phone:
        'We need phone access to make calls',
  };

  /// Mark manager as initialized (call after WidgetsFlutterBinding.ensureInitialized())
  void markInitialized() {
    if (!_isInitialized) {
      _isInitialized = true;
      _processPendingCallbacks();
    }
  }

  /// Process any pending operations that were queued before initialization
  void _processPendingCallbacks() {
    for (var callback in _pendingCallbacks) {
      callback();
    }
    _pendingCallbacks.clear();
  }

  /// Execute operation safely, queuing if not initialized
  void _safeExecute(VoidCallback operation) {
    if (_isInitialized) {
      operation();
    } else {
      _pendingCallbacks.add(operation);
    }
  }

  void registerNavigatorKey(GlobalKey<NavigatorState> key) {
    _safeExecute(() {
      if (!_navigatorKeys.contains(key)) {
        _navigatorKeys.add(key);
      }
    });
  }

  void unregisterNavigatorKey(
    GlobalKey<NavigatorState> key,
  ) {
    _safeExecute(() {
      _navigatorKeys.remove(key);
    });
  }

  void setCurrentContext(BuildContext context) {
    _safeExecute(() {
      _currentContext = context;
    });
  }

  void setOnBeforePermissionRequest(
    PermissionExplanationCallback? callback,
  ) {
    _safeExecute(() {
      _onBeforePermissionRequest = callback;
    });
  }

  void setOnBeforeGroupRequest(
    PermissionGroupExplanationCallback? callback,
  ) {
    _safeExecute(() {
      _onBeforeGroupRequest = callback;
    });
  }

  BuildContext? getCurrentContext() {
    if (!_isInitialized) return null;

    if (_currentContext != null &&
        _currentContext!.mounted) {
      return _currentContext;
    }
    for (var key in _navigatorKeys) {
      if (key.currentContext != null &&
          key.currentContext!.mounted) {
        return key.currentContext;
      }
    }
    return null;
  }

  Future<Map<PermissionType, PermissionResult>>
  checkPermissionsStatus(
    List<PermissionType> permissions, {
    bool bypassCache = false,
  }) async {
    if (_isDisposed) return {};
    final results = <PermissionType, PermissionResult>{};
    for (var permission in permissions) {
      if (!bypassCache &&
          _permissionCache.containsKey(permission)) {
        final cached = _permissionCache[permission]!;
        if (DateTime.now()
                .difference(cached.timestamp)
                .inSeconds <
            _cacheTTLSeconds) {
          results[permission] = cached.result;
          continue;
        }
      }
      final status = await permission.permission.status;
      final result = PermissionResult(
        permission: permission,
        isGranted: status.isGranted,
        isPermanentlyDenied: status.isPermanentlyDenied,
        status: status,
      );
      results[permission] = result;
      _permissionCache[permission] = _CachedPermission(
        result: result,
        timestamp: DateTime.now(),
      );
    }
    return results;
  }

  Future<PermissionResult> requestPermissionWithExplanation(
    PermissionType permission, {
    BuildContext? context,
    bool showExplanation = true,
  }) async {
    if (_isDisposed) {
      throw StateError(
        'PermissionManager has been disposed',
      );
    }

    if (!_isInitialized) {
      await Future.delayed(Duration.zero);
    }

    final ctx = context ?? getCurrentContext();

    final currentStatus =
        await permission.permission.status;

    if (currentStatus.isGranted) {
      final result = PermissionResult(
        permission: permission,
        isGranted: true,
        isPermanentlyDenied: false,
        status: currentStatus,
      );

      _permissionCache[permission] = _CachedPermission(
        result: result,
        timestamp: DateTime.now(),
      );

      return result;
    }

    if (currentStatus.isPermanentlyDenied) {
      final result = PermissionResult(
        permission: permission,
        isGranted: false,
        isPermanentlyDenied: true,
        status: currentStatus,
      );

      if (ctx != null && ctx.mounted) {
        await _showPermanentDenialDialog(ctx, permission);
      }

      return result;
    }

    if (showExplanation && ctx != null && ctx.mounted) {
      final shouldContinue =
          await _showAutoExplanationDialog(ctx, permission);

      if (!shouldContinue) {
        return PermissionResult(
          permission: permission,
          isGranted: false,
          isPermanentlyDenied: false,
          status: ph.PermissionStatus.denied,
        );
      }
    }

    final nativeStatus =
        await permission.permission.request();

    var result = PermissionResult(
      permission: permission,
      isGranted: nativeStatus.isGranted,
      isPermanentlyDenied: nativeStatus.isPermanentlyDenied,
      status: nativeStatus,
    );

    _permissionCache[permission] = _CachedPermission(
      result: result,
      timestamp: DateTime.now(),
    );

    _onPermissionChanged.add(
      PermissionChangeEvent(
        permission: permission,
        result: result,
      ),
    );

    if (!result.isGranted && ctx != null && ctx.mounted) {
      if (result.isPermanentlyDenied) {
        await _showPermanentDenialDialog(ctx, permission);
      } else {
        int retryCount = 0;

        while (retryCount < 2) {
          final retry = await _showDeniedDialog(ctx, [
            permission,
          ], retryCount);

          if (!retry) break;

          retryCount++;

          final retryStatus =
              await permission.permission.request();

          result = PermissionResult(
            permission: permission,
            isGranted: retryStatus.isGranted,
            isPermanentlyDenied:
                retryStatus.isPermanentlyDenied,
            status: retryStatus,
          );

          _permissionCache[permission] = _CachedPermission(
            result: result,
            timestamp: DateTime.now(),
          );

          _onPermissionChanged.add(
            PermissionChangeEvent(
              permission: permission,
              result: result,
            ),
          );

          if (result.isGranted) {
            break; // Success! Exit retry loop
          }

          if (result.isPermanentlyDenied) {
            await _showPermanentDenialDialog(
              ctx,
              permission,
            );
            break; // Exit loop, permanently denied
          }
        }
      }
    }

    return result;
  }

  Future<bool> _showAutoExplanationDialog(
    BuildContext context,
    PermissionType permission,
  ) async {
    if (!context.mounted) return false;

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder:
              (_) => PermissionInitialDialog(
                permissions: [permission],
                title:
                    '${permission.displayName} Permission Required',
                message: permission.description,
              ),
        ) ??
        false;
  }

  Future<bool> _showDeniedDialog(
    BuildContext context,
    List<PermissionType> permissions,
    int retryCount,
  ) async {
    if (!context.mounted) return false;

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder:
              (_) => PermissionDeniedDialog(
                permissions: permissions,
                retryCount: retryCount,
                maxRetries: 2,
              ),
        ) ??
        false;
  }

  Future<void> _showPermanentDenialDialog(
    BuildContext context,
    PermissionType permission,
  ) async {
    if (!context.mounted) return;

    final shouldOpenSettings =
        await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder:
              (_) => PermissionPermanentDialog(
                permissions: [permission],
                title:
                    '${permission.displayName} Permission Blocked',
                message:
                    '${permission.displayName} permission is permanently denied. Please enable it from app settings.',
              ),
        ) ??
        false;

    if (shouldOpenSettings) {
      await openAppSettings();
    }
  }

  Future<PermissionResult> requestPermission(
    PermissionType permission, {
    BuildContext? context,
  }) async {
    return await requestPermissionWithExplanation(
      permission,
      context: context,
    );
  }

  Future<Map<PermissionType, PermissionResult>>
  requestPermissions(
    List<PermissionType> permissions, {
    BuildContext? context,
  }) async {
    if (_isDisposed) return {};
    final results = <PermissionType, PermissionResult>{};
    final localContext = context;
    for (var permission in permissions) {
      final result = await requestPermission(
        permission,
        context: localContext,
      );
      results[permission] = result;
    }
    return results;
  }

  Future<Map<PermissionType, PermissionResult>>
  requestPermissionGroup(
    PermissionGroup group, {
    BuildContext? context,
  }) async {
    final results = <PermissionType, PermissionResult>{};
    final localContext = context;
    for (var permission in group.permissions) {
      final result = await requestPermission(
        permission,
        context: localContext,
      );
      results[permission] = result;
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
    if (_permissionCache.containsKey(permission)) {
      final cached = _permissionCache[permission]!;
      if (DateTime.now()
              .difference(cached.timestamp)
              .inSeconds <
          _cacheTTLSeconds) {
        return cached.result.isGranted;
      }
    }
    final status = await permission.permission.status;
    final isGranted = status.isGranted;
    _permissionCache[permission] = _CachedPermission(
      result: PermissionResult(
        permission: permission,
        isGranted: isGranted,
        isPermanentlyDenied: status.isPermanentlyDenied,
        status: status,
      ),
      timestamp: DateTime.now(),
    );
    return isGranted;
  }

  Future<bool> isPermissionPermanentlyDenied(
    PermissionType permission,
  ) async {
    if (_isDisposed) return false;
    if (_permissionCache.containsKey(permission)) {
      final cached = _permissionCache[permission]!;
      if (DateTime.now()
              .difference(cached.timestamp)
              .inSeconds <
          _cacheTTLSeconds) {
        return cached.result.isPermanentlyDenied;
      }
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
      bool allGranted = true;
      for (var permission in permissions) {
        if (!await isPermissionGranted(permission)) {
          allGranted = false;
          break;
        }
      }
      results[group] = allGranted;
    }
    return results;
  }

  void clearCache(PermissionType permission) {
    if (!_isDisposed) {
      _permissionCache.remove(permission);
    }
  }

  void clearAllCache() {
    if (!_isDisposed) {
      _permissionCache.clear();
    }
  }

  bool get isDisposed => _isDisposed;
  bool get isInitialized => _isInitialized;

  void dispose() {
    if (!_isDisposed) {
      _isDisposed = true;
      _autoRefreshTimer?.cancel();
      _onPermissionChanged.close();
      _permissionCache.clear();
      _pendingCallbacks.clear();
    }
  }

  // Private methods
  void _setupAutomaticLifecycleHandler() {
    // Ensure WidgetsBinding is available
    WidgetsBinding.instance.addObserver(
      AppLifecycleObserver(this),
    );
  }

  void _startAutomaticCacheInvalidation() {
    if (_autoRefreshPeriodically) {
      _autoRefreshTimer = Timer.periodic(
        Duration(minutes: _periodicRefreshMinutes),
        (_) => _automaticCacheRefresh(),
      );
    }
  }

  Future<void> _automaticCacheRefresh() async {
    if (_isDisposed || _permissionCache.isEmpty) return;
    await _refreshAllPermissions();
  }

  void onAppLifecycleStateChanged(AppLifecycleState state) {
    final previousState = _appLifecycleState;
    _appLifecycleState = state;
    if (previousState == AppLifecycleState.paused &&
        state == AppLifecycleState.resumed &&
        _autoInvalidateOnResume) {
      _refreshOnResume();
    }
  }

  Future<void> _refreshOnResume() async {
    await _refreshAllPermissions();
  }

  Future<void> _refreshAllPermissions() async {
    if (_isDisposed || _permissionCache.isEmpty) return;
    final permissionsToCheck =
        _permissionCache.keys.toList();
    final newResults = await checkPermissionsStatus(
      permissionsToCheck,
    );
    for (var entry in newResults.entries) {
      final cached = _permissionCache[entry.key];
      if (cached != null &&
          cached.result.isGranted !=
              entry.value.isGranted) {
        _onPermissionChanged.add(
          PermissionChangeEvent(
            permission: entry.key,
            result: entry.value,
          ),
        );
      }
      _permissionCache[entry.key] = _CachedPermission(
        result: entry.value,
        timestamp: DateTime.now(),
      );
    }
  }
}

class _CachedPermission {
  final PermissionResult result;
  final DateTime timestamp;
  _CachedPermission({
    required this.result,
    required this.timestamp,
  });
}

class AppLifecycleObserver extends WidgetsBindingObserver {
  final PermissionManager manager;
  AppLifecycleObserver(this.manager);
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    manager.onAppLifecycleStateChanged(state);
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
