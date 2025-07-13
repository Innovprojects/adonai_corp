import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({Key? key}) : super(key: key);

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isFormValid = false;
  String? _emailError;
  String? _passwordError;

  // Mock credentials for authentication
  final Map<String, String> _mockCredentials = {
    'admin@adonaicorp.fr': 'Admin123!',
    'manager@adonaicorp.fr': 'Manager456!',
    'user@adonaicorp.fr': 'User789!',
  };

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _emailError = _validateEmail(_emailController.text);
      _passwordError = _validatePassword(_passwordController.text);
      _isFormValid = _emailError == null &&
          _passwordError == null &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) return null;

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Veuillez entrer une adresse email valide';
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) return null;

    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (_mockCredentials.containsKey(email) &&
        _mockCredentials[email] == password) {
      // Success
      HapticFeedback.heavyImpact();

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connexion réussie!'),
            backgroundColor: AppTheme.successLight,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      // Failure
      HapticFeedback.vibrate();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email ou mot de passe incorrect'),
            backgroundColor: AppTheme.errorLight,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email field
          _buildEmailField(),

          SizedBox(height: 2.h),

          // Password field
          _buildPasswordField(),

          SizedBox(height: 1.h),

          // Forgot password link
          _buildForgotPasswordLink(),

          SizedBox(height: 3.h),

          // Login button
          _buildLoginButton(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _emailController,
          focusNode: _emailFocusNode,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Adresse email',
            hintText: 'votre@email.com',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'email',
                color: AppTheme.textSecondaryLight,
                size: 20,
              ),
            ),
            errorText: null,
          ),
          onFieldSubmitted: (_) {
            _passwordFocusNode.requestFocus();
          },
        ),
        if (_emailError != null)
          Padding(
            padding: EdgeInsets.only(top: 0.5.h, left: 3.w),
            child: Text(
              _emailError!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.errorLight,
                  ),
            ),
          ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          obscureText: !_isPasswordVisible,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: 'Mot de passe',
            hintText: 'Votre mot de passe',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'lock',
                color: AppTheme.textSecondaryLight,
                size: 20,
              ),
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
                HapticFeedback.lightImpact();
              },
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName:
                      _isPasswordVisible ? 'visibility_off' : 'visibility',
                  color: AppTheme.textSecondaryLight,
                  size: 20,
                ),
              ),
            ),
            errorText: null,
          ),
          onFieldSubmitted: (_) {
            if (_isFormValid) {
              _handleLogin();
            }
          },
        ),
        if (_passwordError != null)
          Padding(
            padding: EdgeInsets.only(top: 0.5.h, left: 3.w),
            child: Text(
              _passwordError!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.errorLight,
                  ),
            ),
          ),
      ],
    );
  }

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          // Handle forgot password
        },
        child: Text(
          'Mot de passe oublié?',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryLight,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      height: 6.h,
      child: ElevatedButton(
        onPressed: _isFormValid && !_isLoading ? _handleLogin : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFormValid
              ? AppTheme.primaryLight
              : AppTheme.textSecondaryLight.withValues(alpha: 0.3),
          foregroundColor: Colors.white,
          elevation: _isFormValid ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                width: 5.w,
                height: 5.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Se connecter',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
      ),
    );
  }
}
