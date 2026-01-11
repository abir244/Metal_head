part of 'route_import_path.dart';
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.registration:
        return MaterialPageRoute(
          builder: (_) => const RegistrationScreen(),
        );

      case RouteName.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case RouteName.forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
        );


      case RouteName.otpVerification:
        return MaterialPageRoute(
          builder: (_) => const OtpVerificationScreen(),
        );


      case RouteName.createnewpassword:
        return MaterialPageRoute(
          builder: (_) => const CreateNewPasswordScreen(),
        );


      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}