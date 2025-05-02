import 'package:flutter/material.dart';
import '../../theme/AppColors.dart';

class GuruWeeklyReportPage extends StatefulWidget {
  const GuruWeeklyReportPage({super.key});

  @override
  State<GuruWeeklyReportPage> createState() => _GuruWeeklyReportPageState();
}

class _GuruWeeklyReportPageState extends State<GuruWeeklyReportPage> {
  DateTime selectedDate = DateTime.now();

  final List<String> temaList = [
    'Tema 1: Keluargaku',
    'Tema 2: Lingkunganku',
    'Tema 3: Binatang dan Tumbuhan',
    'Tema 4: Kesehatanku',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary5,
      appBar: AppBar(
        backgroundColor: AppColors.primary50,
        elevation: 0,
        title: Text(
          'Laporan Mingguan',
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: ListView.separated(
          itemCount: temaList.length,
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemBuilder: (context, index) {
            final isEven = index % 2 == 0;
            final bgColor = isEven ? AppColors.primary10 : AppColors.secondary50;

            return GestureDetector(
              onTap: () {
                // Aksi ketika item diklik
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Expanded (
                      child: Text(
                      temaList[index],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, 
                    ),
                    ),
                    // const Spacer(),
                    const Icon(Icons.chevron_right, size: 38),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
