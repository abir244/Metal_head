import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'forgot_password_viewmodel.dart';
import 'forgot_password_state.dart';

final forgotPasswordProvider =
StateNotifierProvider<ForgotPasswordViewModel, ForgotPasswordState>(
      (ref) => ForgotPasswordViewModel(),
);
