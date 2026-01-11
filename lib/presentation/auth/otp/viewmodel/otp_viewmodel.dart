import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'otp_state.dart';

class OtpViewModel extends StateNotifier<OtpState> {
  OtpViewModel() : super(const OtpState());

  void onOtpChanged(String otp) {
    state = state.copyWith(
      isOtpValid: otp.length == 6,
      error: null,
    );
  }

  Future<void> verifyOtp(String otp) async {
    if (otp.length != 6) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: replace with API
      await Future.delayed(const Duration(seconds: 2));

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Invalid OTP',
      );
    }
  }
}
