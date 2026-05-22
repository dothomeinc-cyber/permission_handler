import 'package:flutter/material.dart';
import 'models/permission_type.dart';
import 'models/permission_result.dart';

@immutable
class PermissionState {
  final Map<PermissionType, PermissionResult> permissions;
  final bool isInitialized;
  final bool isLoading;
  final String? error;

  const PermissionState({
    required this.permissions,
    this.isInitialized = false,
    this.isLoading = false,
    this.error,
  });

  factory PermissionState.initial() {
    return const PermissionState(
      permissions: {},
      isInitialized: false,
      isLoading: false,
      error: null,
    );
  }

  PermissionState copyWith({
    Map<PermissionType, PermissionResult>? permissions,
    bool? isInitialized,
    bool? isLoading,
    Object? error,
  }) {
    return PermissionState(
      permissions: permissions ?? this.permissions,
      isInitialized: isInitialized ?? this.isInitialized,
      isLoading: isLoading ?? this.isLoading,
      error: error == null ? this.error : error as String?,
    );
  }

  bool isPermissionGranted(PermissionType permission) {
    return permissions[permission]?.isGranted ?? false;
  }

  bool isPermissionPermanentlyDenied(
    PermissionType permission,
  ) {
    return permissions[permission]?.isPermanentlyDenied ??
        false;
  }

  List<PermissionType> getGrantedPermissions() {
    return permissions.entries
        .where((entry) => entry.value.isGranted)
        .map((entry) => entry.key)
        .toList();
  }

  List<PermissionType> getDeniedPermissions() {
    return permissions.entries
        .where((entry) => !entry.value.isGranted)
        .map((entry) => entry.key)
        .toList();
  }
}

class PermissionNotifier extends ChangeNotifier {
  PermissionState _state = PermissionState.initial();

  PermissionState get state => _state;

  void updatePermissions(
    Map<PermissionType, PermissionResult> permissions,
  ) {
    _state = _state.copyWith(
      permissions: {..._state.permissions, ...permissions},
      isInitialized: true,
    );
    notifyListeners();
  }

  void setLoading(bool loading) {
    _state = _state.copyWith(isLoading: loading);
    notifyListeners();
  }

  void setError(String error) {
    _state = _state.copyWith(error: error);
    notifyListeners();
  }

  void clearError() {
    _state = _state.copyWith(error: null);
    notifyListeners();
  }

  void reset() {
    _state = PermissionState.initial();
    notifyListeners();
  }
}
