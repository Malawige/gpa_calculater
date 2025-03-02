import 'package:flutter/material.dart';
import 'input_screen.dart'; // Ensure this file exists
import 'colors.dart'; // Ensure this file exists

void main() {
  runApp(GPACalculatorApp());
}

class GPACalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPA Calculator',
      theme: ThemeData(
        primaryColor: AppColors.cyan4, // Use your color
        scaffoldBackgroundColor: AppColors.white, // Background color
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.cyan6, // AppBar color
          titleTextStyle: TextStyle(color: AppColors.white),
        ),
      ),
      home: InputScreen(), // Ensure this screen exists
    );
  }
}