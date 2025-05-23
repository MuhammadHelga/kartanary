// import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../theme/AppColors.dart';
import 'dart:io';

class SemesterReportPage extends StatefulWidget {
  final String classId;
  const SemesterReportPage({super.key, required this.classId});

  @override
  State<SemesterReportPage> createState() => _SemesterReportPageState();
}

class _SemesterReportPageState extends State<SemesterReportPage> {
  List<Map<String, dynamic>> semester1Reports = [];
  List<Map<String, dynamic>> semester2Reports = [];
  bool isLoading = true;
  String? selectedChildId;
  String? selectedChildName;

  @override
  void initState() {
    super.initState();
    _loadSelectedChild();
  }

  Future<void> _loadSelectedChild() async {
    final prefs = await SharedPreferences.getInstance();
    final childId = prefs.getString('selectedChildId');

    if (childId != null) {
      setState(() {
        selectedChildId = childId;
      });
      await fetchLaporanSemester();
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada anak yang dipilih')),
      );
    }
  }

  Future<void> fetchLaporanSemester() async {
    try {
      if (selectedChildId == null) return;

      // Ambil data anak
      final anakDoc =
          await FirebaseFirestore.instance
              .collection('kelas')
              .doc(widget.classId)
              .collection('anak')
              .doc(selectedChildId)
              .get();

      if (!anakDoc.exists) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data anak tidak ditemukan')),
        );
        return;
      }

      final anakName = anakDoc['name'];
      setState(() {
        selectedChildName = anakName;
      });

      // Ambil laporan Semester 1
      final laporan1 =
          await FirebaseFirestore.instance
              .collection('anak')
              .doc(selectedChildId)
              .collection('laporanSemester')
              .doc('Semester 1')
              .get();

      if (laporan1.exists && laporan1.data()?['pdfUrl'] != null) {
        semester1Reports.add({
          'anakName': anakName,
          'fileUrl': laporan1['pdfUrl'],
          'uploadedAt':
              laporan1['uploadedAt'] != null
                  ? (laporan1['uploadedAt'] as Timestamp).toDate().toString()
                  : 'Tanggal tidak tersedia',
        });
      }

      // Ambil laporan Semester 2
      final laporan2 =
          await FirebaseFirestore.instance
              .collection('anak')
              .doc(selectedChildId)
              .collection('laporanSemester')
              .doc('Semester 2')
              .get();

      if (laporan2.exists && laporan2.data()?['pdfUrl'] != null) {
        semester2Reports.add({
          'anakName': anakName,
          'fileUrl': laporan2['pdfUrl'],
          'uploadedAt':
              laporan2['uploadedAt'] != null
                  ? (laporan2['uploadedAt'] as Timestamp).toDate().toString()
                  : 'Tanggal tidak tersedia',
        });
      }

      setState(() => isLoading = false);
    } catch (e) {
      print('Error fetching laporan: $e');
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data laporan: $e')),
      );
    }
  }

  Future<void> downloadFile(String url, String fileName) async {
    try {
      // Minta izin penyimpanan (hanya di Android)
      if (Platform.isAndroid) {
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Izin penyimpanan ditolak')),
          );
          return;
        }
      }

      // Ambil direktori unduhan
      Directory directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final filePath = '${directory.path}/$fileName';

      Dio dio = Dio();
      await dio.download(url, filePath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Laporan berhasil diunduh ke $filePath')),
      );
    } catch (e) {
      print('Error saat download: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal mengunduh file')));
    }
  }

  // Future<void> _launchUrl(String url) async {
  //   final uri = Uri.parse(url);
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('URL tidak valid atau tidak bisa dibuka')),
  //     );
  //   }
  // }

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
          onPressed: () => Navigator.of(context).pop(),
        ),
        toolbarHeight: 70,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSemesterSection('Semester 1', semester1Reports),
                    const SizedBox(height: 30),
                    _buildSemesterSection('Semester 2', semester2Reports),
                  ],
                ),
              ),
    );
  }

  Widget _buildSemesterSection(
    String title,
    List<Map<String, dynamic>> reports,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        reports.isEmpty
            ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Belum ada laporan untuk $title',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
            : Column(
              children:
                  reports.map((report) {
                    return Card(
                      color: AppColors.primary10,
                      margin: const EdgeInsets.only(bottom: 15),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.picture_as_pdf,
                              size: 24,
                              color: AppColors.error300,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                report['anakName'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.download,
                                color: Colors.blue,
                                size: 24,
                              ),
                              onPressed: () {
                                final url = report['fileUrl'];
                                final name = report['anakName'];
                                if (url != null && url.isNotEmpty) {
                                  downloadFile(
                                    url,
                                    '$name-${title.replaceAll(' ', '_')}.pdf',
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
      ],
    );
  }
}
