import 'package:flutter/material.dart';
import '../pages/login_page.dart';

class RoleOptionPage extends StatelessWidget {
  const RoleOptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Semantics(
              label:
                  'Logo with two abstract human figures, one yellow and one blue, reaching for a star',
              child: Image.asset(
                'assets/images/logo_paud.png',
                height: 200,
                width: 200,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Pilih Role',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: const SizedBox(
                width: double.infinity,
                child: RoleButton(
                  iconPath: 'assets/images/logo_ortu.png',
                  text: 'Saya Orang Tua',
                  altText: 'Icon ortu',
                ),
              ),
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: SizedBox(
                width: double.infinity,
                child: RoleButton(
                  iconPath: 'assets/images/logo_guru.png',
                  text: 'Saya Guru',
                  altText: 'Icon guru',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoleButton extends StatelessWidget {
  final String iconPath;
  final String text;
  final String altText;

  const RoleButton({
    Key? key,
    required this.iconPath,
    required this.text,
    required this.altText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFB3E5FC),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadowColor: Colors.black,
        elevation: 4,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            label: altText,
            child: Image.asset(iconPath, height: 40, width: 40),
          ),
          const SizedBox(width: 16),
          Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
