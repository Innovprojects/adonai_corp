import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class SectorNavigationCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String description;
  final String iconName;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;

  const SectorNavigationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.iconName,
    required this.color,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<SectorNavigationCard> createState() => _SectorNavigationCardState();
}

class _SectorNavigationCardState extends State<SectorNavigationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.only(bottom: 2.h),
            child: GestureDetector(
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              onTap: widget.isActive ? widget.onTap : null,
              child: Card(
                elevation: _isPressed ? 8.0 : 2.0,
                shadowColor: widget.color.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  side: BorderSide(
                    color: widget.color.withValues(alpha: 0.2),
                    width: 1.0,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.color.withValues(alpha: 0.05),
                        widget.color.withValues(alpha: 0.02),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      // Icon Container
                      Container(
                        width: 15.w,
                        height: 15.w,
                        decoration: BoxDecoration(
                          color: widget.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: widget.color.withValues(alpha: 0.3),
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: widget.iconName,
                            color: widget.color,
                            size: 28,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.title,
                                    style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (widget.isActive)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.w,
                                      vertical: 0.5.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.successLight
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: AppTheme.successLight
                                            .withValues(alpha: 0.3),
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Text(
                                      'Actif',
                                      style: GoogleFonts.inter(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppTheme.successLight,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              widget.subtitle,
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: widget.color,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              widget.description,
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Arrow Icon
                      Container(
                        padding: EdgeInsets.all(1.w),
                        child: CustomIconWidget(
                          iconName: 'arrow_forward_ios',
                          color: widget.isActive
                              ? widget.color
                              : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5),
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
