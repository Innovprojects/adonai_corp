import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class RecentActivityCard extends StatelessWidget {
  final String title;
  final String description;
  final DateTime timestamp;
  final String sector;
  final String iconName;
  final Color color;
  final bool isUnread;
  final VoidCallback onTap;

  const RecentActivityCard({
    super.key,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.sector,
    required this.iconName,
    required this.color,
    required this.isUnread,
    required this.onTap,
  });

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays}j';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.5.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: isUnread
                  ? color.withValues(alpha: 0.05)
                  : AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: isUnread
                    ? color.withValues(alpha: 0.2)
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                // Icon and Unread Indicator
                Stack(
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: iconName,
                          color: color,
                          size: 20,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 3.w,
                          height: 3.w,
                          decoration: BoxDecoration(
                            color: AppTheme.errorLight,
                            borderRadius: BorderRadius.circular(6.0),
                            border: Border.all(
                              color: Colors.white,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 3.w),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: isUnread
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 0.3.h,
                            ),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Text(
                              sector,
                              style: GoogleFonts.inter(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w500,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        description,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'access_time',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.7),
                            size: 12,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            _formatTimestamp(timestamp),
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                          Spacer(),
                          if (isUnread)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.3.h,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    AppTheme.errorLight.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Text(
                                'Nouveau',
                                style: GoogleFonts.inter(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.errorLight,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Action Button
                Container(
                  padding: EdgeInsets.all(1.w),
                  child: CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.5),
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
