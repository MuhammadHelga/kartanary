import 'package:flutter/material.dart';
import 'package:lifesync_capstone_project/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'role_option_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showImage = false;

  @override
  void initState() {
    super.initState();
    _startSplashSequence();
  }

  Future<void> _startSplashSequence() async {
    await Future.delayed(const Duration(seconds: 1));
    // Tampilkan logo langsung
    setState(() {
      showImage = true;
    });

    // Tunggu 7 detik, lalu cek login dan navigate
    await Future.delayed(Duration(seconds: 7));

    if (mounted) {
      _checkLoginAndNavigate();
    }
  }

  void _checkLoginAndNavigate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      final classId = prefs.getString('classId') ?? '';
      final role = prefs.getString('role') ?? 'Guru';

      if (!mounted) return;

      if (isLoggedIn && classId.isNotEmpty) {
        // Sudah login, ke role option page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RoleOptionPage(classId: classId),
          ),
        );
      } else {
        // Belum login, ke login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(classId: classId, role: role),
          ),
        );
      }
    } catch (e) {
      debugPrint('Splash screen error: $e');

      // Jika error, default ke login page
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(classId: '', role: 'Guru'),
          ),
        );
      }
    }
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
            child:
                showImage
                    ? Image.asset('assets/images/logo_animation.gif')
                    : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
