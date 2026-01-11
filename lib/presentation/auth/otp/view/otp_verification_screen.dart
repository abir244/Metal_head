
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/core/route/route_name.dart';
import '../viewmodel/otp_provider.dart';

// Figma-like OTP verification screen
class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({
    super.key,
    this.email = 'demo123@gmail.com', // shown under title
  });

  final String email;

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  static const int _otpLength = 6;
  static const String _demoOtp = '123456'; // ✅ demo OTP

  // Controllers + focus nodes for each digit
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  int _secondsLeft = 59;
  Timer? _timer;
  String? _error; // local error message
  bool _verifying = false;

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());

    // Start countdown
    _startTimer();
    // Autofocus first box shortly after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_focusNodes.isNotEmpty) {
        _focusNodes.first.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _secondsLeft = 59;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_secondsLeft <= 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  String get _currentCode =>
      _controllers.map((c) => c.text).join();

  bool get _isComplete =>
      _currentCode.length == _otpLength &&
          _controllers.every((c) => c.text.isNotEmpty);

  void _onDigitChanged(int index, String value) {
    // Notify provider for live validation (optional)
    ref.read(otpProvider.notifier).onOtpChanged(_currentCode);

    // Clear previous error when user edits
    if (_error != null) {
      setState(() => _error = null);
    }

    // Move focus forward automatically when 1 digit typed
    if (value.isNotEmpty && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    // If user clears the box, move focus backward
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    setState(() {}); // rebuild to reflect enabled state
  }

  Future<void> _verify() async {
    if (_verifying) return;

    ref.read(otpProvider.notifier).verifyOtp(_currentCode);

    setState(() => _verifying = true);
    try {
      await Future.delayed(const Duration(milliseconds: 600));

      if (_currentCode == _demoOtp) {
        if (!mounted) return;

        Navigator.pushReplacementNamed(
          context,
         RouteName.createnewpassword,
        );
      } else {
        setState(() => _error = "Don't match code!\nTry again");
      }
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }


  void _resendCode() {
    // Optional: call provider if you have resend logic
    // ref.read(otpProvider.notifier).resendCode();

    // Clear current input
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes.first.requestFocus();
    setState(() => _error = null);

    // Restart countdown
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(otpProvider);

    // Colors (approximate to your Figma)
    const background = Colors.black;
    const textPrimary = Colors.white;
    const textSecondary = Color(0xFFB0B0B0); // gray
    const accentBlue = Colors.lightBlue;
    const errorRed = Colors.redAccent;
    const filledCircle = Color(0xFF2A2A2A); // deep gray fill
    const ringDefault = Color(0xFF4A4A4A);
    const ringError = Color(0xFFEA4335);
    const btnColor = Color(0xFF9E8D00); // golden-ish from Figma

    final isError = _error != null || (state.error != null);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('OTP Verification',
            style: TextStyle(color: textPrimary)),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Verify Your Code',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "We've sent a code to ${widget.email}",
                style: const TextStyle(
                  color: textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),

              // OTP boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_otpLength, (index) {
                  final hasValue = _controllers[index].text.isNotEmpty;
                  final ringColor = isError ? ringError : ringDefault;

                  return SizedBox(
                    width: 54,
                    height: 54,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: filledCircle,
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(27),
                          borderSide: BorderSide(color: ringColor, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(27),
                          borderSide: BorderSide(color: ringColor, width: 2),
                        ),
                      ),
                      onChanged: (v) => _onDigitChanged(index, v),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 16),

              // Resend row
              Row(
                children: [
                  const Text(
                    'Resend:',
                    style: TextStyle(color: textSecondary, fontSize: 14),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _secondsLeft > 0 ? '${_secondsLeft}s' : '0s',
                    style: const TextStyle(
                      color: accentBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Resend link (enabled when timer hits 0)
              GestureDetector(
                onTap: _secondsLeft == 0 ? _resendCode : null,
                child: Text(
                  'Resend Code',
                  style: TextStyle(
                    color: accentBlue.withOpacity(
                        _secondsLeft == 0 ? 1.0 : 0.4),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Error message
              if (isError)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _error ?? state.error!,
                      style: const TextStyle(
                        color: errorRed,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Try again',
                      style: TextStyle(
                        color: errorRed,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),

              const Spacer(),

              // Verify button
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
                  onPressed: _isComplete && !_verifying ? _verify : null,
                  child: _verifying || state.isLoading
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
                    'Verify',
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
