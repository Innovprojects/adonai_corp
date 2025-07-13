import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialLoginWidget extends StatelessWidget {
  const SocialLoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with text
        _buildDividerWithText(context),

        SizedBox(height: 2.h),

        // Social login buttons
        Row(
          children: [
            Expanded(
              child: _buildSocialButton(
                context: context,
                label: 'Google',
                iconName: 'g_translate',
                onTap: () => _handleGoogleLogin(context),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildSocialButton(
                context: context,
                label: 'Apple',
                iconName: 'apple',
                onTap: () => _handleAppleLogin(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDividerWithText(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: AppTheme.borderLight,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Ou continuer avec',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryLight,
                ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: AppTheme.borderLight,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required String label,
    required String iconName,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 6.h,
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.borderLight,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.textPrimaryLight,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimaryLight,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleGoogleLogin(BuildContext context) {
    HapticFeedback.lightImpact();

    // Simulate Google login
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connexion Google en cours...'),
        backgroundColor: AppTheme.tertiaryLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleAppleLogin(BuildContext context) {
    HapticFeedback.lightImpact();

    // Simulate Apple login
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connexion Apple en cours...'),
        backgroundColor: AppTheme.textPrimaryLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
