
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pet_care/screens/login_screen/login_screen.dart';
import 'package:pet_care/shared_preference/user_preference.dart';

import '../bottom_nav_bar/bottom_nav_bar.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    _animationController.forward();

    Timer(const Duration(seconds: 3), () {
      // UserPreferences.setFirstTimeFalse();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return UserPreferences.getLoginState()==true?const BottomNavBar(): const LoginScreen();
      }));
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Center(child: Image.asset('assets/images/pet_logo.png')),
        ),
      ),
    );
  }
}