import 'package:flutter/material.dart';

import 'LogIn.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  _navigateToNext() async {
    await Future.delayed(Duration(milliseconds: 1500));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LogIn()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 70),
              Text(
                'Commute App',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 80),
              Row(
                children: [
                  SizedBox(width: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 60.0,
                      horizontal: 40.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 70,
                          offset: Offset(5, 10),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'Images/nimit_image.jpg',
                      height: 300,
                      width: 270,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Text(
                'Hope To Make Your Journey Effortless..',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
