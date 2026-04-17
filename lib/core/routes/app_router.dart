import 'package:flutter/material.dart';
// Auth Pages
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/verify_email_page.dart';
// Product/Dashboard Pages
import '../../features/product/presentation/pages/dashboard_page.dart';
// Splash
import '../../features/splash/presentation/pages/splash_page.dart';
// Auth Guard
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
        return MaterialPageRoute(builder: (_) => SplashPage());
      case login:
        // FIX: Hapus const dari LoginPage() jika bukan const constructor
        return MaterialPageRoute(builder: (_) =>  LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case verifyEmail:
        return MaterialPageRoute(builder: (_) =>  VerifyEmailPage());
      case dashboard:
        return MaterialPageRoute(
          // FIX: Hapus const dari AuthGuard jika child bukan const
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
    splash: (_) =>  SplashPage(),
    login: (_) =>  LoginPage(),
    register: (_) => RegisterPage(),
    verifyEmail: (_) => VerifyEmailPage(),
    // FIX: Hapus const jika AuthGuard/DashboardPage bukan const constructor
    dashboard: (_) => AuthGuard(child: DashboardPage()),
  };
}