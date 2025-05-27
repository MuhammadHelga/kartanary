import 'package:flutter/material.dart';
import 'package:lifesync_capstone_project/pages/login_page.dart';
import 'package:lifesync_capstone_project/widgets/bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'role_option_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    // Timer(Duration(seconds: 3), () {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const RoleOptionPage(classId: ''),
    //     ),
    //   );
    // });
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final classId = prefs.getString('classId');
    final role = prefs.getString('role') ?? 'Guru';

    if (isLoggedIn && classId != null) {
      // ✅ langsung masuk ke halaman kelas
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavbar(classId: classId, role: role),
        ),
      );
    } else {
      // 🔒 belum login atau belum pilih kelas
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(classId: classId ?? '', role: role),
        ),
      );
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
            child: Image.asset('assets/images/kartanary_logo.png'),
          ),
        ),
      ),
    );
  }
}
