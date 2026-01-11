import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'otp_viewmodel.dart';
import 'otp_state.dart';

final otpProvider =
StateNotifierProvider<OtpViewModel, OtpState>(
      (ref) => OtpViewModel(),
);
