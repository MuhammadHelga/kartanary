import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../weekly_reporting/detail_weekly_report.dart'; // pastikan path ini benar

class WeeksReportingPage extends StatefulWidget {
  final String classId;
  const WeeksReportingPage({super.key, required this.classId});

  @override
  State<WeeksReportingPage> createState() => _WeeksReportingPageState();
}

class _WeeksReportingPageState extends State<WeeksReportingPage> {
  List<Map<String, dynamic>> temaList = [];
  String? selectedChildId;

  Future<void> _loadSelectedChild() async {
    final prefs = await SharedPreferences.getInstance();
    final childId = prefs.getString('selectedChildId');

    if (childId != null) {
      setState(() {
        selectedChildId = childId;
      });
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada anak yang dipilih')),
      );
    }
  }

  Future<void> _fetchTemas() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('kelas')
              .doc(widget.classId)
              .collection('tema')
              .get();

      if (snapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> fetchedTemas = [];

        for (var doc in snapshot.docs) {
          final data = doc.data();
          fetchedTemas.add({
            'id': doc.id,
            'tema': data['Tema'] ?? 'Tema tanpa judul',
            'minggu': data['minggu'] ?? [],
          });
        }

        fetchedTemas.sort(
          (a, b) => (a['tema'] ?? '').toString().toLowerCase().compareTo(
            (b['tema'] ?? '').toString().toLowerCase(),
          ),
        );

        setState(() {
          temaList = fetchedTemas;
        });
      }
    } catch (e) {
      debugPrint('Gagal mengambil daftar tema: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSelectedChild().then((_) => _fetchTemas());
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
            fontSize: 22,
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
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final isEven = index % 2 == 0;
            final bgColor =
                isEven ? AppColors.primary10 : AppColors.secondary50;

            return GestureDetector(
              onTap: () {
                if (selectedChildId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Anak belum dipilih')),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => DetailWeeklyReport(
                          classId: widget.classId,
                          temaId: temaList[index]['id'],
                          anakId: selectedChildId,
                        ),
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
                        'Tema: ${temaList[index]['tema'] ?? 'Tema tanpa judul'}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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
