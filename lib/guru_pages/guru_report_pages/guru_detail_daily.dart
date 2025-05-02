import 'package:flutter/material.dart';
import '../../theme/AppColors.dart';

class DetailDailyReportPage extends StatefulWidget {
  const DetailDailyReportPage({super.key});

  @override
  State<DetailDailyReportPage> createState() => _DetailDailyReportPageState();
}

class _DetailDailyReportPageState extends State<DetailDailyReportPage> {

  final List<String> childrenNames = ['Dokja', 'Rafayel', 'Caleb', 'Moran', 'WKWK'];

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
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
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
      body: SingleChildScrollView(

      ),
    );
  }
}