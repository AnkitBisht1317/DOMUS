import 'package:flutter/material.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/job_portal_screen.dart';
import 'package:domus/features/home/presentation/screens/payment_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String jobPortal = '/job-portal';
  static const String paymentScreen = '/payment-screen'; // Add this line
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
      case paymentScreen: // Add this case
        return MaterialPageRoute(
          builder: (_) => const PaymentScreen(),
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

  static void navigateToPaymentScreen(BuildContext context) { // Add this helper method
    Navigator.pushNamed(context, paymentScreen);
  }

  // Add more navigation helper methods as needed
}

class Routes {
  static const String paymentScreen = '/paymentScreen';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      paymentScreen: (context) => const PaymentScreen(),
    };
  }
}
