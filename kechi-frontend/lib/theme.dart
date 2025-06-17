import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1A73E8); // Blue
  static const Color secondaryColor =
      Color.fromARGB(255, 167, 216, 248); // Light Blue
  static const Color unselectedColor = Colors.grey;

  static const TextStyle headingStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: "PlusJakartaSans");

  static const TextStyle buttonTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: "PlusJakartaSans");
}
