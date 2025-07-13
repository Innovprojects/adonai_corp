import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/auth_header_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/social_login_widget.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _closeAuthentication() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      body: GestureDetector(
        onTap: _dismissKeyboard,
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.w),
                      constraints: BoxConstraints(
                        maxWidth: 90.w,
                        maxHeight: 85.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header with close button
                          AuthHeaderWidget(onClose: _closeAuthentication),

                          // Scrollable content
                          Expanded(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Logo section
                                  _buildLogoSection(),

                                  SizedBox(height: 4.h),

                                  // Login form
                                  LoginFormWidget(),

                                  SizedBox(height: 3.h),

                                  // Social login section
                                  SocialLoginWidget(),

                                  SizedBox(height: 3.h),

                                  // Registration link
                                  _buildRegistrationLink(),

                                  // Visitor mode button
                                  _buildVisitorModeButton(),

                                  SizedBox(height: 2.h),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppTheme.secondaryLight,
                AppTheme.tertiaryLight,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryLight.withValues(alpha: 0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'AC',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'ADONAI CORP',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.primaryLight,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Connectez-vous pour continuer',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
        ),
      ],
    );
  }

  Widget _buildRegistrationLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Nouvel utilisateur? ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
        ),
        GestureDetector(
          onTap: () {
            // Navigate to registration screen
            Navigator.pushNamed(context, AppRoutes.registrationScreen);
            HapticFeedback.lightImpact();
          },
          child: Text(
            'S\'inscrire',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryLight,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildVisitorModeButton() {
    return Container(
      margin: EdgeInsets.only(top: 2.h),
      child: SizedBox(
        height: 6.h,
        child: OutlinedButton(
          onPressed: () {
            // Navigate directly to home dashboard as visitor
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.homeDashboard,
              (route) => false,
            );
            HapticFeedback.lightImpact();
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: AppTheme.primaryLight,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'visibility',
                color: AppTheme.primaryLight,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Continuer en mode visiteur',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryLight,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
