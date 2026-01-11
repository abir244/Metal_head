import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/presentation/auth/registration/viewmodel/registration_notifier.dart';


import '../model/registration_state.dart';


final registrationProvider =
StateNotifierProvider<RegistrationViewModel, RegistrationState>(
      (ref) => RegistrationViewModel(),
);
