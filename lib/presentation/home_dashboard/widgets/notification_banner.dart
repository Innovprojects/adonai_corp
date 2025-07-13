import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class NotificationBanner extends StatefulWidget {
  final String message;
  final VoidCallback onDismiss;

  const NotificationBanner({
    super.key,
    required this.message,
    required this.onDismiss,
  });

  @override
  State<NotificationBanner> createState() => _NotificationBannerState();
}

class _NotificationBannerState extends State<NotificationBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleDismiss() async {
    await _animationController.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Dismissible(
              key: const Key('notification_banner'),
              direction: DismissDirection.up,
              onDismissed: (direction) => widget.onDismiss(),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.secondaryLight.withValues(alpha: 0.1),
                      AppTheme.tertiaryLight.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: AppTheme.secondaryLight.withValues(alpha: 0.3),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.secondaryLight.withValues(alpha: 0.1),
                      blurRadius: 8.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Notification Icon
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryLight.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: CustomIconWidget(
                        iconName: 'notifications_active',
                        color: AppTheme.secondaryLight,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 3.w),

                    // Message Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notification',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.secondaryLight,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            widget.message,
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Action Buttons
                    Column(
                      children: [
                        GestureDetector(
                          onTap: _handleDismiss,
                          child: Container(
                            padding: EdgeInsets.all(1.w),
                            decoration: BoxDecoration(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: CustomIconWidget(
                              iconName: 'close',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        GestureDetector(
                          onTap: () {
                            // Handle view action
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Affichage des détails de notification'),
                                backgroundColor:
                                    AppTheme.lightTheme.colorScheme.primary,
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(1.w),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.tertiaryLight.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: CustomIconWidget(
                              iconName: 'visibility',
                              color: AppTheme.tertiaryLight,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
