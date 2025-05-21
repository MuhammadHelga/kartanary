import 'package:flutter/material.dart';
import '../guru_weekly_reports/guru_detail_weekly_report.dart';
import '../../../theme/AppColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GuruListWeekly extends StatefulWidget {
  final String tema;
  final String classId;

  const GuruListWeekly({super.key, required this.tema, required this.classId});

  @override
  State<GuruListWeekly> createState() => _GuruListWeeklyState();
}

class _GuruListWeeklyState extends State<GuruListWeekly> {
  List<String> childrenNames = [];

  String getInitial(String name) {
    if (name.isEmpty) return '';
    return name.trim()[0].toUpperCase();
  }

  @override
  void initState() {
    super.initState();
    _fetchChildrenWithReports();
  }

  Future<void> _fetchChildrenWithReports() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('laporan_mingguan')
              .where('kelasId', isEqualTo: widget.classId)
              .where('tema', isEqualTo: widget.tema)
              .get();

      final names =
          snapshot.docs.map((doc) => doc['nama'] as String).toSet().toList();

      setState(() {
        childrenNames = names;
      });
    } catch (e) {
      print('Gagal mengambil anak dengan laporan mingguan: $e');
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'Tema',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(widget.tema, style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: childrenNames.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final name = childrenNames[index];
                  final initial = getInitial(name);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GuruDetailWeeklyReport(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary10,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.secondary50,
                                radius: 28,
                                child: Text(
                                  initial,
                                  style: const TextStyle(
                                    color: AppColors.primary300,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.blue),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: Text('Konfirmasi'),
                                      content: Text(
                                        'Yakin ingin menghapus Laporan Mingguan ${childrenNames[index]}" dari daftar?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.of(
                                                    context,
                                                  ).pop(), // Tutup dialog
                                          child: Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              childrenNames.removeAt(
                                                index,
                                              ); // Hapus anak
                                            });
                                            Navigator.of(
                                              context,
                                            ).pop(); // Tutup dialog
                                          },
                                          child: Text(
                                            'Hapus',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
