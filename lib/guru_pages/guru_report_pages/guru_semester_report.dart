import 'package:flutter/material.dart';
import '../../theme/AppColors.dart';
import '../../widgets/bottom_navbar.dart';

class GuruSemesterReportPage extends StatefulWidget {
  const GuruSemesterReportPage({super.key});

  @override
  State<GuruSemesterReportPage> createState() => _GuruSemesterReportPageState();
}

class _GuruSemesterReportPageState extends State<GuruSemesterReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary5,
      appBar: AppBar(
        backgroundColor: AppColors.primary50,
        elevation: 0,
        title: Text(
          'Laporan Semester',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.primary5,
          ),
        ),
        leading: IconButton(
          padding: const EdgeInsets.only(left: 12.0),
          icon: Container(
            padding: EdgeInsets.all(3.0),
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
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        toolbarHeight: 70,
      ),
    );
  }
}
