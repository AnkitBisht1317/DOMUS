import 'package:flutter/material.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/job_portal_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String jobPortal = '/job-portal';
  // Add more routes as needed

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      case jobPortal:
        return MaterialPageRoute(
          builder: (_) => const JobPortalScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static void navigateToJobPortal(BuildContext context) {
    Navigator.pushNamed(context, jobPortal);
  }

  // Add more navigation helper methods as needed
}
