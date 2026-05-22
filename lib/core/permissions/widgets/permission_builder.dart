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
  @override
  Widget build(BuildContext context) {
    final permissionStatus = ref.watch(
      permissionStatusProvider(widget.permission),
    );

    return permissionStatus.when(
      data: (isGranted) {
        if (!isGranted) {
          return widget.deniedWidget ??
              GestureDetector(
                onTap: () => _requestPermission(),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(
                      8.r,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        color:
                            Theme.of(
                              context,
                            ).colorScheme.primary,
                        size: 20.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          '${widget.permission.displayName} permission required. Tap to grant.',
                          style: GoogleFonts.urbanist(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
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
          (_, _) => Center(
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
                    fontWeight: FontWeight.w400,
                    color:
                        Theme.of(context).colorScheme.error,
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

  Future<void> _requestPermission() async {
    final actionNotifier = ref.read(
      permissionActionProvider.notifier,
    );
    await actionNotifier.initializeRequiredPermissions(
      context: context,
      requiredPermissions: [widget.permission],
      showInitialScreen: true,
    );
    ref.invalidate(
      permissionStatusProvider(widget.permission),
    );
  }
}
