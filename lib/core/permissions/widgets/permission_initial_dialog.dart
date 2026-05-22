import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/permission_type.dart';

class PermissionInitialDialog extends StatelessWidget {
  final List<PermissionType> permissions;
  final String? title;
  final String? message;

  const PermissionInitialDialog({
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
                color: theme.colorScheme.primary.withAlpha(
                  30,
                ), // Fixed
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.security_rounded,
                size: 48.sp,
                color: theme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              title ?? 'Permissions Required',
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
                  'This app needs the following permissions to function properly:',
              style: GoogleFonts.urbanist(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurface
                    .withAlpha(180), // Fixed
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: theme
                    .colorScheme
                    .surfaceContainerHighest
                    .withAlpha(130), // Fixed
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children:
                    permissions.map((permission) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                        ),
                        child: Row(
                          children: [
                            Text(
                              permission.icon,
                              style: TextStyle(
                                fontSize: 24.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                permission.displayName,
                                style: GoogleFonts.urbanist(
                                  fontSize: 14.sp,
                                  fontWeight:
                                      FontWeight.w500,
                                  color:
                                      theme
                                          .colorScheme
                                          .onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
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
                  'Continue',
                  style: GoogleFonts.urbanist(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            TextButton(
              onPressed:
                  () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: GoogleFonts.urbanist(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface
                      .withAlpha(130), // Fixed
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
