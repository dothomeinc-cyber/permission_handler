import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler_package/permission_handler_package.dart';
import 'auth_theme.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissionState = ref.watch(
      permissionStateProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final manager = ref.read(
                permissionManagerProvider,
              );
              await manager.openAppSettings();
            },
          ),
        ],
      ),
      body: PermissionWrapper(
        requiredPermissions: [PermissionType.camera],
        title: 'Camera Permission',
        message: 'This feature requires camera access',
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              _buildPermissionCard(
                context,
                ref,
                PermissionType.camera,
                'Camera Feature',
                'Take photos and scan documents',
                Icons.camera_alt,
              ),
              SizedBox(height: 16.h),
              _buildPermissionCard(
                context,
                ref,
                PermissionType.storage,
                'Storage Access',
                'Save and manage files',
                Icons.storage,
              ),
              SizedBox(height: 16.h),
              _buildPermissionCard(
                context,
                ref,
                PermissionType.location,
                'Location Services',
                'Find nearby places and get directions',
                Icons.location_on,
              ),
              SizedBox(height: 16.h),
              _buildPermissionCard(
                context,
                ref,
                PermissionType.microphone,
                'Microphone Access',
                'Record audio and voice messages',
                Icons.mic,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionCard(
    BuildContext context,
    WidgetRef ref,
    PermissionType permission,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final isGrantedAsync = ref.watch(
      permissionStatusProvider(permission),
    );

    return isGrantedAsync.when(
      data: (isGranted) {
        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AuthColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color:
                  isGranted
                      ? AuthColors.success
                      : AuthColors.error,
              width: 1.w,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color:
                      isGranted
                          ? AuthColors.success.withOpacity(
                            0.1,
                          )
                          : AuthColors.error.withOpacity(
                            0.1,
                          ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isGranted
                      ? Icons.check_circle
                      : Icons.block,
                  color:
                      isGranted
                          ? AuthColors.success
                          : AuthColors.error,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          icon,
                          size: 18.sp,
                          color: AuthColors.black80,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          title,
                          style: AuthTextStyles.titleM,
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: AuthTextStyles.caption,
                    ),
                    if (!isGranted) ...[
                      SizedBox(height: 12.h),
                      GestureDetector(
                        onTap: () async {
                          final actionNotifier = ref.read(
                            permissionActionProvider
                                .notifier,
                          );
                          await actionNotifier
                              .initializeRequiredPermissions(
                                context: context,
                                requiredPermissions: [
                                  permission,
                                ],
                                showInitialScreen: true,
                              );
                          ref.invalidate(
                            permissionStatusProvider(
                              permission,
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: AuthColors.yellow,
                            borderRadius:
                                BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            'Grant Permission',
                            style: AuthTextStyles.labelM
                                .copyWith(fontSize: 12.sp),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isGranted)
                Icon(
                  Icons.chevron_right,
                  size: 20.sp,
                  color: AuthColors.black50,
                ),
            ],
          ),
        );
      },
      loading:
          () => Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AuthColors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      error:
          (_, __) => Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AuthColors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: const Center(
              child: Text('Error checking permission'),
            ),
          ),
    );
  }
}
