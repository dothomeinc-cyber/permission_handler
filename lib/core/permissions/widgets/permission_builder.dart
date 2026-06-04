import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../permission_provider.dart';
import '../models/permission_type.dart';

class PermissionBuilder extends ConsumerStatefulWidget {
  final PermissionType permission;
  final Widget Function(
    BuildContext context,
    bool isGranted,
  )
  builder;
  final Widget? loadingWidget;
  final Widget? deniedWidget;

  const PermissionBuilder({
    super.key,
    required this.permission,
    required this.builder,
    this.loadingWidget,
    this.deniedWidget,
  });

  @override
  ConsumerState<PermissionBuilder> createState() =>
      _PermissionBuilderState();
}

class _PermissionBuilderState
    extends ConsumerState<PermissionBuilder> {
  bool _isPermanentlyDenied = false;
  bool _isCheckingPermanent = true;

  @override
  void initState() {
    super.initState();
    _checkPermanentDenial();
  }

  Future<void> _checkPermanentDenial() async {
    final manager = ref.read(permissionManagerProvider);
    final isPermanent = await manager
        .isPermissionPermanentlyDenied(widget.permission);

    if (mounted) {
      setState(() {
        _isPermanentlyDenied = isPermanent;
        _isCheckingPermanent = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final permissionStatus = ref.watch(
      permissionStatusProvider(widget.permission),
    );

    return permissionStatus.when(
      data: (isGranted) {
        if (!isGranted) {
          return widget.deniedWidget ??
              _buildPermissionDeniedCard(context);
        }
        return widget.builder(context, isGranted);
      },
      loading:
          () =>
              widget.loadingWidget ??
              Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3.w,
                ),
              ),
      error:
          (_, __) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48.sp,
                  color:
                      Theme.of(context).colorScheme.error,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Error checking permission',
                  style: GoogleFonts.urbanist(
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                TextButton(
                  onPressed:
                      () => ref.invalidate(
                        permissionStatusProvider(
                          widget.permission,
                        ),
                      ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildPermissionDeniedCard(BuildContext context) {
    final theme = Theme.of(context);

    if (_isCheckingPermanent) {
      return Center(
        child: CircularProgressIndicator(strokeWidth: 3.w),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color:
                    _isPermanentlyDenied
                        ? theme.colorScheme.error.withAlpha(
                          30,
                        )
                        : theme.colorScheme.primary
                            .withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPermanentlyDenied
                    ? Icons.block_rounded
                    : Icons.lock_outline_rounded,
                size: 48.sp,
                color:
                    _isPermanentlyDenied
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              _isPermanentlyDenied
                  ? '${widget.permission.displayName} Blocked'
                  : '${widget.permission.displayName} Required',
              style: GoogleFonts.urbanist(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              _isPermanentlyDenied
                  ? '${widget.permission.displayName} permission has been permanently denied. Please enable it in device settings to use this feature.'
                  : widget.permission.description,
              style: GoogleFonts.urbanist(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurface
                    .withAlpha(180),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _isPermanentlyDenied
                        ? _openSettings
                        : _requestPermission,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isPermanentlyDenied
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                  foregroundColor:
                      _isPermanentlyDenied
                          ? theme.colorScheme.onError
                          : theme.colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 14.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      12.r,
                    ),
                  ),
                ),
                child: Text(
                  _isPermanentlyDenied
                      ? 'Open Settings'
                      : 'Allow Permission',
                  style: GoogleFonts.urbanist(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openSettings() async {
    final manager = ref.read(permissionManagerProvider);
    await manager.openAppSettings();

    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      ref.invalidate(
        permissionStatusProvider(widget.permission),
      );
      await _checkPermanentDenial();
    }
  }

  Future<void> _requestPermission() async {
    final actionNotifier = ref.read(
      permissionActionProvider.notifier,
    );

    await actionNotifier.requestSinglePermission(
      widget.permission,
      context: context,
    );

    if (!mounted) return;

    await _checkPermanentDenial();

    ref.invalidate(
      permissionStatusProvider(widget.permission),
    );
  }
}
