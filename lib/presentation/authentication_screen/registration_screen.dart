import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _isFormValid = false;
  bool _acceptTerms = false;

  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

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

    _firstNameController.addListener(_validateForm);
    _lastNameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _firstNameError = _validateName(_firstNameController.text, 'Prénom');
      _lastNameError = _validateName(_lastNameController.text, 'Nom');
      _emailError = _validateEmail(_emailController.text);
      _passwordError = _validatePassword(_passwordController.text);
      _confirmPasswordError = _validateConfirmPassword(
          _passwordController.text, _confirmPasswordController.text);

      _isFormValid = _firstNameError == null &&
          _lastNameError == null &&
          _emailError == null &&
          _passwordError == null &&
          _confirmPasswordError == null &&
          _firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _acceptTerms;
    });
  }

  String? _validateName(String value, String fieldName) {
    if (value.isEmpty) return null;
    if (value.length < 2) {
      return '$fieldName doit contenir au moins 2 caractères';
    }
    return null;
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
    if (value.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins une majuscule';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins une minuscule';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins un chiffre';
    }
    return null;
  }

  String? _validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) return null;
    if (password != confirmPassword) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  Future<void> _handleRegistration() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate registration success
    HapticFeedback.heavyImpact();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Inscription réussie! Vous pouvez maintenant vous connecter.'),
          backgroundColor: AppTheme.successLight,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.of(context).pop();
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _closeRegistration() {
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
                        maxHeight: 90.h,
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
                          // Header with close button and title
                          _buildHeader(),

                          // Scrollable content
                          Expanded(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Name fields
                                    Row(
                                      children: [
                                        Expanded(child: _buildFirstNameField()),
                                        SizedBox(width: 4.w),
                                        Expanded(child: _buildLastNameField()),
                                      ],
                                    ),

                                    SizedBox(height: 2.h),

                                    // Email field
                                    _buildEmailField(),

                                    SizedBox(height: 2.h),

                                    // Password field
                                    _buildPasswordField(),

                                    SizedBox(height: 2.h),

                                    // Confirm password field
                                    _buildConfirmPasswordField(),

                                    SizedBox(height: 3.h),

                                    // Terms and conditions
                                    _buildTermsCheckbox(),

                                    SizedBox(height: 3.h),

                                    // Registration button
                                    _buildRegistrationButton(),

                                    SizedBox(height: 2.h),

                                    // Login link
                                    _buildLoginLink(),

                                    SizedBox(height: 2.h),
                                  ],
                                ),
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

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.textSecondaryLight.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _closeRegistration,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.textSecondaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.textSecondaryLight,
                size: 20,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Créer un compte',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.primaryLight,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          SizedBox(width: 10.w), // Balance the close button
        ],
      ),
    );
  }

  Widget _buildFirstNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _firstNameController,
          focusNode: _firstNameFocusNode,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Prénom',
            hintText: 'Votre prénom',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.textSecondaryLight,
                size: 20,
              ),
            ),
          ),
          onFieldSubmitted: (_) {
            _lastNameFocusNode.requestFocus();
          },
        ),
        if (_firstNameError != null)
          Padding(
            padding: EdgeInsets.only(top: 0.5.h, left: 3.w),
            child: Text(
              _firstNameError!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.errorLight,
                  ),
            ),
          ),
      ],
    );
  }

  Widget _buildLastNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _lastNameController,
          focusNode: _lastNameFocusNode,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Nom',
            hintText: 'Votre nom',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.textSecondaryLight,
                size: 20,
              ),
            ),
          ),
          onFieldSubmitted: (_) {
            _emailFocusNode.requestFocus();
          },
        ),
        if (_lastNameError != null)
          Padding(
            padding: EdgeInsets.only(top: 0.5.h, left: 3.w),
            child: Text(
              _lastNameError!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.errorLight,
                  ),
            ),
          ),
      ],
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
          textInputAction: TextInputAction.next,
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
          ),
          onFieldSubmitted: (_) {
            _confirmPasswordFocusNode.requestFocus();
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

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _confirmPasswordController,
          focusNode: _confirmPasswordFocusNode,
          obscureText: !_isConfirmPasswordVisible,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: 'Confirmer le mot de passe',
            hintText: 'Confirmez votre mot de passe',
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
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
                HapticFeedback.lightImpact();
              },
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: _isConfirmPasswordVisible
                      ? 'visibility_off'
                      : 'visibility',
                  color: AppTheme.textSecondaryLight,
                  size: 20,
                ),
              ),
            ),
          ),
          onFieldSubmitted: (_) {
            if (_isFormValid) {
              _handleRegistration();
            }
          },
        ),
        if (_confirmPasswordError != null)
          Padding(
            padding: EdgeInsets.only(top: 0.5.h, left: 3.w),
            child: Text(
              _confirmPasswordError!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.errorLight,
                  ),
            ),
          ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _acceptTerms = !_acceptTerms;
            });
            _validateForm();
            HapticFeedback.lightImpact();
          },
          child: Container(
            width: 5.w,
            height: 5.w,
            decoration: BoxDecoration(
              color: _acceptTerms ? AppTheme.primaryLight : Colors.transparent,
              border: Border.all(
                color: _acceptTerms
                    ? AppTheme.primaryLight
                    : AppTheme.textSecondaryLight,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: _acceptTerms
                ? Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 3.w,
                  )
                : null,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: 'J\'accepte les ',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
              children: [
                TextSpan(
                  text: 'conditions d\'utilisation',
                  style: TextStyle(
                    color: AppTheme.primaryLight,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(text: ' et la '),
                TextSpan(
                  text: 'politique de confidentialité',
                  style: TextStyle(
                    color: AppTheme.primaryLight,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationButton() {
    return SizedBox(
      height: 6.h,
      child: ElevatedButton(
        onPressed: _isFormValid && !_isLoading ? _handleRegistration : null,
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
                'Créer mon compte',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Déjà un compte? ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            HapticFeedback.lightImpact();
          },
          child: Text(
            'Se connecter',
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
}
