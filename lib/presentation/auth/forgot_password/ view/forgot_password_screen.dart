import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/core/constants/app_colors.dart';
import 'package:metalheadd/core/theme/app_text_styles.dart';
import 'package:metalheadd/core/widgets/app_button.dart';
import 'package:metalheadd/core/widgets/app_input_field.dart';
import 'package:metalheadd/core/widgets/form_label.dart';
import '../../../../core/route/route_name.dart';
import '../viewmodel/forgot_password_provider.dart';
import '../viewmodel/forgot_password_state.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    ref
        .read(forgotPasswordProvider.notifier)
        .onEmailChanged(_emailController.text.trim());
  }

  void _onSendCode() {
    ref
        .read(forgotPasswordProvider.notifier)
        .sendResetCode(_emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordProvider);

    /// ✅ SAFE LISTENER
    ref.listen<ForgotPasswordState>(
      forgotPasswordProvider,
          (previous, next) {
        if (previous?.success == false && next.success == true) {
          Navigator.pushNamed(
            context,
            RouteName.otpVerification,
          );
        }
      },
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Forgot Password?',
              style: AppTextStyles.heading20SemiBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Don’t worry! Enter your email to receive a reset code.',
              style: AppTextStyles.body14Regular.copyWith(
                color: AppColors.textMuted,
              ),
            ),

            const SizedBox(height: 24),

            const FormLabel('Email'),
            AppInputField(
              hint: 'Enter your email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) => _onEmailChanged(),
            ),

            const SizedBox(height: 32),

            AppButton(
              text: 'Get Code',
              isLoading: state.isLoading,
              isEnabled: state.isEmailValid,
              onPressed: _onSendCode,
            ),

            const SizedBox(height: 16),

            if (state.error != null)
              Text(
                state.error!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
