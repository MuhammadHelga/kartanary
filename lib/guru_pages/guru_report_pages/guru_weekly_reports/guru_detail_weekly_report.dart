import 'package:flutter/material.dart';
import '../../../theme/AppColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GuruDetailWeeklyReport extends StatefulWidget {
  final String? classId;
  final String? temaId;
  final String? anakId;
  const GuruDetailWeeklyReport({
    super.key,
    required this.classId,
    required this.temaId,
    required this.anakId,
  });

  @override
  State<GuruDetailWeeklyReport> createState() => _GuruDetailWeeklyReportState();
}

class _GuruDetailWeeklyReportState extends State<GuruDetailWeeklyReport> {
  String? nameUser;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<List<Map<String, dynamic>>> fetchReports() async {
    final anakDoc =
        await FirebaseFirestore.instance
            .collection('kelas')
            .doc(widget.classId)
            .collection('anak')
            .doc(widget.anakId)
            .get();

    final anakName = anakDoc.data()?['name'] ?? 'Anak';

    final laporanDoc =
        await FirebaseFirestore.instance
            .collection('kelas')
            .doc(widget.classId)
            .collection('anak')
            .doc(widget.anakId)
            .collection('laporanMingguan')
            .doc(widget.temaId)
            .get();

    if (laporanDoc.exists) {
      final data = laporanDoc.data();
      return [
        {
          'nama': data?['studentName'] ?? anakName,
          'tema': data?['tema'] ?? '',
          'pesanGuru': data?['pesanGuru'] ?? '',
          'weeks': data?['weeks'] ?? [],
        },
      ];
    }

    return [];
  }

  Future<void> _loadUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      if (doc.exists) {
        setState(() {
          nameUser = doc['name'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: AppColors.primary50,
        elevation: 0,
        title: const Text(
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
            child: const Icon(
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchReports(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Belum ada laporan untuk tema ini"),
            );
          }

          final reports = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              // final nama = report['nama'];
              final tema = report['tema'];
              final pesanGuru = report['pesanGuru'];
              final weeks = report['weeks'] as List;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Tema',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: TextEditingController(text: tema),
                    textAlign: TextAlign.center,
                    enabled: false,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.only(bottom: 4),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  const SizedBox(height: 24),

                  for (int i = 0; i < weeks.length; i++)
                    _buildReadonlyWeekBlock(
                      i + 1,
                      weeks[i]['judul'] ?? '',
                      weeks[i]['deskripsi'] ?? '',
                    ),

                  const SizedBox(height: 20),
                  _messageGuru(pesanGuru),
                  const Divider(thickness: 2),
                  const SizedBox(height: 30),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildReadonlyWeekBlock(int mingguKe, String judul, String deskripsi) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary10,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Minggu $mingguKe:',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    judul,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFE6F0FA),

              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
            ),
            width: double.infinity,
            padding: const EdgeInsets.all(10),

            child: Text(deskripsi, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _messageGuru(String description) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.secondary500,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
            child: const Text(
              'Pesan Guru',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.secondary50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
            ),

            child: Text(description, style: const TextStyle(fontSize: 14)),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
