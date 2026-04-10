import 'package:flutter/material.dart';

/// Centralized route management for the app
class AppRoutes {
  // Route names
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String settingsScreen = '/settings';

  // Add more route names as needed
  // static const String example = '/example';

  /// Generate routes based on route settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const Placeholder(), // Replace with your HomePage
          settings: settings,
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const Placeholder(), // Replace with your LoginPage
          settings: settings,
        );

      case register:
        return MaterialPageRoute(
          builder: (_) => const Placeholder(), // Replace with your RegisterPage
          settings: settings,
        );

      case profile:
        return MaterialPageRoute(
          builder: (_) => const Placeholder(), // Replace with your ProfilePage
          settings: settings,
        );

      case settingsScreen:
        return MaterialPageRoute(
          builder: (_) => const Placeholder(), // Replace with your SettingsPage
          settings: settings,
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

  /// Navigate to a named route
  static Future<dynamic> navigateTo(BuildContext context, String routeName,
      {Object? arguments}) {
    return Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  /// Navigate and replace current route
  static Future<dynamic> navigateReplaceTo(
      BuildContext context, String routeName,
      {Object? arguments}) {
    return Navigator.pushReplacementNamed(context, routeName,
        arguments: arguments);
  }

  /// Navigate and remove all previous routes
  static Future<dynamic> navigateAndRemoveUntil(
      BuildContext context, String routeName,
      {Object? arguments}) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Go back to previous screen
  static void goBack(BuildContext context, {dynamic result}) {
    Navigator.pop(context, result);
  }
}
