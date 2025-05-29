import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifesync_capstone_project/guru_pages/guru_report_pages/guru_weekly_reports/guru_detail_weekly_report.dart';
import 'package:lifesync_capstone_project/theme/app_colors.dart';

class GuruListWeekly extends StatefulWidget {
  final String? classId;
  final String? temaId;

  const GuruListWeekly({
    super.key,
    required this.classId,
    required this.temaId,
  });

  @override
  State<GuruListWeekly> createState() => _GuruListWeeklyState();
}

class _GuruListWeeklyState extends State<GuruListWeekly> {
  List<Map<String, String>> children = [];
  String? temaTitle;

  @override
  void initState() {
    super.initState();
    _fetchChildren();
    _fetchTemaTitle();
  }

  Future<void> _fetchChildren() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('kelas')
              .doc(widget.classId)
              .collection('anak')
              .get();

      List<Map<String, String>> fetchedChildren =
          snapshot.docs.map((doc) {
            return {
              'name': (doc['name'] ?? '').toString(),
              'id': doc.id.toString(),
            };
          }).toList();

      // Urutkan berdasarkan nama (A-Z)
      fetchedChildren.sort((a, b) => a['name']!.compareTo(b['name']!));

      setState(() {
        children = fetchedChildren;
      });
    } catch (e) {
      debugPrint('Gagal mengambil daftar anak: $e');
    }
  }

  Future<void> _fetchTemaTitle() async {
    if (widget.classId == null || widget.temaId == null) return;

    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('kelas')
              .doc(widget.classId)
              .collection('tema')
              .doc(widget.temaId)
              .get();

      if (doc.exists) {
        setState(() {
          temaTitle = doc['Tema'] ?? 'Tema tanpa judul';
        });
      } else {
        setState(() {
          temaTitle = 'Tema tidak ditemukan';
        });
      }
    } catch (e) {
      debugPrint('Gagal mengambil tema: $e');
      setState(() {
        temaTitle = 'Gagal mengambil tema';
      });
    }
  }

  String getInitial(String name) {
    if (name.isEmpty) return '';
    return name.trim()[0].toUpperCase();
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
                  temaTitle != null
                      ? Text(
                        temaTitle!,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      )
                      : CircularProgressIndicator(),

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
                itemCount: children.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final child = children[index];
                  final name = child['name'] ?? '';
                  final anakId = child['id'] ?? '';
                  final initial = getInitial(name);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => GuruDetailWeeklyReport(
                                classId: widget.classId,
                                temaId: widget.temaId,
                                anakId: anakId,
                              ),
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
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: Text('Konfirmasi'),
                                      content: Text(
                                        'Yakin ingin menghapus Laporan Mingguan $name dari daftar?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.of(context).pop(),
                                          child: Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            try {
                                              // Hapus dari Firestore
                                              await FirebaseFirestore.instance
                                                  .collection('kelas')
                                                  .doc(widget.classId)
                                                  .collection('anak')
                                                  .doc(anakId)
                                                  .collection('laporanMingguan')
                                                  .doc(widget.temaId)
                                                  .delete();

                                              // Hapus dari UI
                                              setState(() {
                                                children.removeAt(index);
                                              });

                                              if (!context.mounted) return;
                                              Navigator.of(context).pop();

                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Laporan $name berhasil dihapus',
                                                  ),
                                                ),
                                              );
                                            } catch (e) {
                                              Navigator.of(context).pop();
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Gagal menghapus laporan: $e',
                                                  ),
                                                ),
                                              );
                                            }
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
