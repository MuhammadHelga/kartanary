import 'package:flutter/material.dart';
import '../../theme/AppColors.dart';
import '../../widgets/bottom_navbar.dart';

class AddWeeklyPage extends StatelessWidget {
  const AddWeeklyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Form Mingguan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        // Tambahin form isian di sini
      ],
    );
  }
}