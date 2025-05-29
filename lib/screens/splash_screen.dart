import 'package:flutter/material.dart';
import 'dart:async';
import 'role_option_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 9), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const RoleOptionPage(classId: ''),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color.fromARGB(255, 176, 230, 255), Color(0xFFFFFFFF)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Image.asset('assets/images/logo_animation.gif'),
          ),
        ),
      ),
    );
  }
}
