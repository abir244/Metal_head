
import 'package:flutter/material.dart';
import 'package:metalheadd/core/route/route_name.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState
    extends State<CreateNewPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _error = null);
    final newPass = _newPasswordController.text;
    final confirm = _confirmPasswordController.text;

    if (newPass.length < 6) {
      setState(() => _error = 'Password must be at least 6 characters.');
      return;
    }
    if (newPass != confirm) {
      setState(() => _error = 'Passwords do not match.');
      return;
    }

    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;


    Navigator.pushReplacementNamed(
      context,
      RouteName.login,
    );
  }


  @override
  Widget build(BuildContext context) {
    const background = Colors.black;
    const textPrimary = Colors.white;
    const textSecondary = Color(0xFFB0B0B0);
    const btnColor = Color(0xFF9E8D00);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: const Text(
          'Create New Password',
          style: TextStyle(color: textPrimary),
        ),
        leading: const BackButton(color: textPrimary),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Set a new password',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Make sure it’s strong and something you can remember.',
                style: TextStyle(color: textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New password',
                  labelStyle: const TextStyle(color: textSecondary),
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF4A4A4A)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF4A4A4A)),
                  ),
                ),
                style: const TextStyle(color: textPrimary),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm password',
                  labelStyle: const TextStyle(color: textSecondary),
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF4A4A4A)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF4A4A4A)),
                  ),
                ),
                style: const TextStyle(color: textPrimary),
              ),
              const SizedBox(height: 12),

              if (_error != null)
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.redAccent),
                ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btnColor,
                    shape: const StadiumBorder(),
                    disabledBackgroundColor:
                    btnColor.withOpacity(0.35),
                  ),
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  )
                      : const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
