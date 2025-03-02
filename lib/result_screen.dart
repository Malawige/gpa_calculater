import 'package:flutter/material.dart';
import 'colors.dart'; 

class ResultScreen extends StatelessWidget {
  final double gpa;

  ResultScreen({required this.gpa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GPA Result')),
      body: Container(
        width: double.infinity, // Ensures the container takes full width
        height: double.infinity, // Ensures the container takes full height
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), 
            fit: BoxFit.cover, // This will cover the entire screen
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your GPA is: ${gpa.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 50, color: AppColors.navyBlue), // Use navy blue for text
              ),
            ],
          ),
        ),
      ),
    );
  }
}