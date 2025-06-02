import 'package:flutter/material.dart';
// import 'package:lifesync_capstone_project/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../screens/role_option_page.dart';
import '../widgets/bottom_navbar.dart';
import '../ortu_pages/class_options.dart';
// import '../guru_pages/choose_class_page.dart';

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
      final role = prefs.getString('role') ?? '';

      // ===== PENTING: Cek juga Firebase Auth state =====
      final currentUser = FirebaseAuth.instance.currentUser;

      if (!mounted) return;

      // Jika ada saved login state DAN user masih ter-authenticate di Firebase
      if (isLoggedIn &&
          classId.isNotEmpty &&
          role.isNotEmpty &&
          currentUser != null) {
        if (role == 'Guru') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavbar(classId: classId, role: role),
            ),
          );
        } else if (role == 'Orang Tua') {
          // ===== FIX: Orang Tua ke ClassOptions, bukan RoleOptionPage =====
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ClassOptions(classId: classId, role: role),
            ),
          );
        } else {
          // Role tidak dikenal, ke RoleOptionPage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => RoleOptionPage(classId: ''),
            ),
          );
        }
      } else {
        // ===== CLEAR invalid saved state =====
        if (isLoggedIn || classId.isNotEmpty || role.isNotEmpty) {
          // Ada saved state tapi tidak lengkap/valid, clear semuanya
          await prefs.remove('isLoggedIn');
          await prefs.remove('classId');
          await prefs.remove('role');
        }

        // Belum login atau state tidak valid, ke RoleOptionPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RoleOptionPage(classId: '')),
        );
      }
    } catch (e) {
      debugPrint('Splash screen error: $e');

      // Jika error, fallback ke RoleOptionPage
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RoleOptionPage(classId: '')),
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
