import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../permission_provider.dart';
import '../models/permission_type.dart';

class PermissionWrapper extends ConsumerStatefulWidget {
  final Widget child;
  final List<PermissionType> requiredPermissions;
  final Widget? loadingWidget;
  final Widget? permissionDeniedWidget;
  final String? title;
  final String? message;
  final VoidCallback? onPermissionsGranted;
  final VoidCallback? onPermissionsDenied;

  const PermissionWrapper({
    super.key,
    required this.child,
    required this.requiredPermissions,
    this.loadingWidget,
    this.permissionDeniedWidget,
    this.title,
    this.message,
    this.onPermissionsGranted,
    this.onPermissionsDenied,
  });

  @override
  ConsumerState<PermissionWrapper> createState() =>
      _PermissionWrapperState();
}

class _PermissionWrapperState
    extends ConsumerState<PermissionWrapper> {
  bool _isChecking = true;
  bool _permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    setState(() {
      _isChecking = true;
    });

    final actionNotifier = ref.read(
      permissionActionProvider.notifier,
    );
    final granted = await actionNotifier
        .initializeRequiredPermissions(
          context: context,
          requiredPermissions: widget.requiredPermissions,
          showInitialScreen: true,
          title: widget.title,
          message: widget.message,
        );

    setState(() {
      _permissionsGranted = granted;
      _isChecking = false;
    });

    if (granted) {
      widget.onPermissionsGranted?.call();
    } else {
      widget.onPermissionsDenied?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isChecking) {
      return widget.loadingWidget ??
          Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 3.w,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Checking permissions...',
                    style: GoogleFonts.urbanist(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.onSurface
                          .withAlpha(160),
                    ),
                  ),
                ],
              ),
            ),
          );
    }

    if (!_permissionsGranted) {
      return widget.permissionDeniedWidget ??
          Scaffold(
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.block_rounded,
                      size: 80.sp,
                      color: theme.colorScheme.error,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Permissions Required',
                      style: GoogleFonts.urbanist(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'This app requires ${widget.requiredPermissions.length} permission(s) to function.',
                      style: GoogleFonts.urbanist(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.onSurface
                            .withAlpha(160),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: _checkPermissions,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            theme.colorScheme.primary,
                        foregroundColor:
                            theme.colorScheme.onPrimary,
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.w,
                          vertical: 14.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Retry',
                        style: GoogleFonts.urbanist(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
    }

    return widget.child;
  }
}
