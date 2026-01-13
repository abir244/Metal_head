part of 'route_import_path.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
    // ---------------- AUTH ----------------
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



      case RouteName.votingrights:
        return MaterialPageRoute(
          builder: (_) => const AssignVotingView(),
        );

    // ---------------- HOME ----------------
      case RouteName.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );

    // ---------------- MATCH DETAILS ----------------
      case RouteName.matchdetails:
        final String matchId = settings.arguments as String;

        return MaterialPageRoute(
          builder: (_) => MatchDetailsScreen(matchId: matchId),
        );

    // ---------------- VOTING ----------------
      case RouteName.voting:
        return MaterialPageRoute(
          builder: (_) => const VotingScreen(matchId: '',),
        );
    // ---------------- DEFAULT ----------------
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
