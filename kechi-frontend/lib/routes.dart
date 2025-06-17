import 'package:flutter/material.dart';
import 'package:kechi/src/appointments/appointments_page.dart';
import 'package:kechi/src/auth/login/salon_owner/view/login_screen.dart';
import 'package:kechi/src/auth/signup/salon_owner/view/signup_screen.dart';
import 'package:kechi/src/profile/main_screen/view/profile_page.dart';
import 'package:kechi/src/store/store_page.dart';
import 'package:kechi/src/auth/splash/view/splash_screen.dart';
import 'package:kechi/src/main_app/main_app.dart';
import 'package:kechi/src/profile/profile_screens/edit_profile/view/edit_profilepage.dart';

class Routes {
  static const String Splash = '/';
  static const String Login = '/login';
  static const String Signup = '/signup';
  static const String Main = '/main';
  static const String Profile = '/profile';
  static const String Store = '/store';
  static const String Services = '/services';
  static const String Slots = '/slots';
  static const String Appointment = '/appointment';
  

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      Splash: (context) => const SplashScreen(),
      Login: (context) => const LoginScreen(),
      Signup: (context) => SalonRegistrationPage(),
      Main: (context) => const MainApp(),
      Profile: (context) => const ProfilePage(),
      Store: (context) => const StorePage(),
      Appointment: (context) => const AppointmentsScreen(),
    };
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Signup:
        return MaterialPageRoute(builder: (_) => SalonRegistrationPage());
      case Main:
        return MaterialPageRoute(builder: (_) => const MainApp());
      case Profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case Store:
        return MaterialPageRoute(builder: (_) => const StorePage());
      case Appointment:
        return MaterialPageRoute(builder: (_) => const AppointmentsScreen());
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
}
