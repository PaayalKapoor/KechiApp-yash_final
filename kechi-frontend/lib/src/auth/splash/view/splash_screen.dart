import 'package:kechi/shared/theme/theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:kechi/src/auth/signup/customer/view/signup_customer.dart';
import 'package:kechi/src/auth/login/salon_owner/view/login_screen.dart';
import 'package:kechi/src/auth/signup/artist/view/signup_artist.dart';
import 'package:kechi/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _controller = PageController();

  @override
  void initState() {
    super.initState();
    _autoScrollPages();
  }

  void _autoScrollPages() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _controller.hasClients && _controller.page != null && _controller.page! < 2) {
        _controller.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _autoScrollPages();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _controller,
            children: [
              SplashPage(
                title: "Are you a customer?",
                imagePath: "assets/images/customer.png",
                description:
                    "Relax, Refresh, Reimagine – Your Perfect Look Awaits",
                paragraph:
                    "Book top stylists, explore trending styles, and indulge in the best beauty services - because you deserve it!",
                onSignup: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SignupCustomer())),
                onLogin: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginScreen())),
              ),
              SplashPage(
                title: "Are you an artist?",
                imagePath: "assets/images/artist.png",
                description:
                    "Your Talent, Your Passion, Your Clients – Let's Create Magic!",
                paragraph:
                    "Step into a world where your skills shine. Connect with clients, showcase your creativity, and build your dream career!",
                onSignup: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SignupArtist())),
                onLogin: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginScreen())),
              ),
              SplashPage(
                title: "Are you a salon owner?",
                imagePath: "assets/images/salon_owner.png",
                description: "Manage, Grow, Succeed – Your Salon, Your Rules!",
                paragraph:
                    "Streamline your bookings, attract more clients, and watch your business thrive. The future of salon management starts here!",
                onSignup: () => Navigator.pushNamed(context, Routes.Signup),
                onLogin: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginScreen())),
              ),
            ],
          ),

          // Smooth Page Indicator (Dots)
          Positioned(
            bottom: 20,
            child: SmoothPageIndicator(
              controller: _controller,
              count: 3,
              effect: const ExpandingDotsEffect(
                activeDotColor: AppTheme.primaryColor, // Active dot color
                dotColor: Colors.grey, // Inactive dot color
                dotHeight: 10,
                dotWidth: 10,
                expansionFactor: 2, // Expands active dot
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SplashPage extends StatelessWidget {
  final String title;
  final String description;
  final String paragraph;
  final String imagePath;
  final VoidCallback onSignup;
  final VoidCallback onLogin;

  const SplashPage({
    required this.title,
    required this.description,
    required this.paragraph,
    required this.imagePath,
    required this.onSignup,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                    fontFamily: "PlusJakartaSans",
                  ),
                  textAlign: TextAlign.center,
                ),
                Image.asset(imagePath, height: 250),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: "PlusJakartaSans",
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  paragraph,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontFamily: "PlusJakartaSans",
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: onSignup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          fontFamily: "PlusJakartaSans",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: onLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        "Log in",
                        style: TextStyle(
                          fontFamily: "PlusJakartaSans",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
