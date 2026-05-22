import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/permission_type.dart';

class PermissionPermanentDialog extends StatelessWidget {
  final List<PermissionType> permissions;
  final String? title;
  final String? message;

  const PermissionPermanentDialog({
    super.key,
    required this.permissions,
    this.title,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withOpacity(
                  0.1,
                ), // Fixed
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.block_rounded,
                size: 48.sp,
                color: theme.colorScheme.error,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              title ?? 'Permissions Permanently Denied',
              style: GoogleFonts.urbanist(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              message ??
                  'You have permanently denied the following permissions:\n\n'
                      '${permissions.map((p) => '• ${p.displayName}').join('\n')}\n\n'
                      'Please enable them in device settings to continue using the app.',
              style: GoogleFonts.urbanist(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurface
                    .withOpacity(0.7), // Fixed
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      theme.colorScheme.primary,
                  foregroundColor:
                      theme.colorScheme.onPrimary,
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
                  'Open Settings',
                  style: GoogleFonts.urbanist(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed:
                    () => Navigator.of(context).pop(false),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: theme.colorScheme.primary
                        .withOpacity(0.3),
                  ), // Fixed
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
                  'Cancel',
                  style: GoogleFonts.urbanist(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
