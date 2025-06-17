import 'package:flutter/material.dart';
import 'package:kechi/src/appointments/appointments_page.dart';
import 'package:kechi/src/store/store_page.dart';
import 'package:kechi/src/growth/growth.dart';
import 'package:kechi/src/profile/main_screen/view/profile_page.dart';
import 'package:kechi/shared/widgets/bottom_navbar.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    AppointmentsScreen(), // Remove const since it manages state
    StorePage(),
    Center(child: Text('Dashboard')), // Placeholder for Dashboard
    GrowthScreen(), // Growth screen
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex, // Fixed: was *selectedIndex
        onTap: _onItemTapped, // Fixed: was onItemTapped
      ),
    );
  }
}
