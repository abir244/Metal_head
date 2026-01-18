import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/core/constants/app_colors.dart';
import 'package:metalheadd/core/theme/app_text_styles.dart';
import 'package:metalheadd/core/widgets/form_label.dart';
import 'package:metalheadd/core/widgets/app_input_field.dart';
import 'package:metalheadd/core/widgets/app_button.dart';
import '../../../../core/route/route_name.dart';
import '../viewmodel/login_provider.dart';
import '../../../home/view/widgets/bottom_navbar.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Helper to sync form state with provider
  void _onFormChanged() {
    ref.read(loginProvider.notifier).onFormChanged(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  // DYNAMIC FEATURE: Auto-fill test credentials
  void _fillTestCredentials() {
    setState(() {
      _emailController.text = 'test@test.com';
      _passwordController.text = 'password';
    });
    _onFormChanged(); // Trigger validation logic in provider
  }

  Future<void> _onLogin() async {
    // Reset navigation to Home tab (index 0) before login
    ref.read(navigationProvider.notifier).updateIndex(0);

    final success = await ref.read(loginProvider.notifier).login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, RouteName.Wrappernav);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back',
              style: AppTextStyles.heading24Bold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text('Login to your account', style: AppTextStyles.body14Regular),

            const SizedBox(height: 32),

            // EMAIL FIELD
            const FormLabel('Email'),
            AppInputField(
              hint: 'Enter email',
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              onChanged: (_) => _onFormChanged(),
            ),

            const SizedBox(height: 16),

            // PASSWORD FIELD
            const FormLabel('Password'),
            AppInputField(
              hint: '********',
              isPassword: true,
              controller: _passwordController,
              onChanged: (_) => _onFormChanged(),
            ),

            const SizedBox(height: 12),

            // FORGOT PASSWORD
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, RouteName.forgotPassword),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    'Forgot password?',
                    style: AppTextStyles.body14Regular.copyWith(
                      color: AppColors.textThird,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // LOGIN BUTTON
            AppButton(
              text: 'Login',
              isLoading: state.isLoading,
              isEnabled: state.isFormValid,
              onPressed: _onLogin,
            ),

            const SizedBox(height: 24),

            // DYNAMIC TEST CREDENTIALS BOX
            _buildTestCredentialsCard(),

            const SizedBox(height: 24),

            // SIGN UP REDIRECT
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, RouteName.registration),
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: AppTextStyles.body14Regular,
                    children: [
                      TextSpan(
                        text: 'Sign up',
                        style: AppTextStyles.body14Regular.copyWith(
                          color: AppColors.textThird,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ERROR DISPLAY
            if (state.error != null) _buildErrorContainer(state.error!),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// Builds the dynamic Test Account Card
  Widget _buildTestCredentialsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface, // Depth #121212
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "TEST ACCOUNT",
                style: AppTextStyles.overline10Medium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: _fillTestCredentials,
                child: Text(
                  "AUTO FILL",
                  style: AppTextStyles.label12Medium.copyWith(
                    color: AppColors.textThird,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _testInfoRow(Icons.email_outlined, "test@test.com"),
          const SizedBox(height: 8),
          _testInfoRow(Icons.lock_outline, "password"),
        ],
      ),
    );
  }

  Widget _testInfoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          value,
          style: AppTextStyles.body14Regular.copyWith(
            color: AppColors.textSecondary,
            fontFamily: 'Courier', // Monospaced feel for credentials
          ),
        ),
      ],
    );
  }

  Widget _buildErrorContainer(String error) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}