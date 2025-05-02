import 'package:flutter/material.dart';
import 'package:lifesync_capstone_project/guru_pages/guru_create_activity_pages/guru_create_activity.dart';
import '../../theme/AppColors.dart';

class GuruDailyReportPage extends StatefulWidget {
  const GuruDailyReportPage({super.key});

  @override
  State<GuruDailyReportPage> createState() => _GuruDailyReportPageState();
}

class _GuruDailyReportPageState extends State<GuruDailyReportPage> {
  DateTime selectedDate = DateTime.now();

  final List<Map<String, String>> activities = [
    {
      'title': 'KB - A1 Belajar Menggambar',
      'date': 'Kamis, 1 Mei 2025',
      'image': 'assets/images/laporan_img.png',
    },
    {
      'title': 'TK - B2 Bermain Musik',
      'date': 'Kamis, 1 Mei 2025',
      'image': 'assets/images/laporan_img.png',
    },
  ];

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff1D99D3),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String _monthName(int month) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary5,
      appBar: AppBar(
        backgroundColor: AppColors.primary50,
        elevation: 0,
        title: Text(
          'Laporan Harian',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.primary5,
          ),
        ),
        leading: IconButton(
          padding: const EdgeInsets.only(left: 12.0),
          icon: Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
            ),
            child: Icon(
              Icons.chevron_left,
              color: AppColors.primary50,
              size: 26,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        toolbarHeight: 70,
      ),
    );
  }
}
