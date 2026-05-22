import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler_package/permission_handler_package.dart';
import 'auth_theme.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    _setupPermissionCallbacks();
  }

  void _setupPermissionCallbacks() {
    final actionNotifier = ref.read(
      permissionActionProvider.notifier,
    );

    actionNotifier.setPermissionExplanationCallback((
      permission,
    ) async {
      return await _showCustomExplanationDialog(
        title: 'Why do we need ${permission.displayName}?',
        message: permission.description,
        icon: permission.icon,
      );
    });

    actionNotifier.setGroupExplanationCallback((
      group,
    ) async {
      return await _showCustomExplanationDialog(
        title:
            'Why do we need ${group.displayName} access?',
        message:
            'This app needs ${group.displayName} permissions to provide core functionality.',
        icon: group.icon,
      );
    });
  }

  Future<bool> _showCustomExplanationDialog({
    required String title,
    required String message,
    required String icon,
  }) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => AlertDialog(
                title: Row(
                  children: [
                    Text(
                      icon,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(title)),
                  ],
                ),
                content: Text(message),
                actions: [
                  TextButton(
                    onPressed:
                        () => Navigator.pop(context, false),
                    child: const Text('Not Now'),
                  ),
                  ElevatedButton(
                    onPressed:
                        () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AuthColors.yellow,
                      foregroundColor: AuthColors.black,
                    ),
                    child: const Text('Allow'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permission Handler Demo'),
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Media Permissions Section
            _buildSectionHeader(
              'Media Permissions',
              Icons.photo_library,
            ),
            SizedBox(height: 12.h),

            _buildPermissionCard(
              permission: PermissionType.photos,
              title: 'Photos Access',
              subtitle: 'Access your photos and images',
              icon: Icons.photo,
            ),
            SizedBox(height: 12.h),

            _buildPermissionCard(
              permission: PermissionType.videos,
              title: 'Videos Access',
              subtitle: 'Access your video library',
              icon: Icons.video_library,
            ),
            SizedBox(height: 12.h),

            _buildPermissionCard(
              permission: PermissionType.audio,
              title: 'Audio Access',
              subtitle: 'Access your audio and music files',
              icon: Icons.audiotrack,
            ),
            SizedBox(height: 12.h),

            _buildPermissionCard(
              permission: PermissionType.storage,
              title: 'Storage Access',
              subtitle: 'Save and manage files',
              icon: Icons.storage,
            ),
            SizedBox(height: 24.h),

            // Communication Permissions Section
            _buildSectionHeader(
              'Communication Permissions',
              Icons.call,
            ),
            SizedBox(height: 12.h),

            _buildPermissionCard(
              permission: PermissionType.camera,
              title: 'Camera Access',
              subtitle: 'Take photos and scan documents',
              icon: Icons.camera_alt,
            ),
            SizedBox(height: 12.h),

            _buildPermissionCard(
              permission: PermissionType.microphone,
              title: 'Microphone Access',
              subtitle: 'Record audio and voice messages',
              icon: Icons.mic,
            ),
            SizedBox(height: 12.h),

            _buildPermissionCard(
              permission: PermissionType.contacts,
              title: 'Contacts Access',
              subtitle: 'Access your contacts',
              icon: Icons.contacts,
            ),
            SizedBox(height: 24.h),

            // Location Permissions Section
            _buildSectionHeader(
              'Location Permissions',
              Icons.location_on,
            ),
            SizedBox(height: 12.h),

            _buildPermissionCard(
              permission: PermissionType.location,
              title: 'Location Access',
              subtitle:
                  'Find nearby places and get directions',
              icon: Icons.location_on,
            ),
            SizedBox(height: 24.h),

            // Group Permissions Section
            _buildSectionHeader(
              'Group Permissions',
              Icons.group,
            ),
            SizedBox(height: 12.h),

            _buildGroupPermissionCard(
              group: PermissionGroup.media,
              title: 'All Media Permissions',
              subtitle:
                  'Photos, videos, audio, and storage',
              icon: Icons.photo_library,
            ),
            SizedBox(height: 12.h),

            _buildGroupPermissionCard(
              group: PermissionGroup.communication,
              title: 'All Communication Permissions',
              subtitle: 'Camera, microphone, and contacts',
              icon: Icons.call,
            ),
            SizedBox(height: 24.h),

            // Request All Button
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton.icon(
                onPressed: _requestAllPermissions,
                icon: const Icon(Icons.security),
                label: const Text(
                  'Request All Permissions',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AuthColors.yellow,
                  foregroundColor: AuthColors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      12.r,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24.sp, color: AuthColors.black),
        SizedBox(width: 8.w),
        Text(title, style: AuthTextStyles.headlineS),
      ],
    );
  }

  Widget _buildPermissionCard({
    required PermissionType permission,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final permissionStatus = ref.watch(
      permissionStatusProvider(permission),
    );

    return permissionStatus.when(
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
                        onTap:
                            () => _requestSinglePermission(
                              permission,
                            ),
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
            child: Row(
              children: [
                const Icon(
                  Icons.error,
                  color: AuthColors.error,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Error checking permission',
                    style: AuthTextStyles.bodyM,
                  ),
                ),
                TextButton(
                  onPressed:
                      () => ref.invalidate(
                        permissionStatusProvider(
                          permission,
                        ),
                      ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildGroupPermissionCard({
    required PermissionGroup group,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final groupStatus = ref.watch(
      permissionGroupStatusProvider(group),
    );

    return groupStatus.when(
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
                        onTap:
                            () => _requestGroupPermission(
                              group,
                            ),
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
                            'Grant All',
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
            child: Row(
              children: [
                const Icon(
                  Icons.error,
                  color: AuthColors.error,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Error checking permissions',
                    style: AuthTextStyles.bodyM,
                  ),
                ),
                TextButton(
                  onPressed:
                      () => ref.invalidate(
                        permissionGroupStatusProvider(
                          group,
                        ),
                      ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _requestSinglePermission(
    PermissionType permission,
  ) async {
    final actionNotifier = ref.read(
      permissionActionProvider.notifier,
    );
    final result = await actionNotifier
        .requestSinglePermission(permission);

    if (result.isGranted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${permission.displayName} permission granted!',
          ),
          backgroundColor: AuthColors.success,
        ),
      );
      ref.invalidate(permissionStatusProvider(permission));
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${permission.displayName} permission denied',
          ),
          backgroundColor: AuthColors.error,
        ),
      );
    }
  }

  Future<void> _requestGroupPermission(
    PermissionGroup group,
  ) async {
    final actionNotifier = ref.read(
      permissionActionProvider.notifier,
    );
    final results = await actionNotifier
        .requestPermissionGroup(group);

    final allGranted = results.values.every(
      (r) => r.isGranted,
    );

    if (allGranted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${group.displayName} permissions granted!',
          ),
          backgroundColor: AuthColors.success,
        ),
      );
      ref.invalidate(permissionGroupStatusProvider(group));
      for (var permission in group.permissions) {
        ref.invalidate(
          permissionStatusProvider(permission),
        );
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Some ${group.displayName} permissions were denied',
          ),
          backgroundColor: AuthColors.error,
        ),
      );
    }
  }

  Future<void> _requestAllPermissions() async {
    final actionNotifier = ref.read(
      permissionActionProvider.notifier,
    );

    final granted = await actionNotifier
        .initializeRequiredPermissions(
          context: context,
          requiredPermissions: [
            PermissionType.photos,
            PermissionType.videos,
            PermissionType.audio,
            PermissionType.camera,
            PermissionType.microphone,
            PermissionType.location,
          ],
          requiredGroups: [
            PermissionGroup.media,
            PermissionGroup.communication,
          ],
          title: 'All Permissions Required',
          message:
              'This app needs these permissions to function properly.',
        );

    if (granted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All permissions granted!'),
          backgroundColor: AuthColors.success,
        ),
      );
      ref.invalidate(permissionStateProvider);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Some permissions were denied'),
          backgroundColor: AuthColors.error,
        ),
      );
    }
  }
}
