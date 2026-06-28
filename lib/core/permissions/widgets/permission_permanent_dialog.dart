import 'package:flutter/cupertino.dart';
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

  bool _isCupertino(BuildContext context) {
    final platform = Theme.of(context).platform;
    return platform == TargetPlatform.iOS ||
        platform == TargetPlatform.macOS;
  }

  @override
  Widget build(BuildContext context) {
    if (_isCupertino(context)) {
      return _buildCupertinoDialog(context);
    }
    return _buildMaterialDialog(context);
  }

  String get _resolvedMessage {
    return message ??
        'You have permanently denied the following permissions:\n\n'
            '${permissions.map((p) => '• ${p.displayName}').join('\n')}\n\n'
            'Please enable them in device settings to continue using the app.';
  }

  Widget _buildCupertinoDialog(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return CupertinoAlertDialog(
      title: Text(
        title ?? 'Permissions Permanently Denied',
        style: GoogleFonts.urbanist(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Padding(
        padding: EdgeInsets.only(top: 8.h),
        child: Text(
          _resolvedMessage,
          style: GoogleFonts.urbanist(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Cancel',
            style: GoogleFonts.urbanist(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: onSurface.withAlpha(150),
            ),
          ),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            'Open Settings',
            style: GoogleFonts.urbanist(
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialDialog(BuildContext context) {
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
                color: theme.colorScheme.error.withAlpha(30),
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
              _resolvedMessage,
              style: GoogleFonts.urbanist(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurface.withAlpha(180),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 14.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
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
                onPressed: () => Navigator.of(context).pop(false),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  side: BorderSide(
                    color: theme.colorScheme.primary.withAlpha(80),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 14.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
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
