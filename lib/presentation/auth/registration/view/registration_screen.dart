
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/core/constants/app_colors.dart';
import 'package:metalheadd/core/theme/app_text_styles.dart';
import 'package:metalheadd/core/widgets/form_label.dart';
import 'package:metalheadd/core/widgets/app_input_field.dart';
import 'package:metalheadd/core/widgets/app_button.dart';
import '../../../../core/route/route_name.dart';
import '../../login/view/login_screen.dart';
import '../viewmodel/registration_provider.dart';





class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() =>
      _RegistrationScreenState();
}

class _RegistrationScreenState
    extends ConsumerState<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // 🔹 notify ViewModel when form changes
  void _onFormChanged() {
    ref.read(registrationProvider.notifier).onFormChanged(
      name: _nameController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
  }

  void _onSignUp() {
    ref.read(registrationProvider.notifier).signUp(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registrationProvider);

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Admin Account',
              style: AppTextStyles.heading20SemiBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 20),

            const FormLabel('Name'),
            AppInputField(
              hint: 'Enter full name',
              controller: _nameController,
              onChanged: (_) => _onFormChanged(),
            ),

            const SizedBox(height: 16),

            const FormLabel('Phone number (optional)', isRequired: false),
            AppInputField(
              hint: 'Enter your phone number',
              keyboardType: TextInputType.phone,
              controller: _phoneController,
            ),

            const SizedBox(height: 16),

            const FormLabel('Password'),
            AppInputField(
              hint: '********',
              isPassword: true,
              controller: _passwordController,
              onChanged: (_) => _onFormChanged(),
            ),

            const SizedBox(height: 16),

            const FormLabel('Confirm Password'),
            AppInputField(
              hint: '********',
              isPassword: true,
              controller: _confirmPasswordController,
              onChanged: (_) => _onFormChanged(),
            ),

            const SizedBox(height: 32),

            // ✅ REUSABLE APP BUTTON
            AppButton(
              text: 'Sign Up',
              isLoading: state.isLoading,
              isEnabled: state.isFormValid,
              onPressed: () {
                _onSignUp();

                Navigator.pushReplacementNamed(
                  context,
                  RouteName.login, // ✅ correct
                );
              },
            ),




            const SizedBox(height: 24),

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
