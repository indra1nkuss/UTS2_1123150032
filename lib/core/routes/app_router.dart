import 'package:flutter/material.dart';
// Auth Pages
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/verify_email_page.dart';
// Product/Dashboard Pages - SESUAI STRUKTUR ANDA
import '../../features/product/presentation/pages/dashboard_page.dart';
// Splash - PERLU DIBUAT
import '../../features/splash/presentation/pages/splash_page.dart';
// Auth Guard - PERLU DIBUAT
import 'auth_guard.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
  static const String dashboard = '/dashboard';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case verifyEmail:
        return MaterialPageRoute(builder: (_) => const VerifyEmailPage());
      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: DashboardPage()),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }

  static Map<String, WidgetBuilder> get routes => {
    splash: (_) => const SplashPage(),
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    verifyEmail: (_) => const VerifyEmailPage(),
    dashboard: (_) => const AuthGuard(child: DashboardPage()),
  };
}