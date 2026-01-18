import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/core/constants/app_colors.dart';
import 'package:metalheadd/core/theme/app_text_styles.dart';
import 'package:metalheadd/core/widgets/form_label.dart';
import 'package:metalheadd/core/widgets/app_input_field.dart';
import 'package:metalheadd/core/widgets/app_button.dart';
import '../../../../core/route/route_name.dart';
import '../viewmodel/login_provider.dart';
import '../../../home/view/widgets/bottom_navbar.dart'; // Import navigationProvider

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

  void _onFormChanged() {
    ref
        .read(loginProvider.notifier)
        .onFormChanged(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  Future<void> _onLogin() async {
    // Reset navigation to Home tab (index 0) before login
    ref.read(navigationProvider.notifier).updateIndex(0);

    // Perform actual login
    final success = await ref
        .read(loginProvider.notifier)
        .login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    // Navigate only if login was successful
    if (success && mounted) {
      Navigator.pushReplacementNamed(
        context,
        RouteName.Wrappernav,
      );
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
              style: AppTextStyles.heading20SemiBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            Text('Login to your account', style: AppTextStyles.body14Regular),

            const SizedBox(height: 24),

            const FormLabel('Email'),
            AppInputField(
              hint: 'Enter email',
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              onChanged: (_) => _onFormChanged(),
            ),

            const SizedBox(height: 16),

            const FormLabel('Password'),
            AppInputField(
              hint: '********',
              isPassword: true,
              controller: _passwordController,
              onChanged: (_) => _onFormChanged(),
            ),

            const SizedBox(height: 12),

            // 🔵 FORGOT PASSWORD
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RouteName.forgotPassword);
                },
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

            AppButton(
              text: 'Login',
              isLoading: state.isLoading,
              isEnabled: state.isFormValid,
              onPressed: _onLogin,
            ),

            const SizedBox(height: 24),

            // 🔵 SIGN UP TEXT
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RouteName.registration);
                },
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

            if (state.error != null)
              Container(
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
                        state.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}