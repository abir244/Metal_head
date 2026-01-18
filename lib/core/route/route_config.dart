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


      case RouteName.PlayerProfile:
        return MaterialPageRoute(
          builder: (_) => const PlayerProfileScreen(),
        );

    // ---------------- HOME ----------------
      case RouteName.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );

      case RouteName.ChildProfile1:
        {
          // Read the ChildProfile argument
          final child = settings.arguments as ChildProfile?;
          if (child == null) {
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text('No child data provided')),
              ),
            );
          }
          return MaterialPageRoute(
            builder: (_) => ChildProfileCard(child: child),
          );
        }

      case RouteName.Wrappernav: // Define this constant in your RouteName class
        return MaterialPageRoute(builder: (_) => const MainWrapper());

    // ---------------- MATCH DETAILS ----------------
      case RouteName.matchdetails:
        {
          final matchId = settings.arguments as String?;
          if (matchId == null) {
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text('Match ID not provided')),
              ),
            );
          }
          return MaterialPageRoute(
            builder: (_) => MatchDetailsScreen(matchId: matchId),
          );
        }

    // ---------------- VOTING ----------------
      case RouteName.voting:
        return MaterialPageRoute(
          builder: (_) => const VotingScreen(), // no arguments needed
        );

      case RouteName.managerscreen:
        return MaterialPageRoute(
          builder: (_) => const ManagerAccessScreen(), // no arguments needed
        );

      case RouteName.managerdetails:
        return MaterialPageRoute(
          builder: (_) => const  MatchDetailsScreen(matchId: '1',), // no arguments needed
        );


      case RouteName.ChildProfile2:
        return MaterialPageRoute(
          builder: (_) => const ChildProfileScreen(), // no arguments needed
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
