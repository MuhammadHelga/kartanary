import 'package:flutter/material.dart';
import '../../theme/AppColors.dart';
import '../../widgets/bottom_navbar.dart';

class AddAnnouncementPage extends StatefulWidget {
  const AddAnnouncementPage({super.key});

  @override
  State<AddAnnouncementPage> createState() => _AddAnnouncementPageState();
}

class _AddAnnouncementPageState extends State<AddAnnouncementPage> {

  final TextEditingController namaKegiatanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Form Pengumuman', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        // Tambahin form isian di sini
      ],
    );
  }
}