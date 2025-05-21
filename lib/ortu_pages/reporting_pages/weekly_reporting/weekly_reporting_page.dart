import 'package:flutter/material.dart';
import '../../../theme/AppColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../weekly_reporting/detail_weekly_report.dart';

class WeeksReportingPage extends StatefulWidget {
  final String classId;
  const WeeksReportingPage({super.key, required this.classId});

  @override
  State<WeeksReportingPage> createState() => _WeeksReportingPageState();
}

class _WeeksReportingPageState extends State<WeeksReportingPage> {
  // List<String> temaList = [];
  List<Map<String, dynamic>> temaList = [];

  @override
  void initState() {
    super.initState();
    _fetchThemes(); // Fetch themes when the widget is initialized
  }

  Future<void> _fetchThemes() async {
    try {
      // Fetch themes from Firestore
      final snapshot =
          await FirebaseFirestore.instance
              .collection('laporan_mingguan') // Koleksi laporan mingguan
              .where(
                'kelasId',
                isEqualTo: widget.classId,
              ) // Filter berdasarkan classId
              .get();

      // Map the documents to a list of theme names and their docId
      setState(() {
        temaList =
            snapshot.docs.map((doc) {
              return {
                'tema': doc['tema'] as String,
                'docId': doc.id, // Ambil docId
              };
            }).toList();
      });
    } catch (e) {
      print('Error fetching themes: $e');
      // Handle error (e.g., show a message to the user)
    }
  }

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
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: ListView.separated(
          itemCount: temaList.length,
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemBuilder: (context, index) {
            final data = temaList[index];
            final tema = data['tema'];
            final docId = data['docId'];
            final isEven = index % 2 == 0;
            final bgColor =
                isEven ? AppColors.primary10 : AppColors.secondary50;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailWeeklyReport(docId: docId),
                  ),
                );
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
                    Expanded(
                      child: Text(
                        'Tema ${index + 1}:  $tema',
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
