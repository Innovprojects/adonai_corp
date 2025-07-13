import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AuthHeaderWidget extends StatelessWidget {
  final VoidCallback onClose;

  const AuthHeaderWidget({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderLight.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Keyboard dismiss button
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              HapticFeedback.lightImpact();
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 3.w,
                vertical: 1.h,
              ),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.borderLight,
                  width: 1,
                ),
              ),
              child: Text(
                'Terminé',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.primaryLight,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),

          // Close button
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onClose();
            },
            child: Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.borderLight,
                  width: 1,
                ),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.textSecondaryLight,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
