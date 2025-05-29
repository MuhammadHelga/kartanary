import 'package:flutter/material.dart';
import '../../../theme/AppColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailWeeklyReport extends StatefulWidget {
  final String? classId;
  final String? temaId;
  final String? anakId;

  const DetailWeeklyReport({
    super.key,
    required this.classId,
    required this.temaId,
    required this.anakId,
  });

  @override
  State<DetailWeeklyReport> createState() => _DetailWeeklyReportState();
}

class _DetailWeeklyReportState extends State<DetailWeeklyReport> {
  final TextEditingController _temaController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _reportFuture;

  String? guruName;
  String? _anakName;

  @override
  void initState() {
    super.initState();
    _loadGuruName();
    _reportFuture = fetchReports();
  }

  Future<void> _loadGuruName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      if (doc.exists) {
        setState(() {
          guruName = doc['name'];
        });
      }
    }
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
    setState(() => _anakName = anakName);

    debugPrint(
      "Fetching report for anakId: ${widget.anakId}, temaId: ${widget.temaId}",
    );

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
      final tema = data?['tema'] ?? '';
      _temaController.text = tema; // update controller
      return [
        {
          'nama': data?['studentName'] ?? anakName,
          'tema': tema,
          'pesanGuru': data?['pesanGuru'] ?? '',
          'weeks': data?['weeks'] ?? [],
        },
      ];
    }

    return [];
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        toolbarHeight: 70,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _reportFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Belum ada laporan untuk tema ini"),
            );
          }

          final report = snapshot.data!.first;
          // final tema = report['tema'];
          final pesanGuru = report['pesanGuru'];
          final weeks = List<Map<String, dynamic>>.from(report['weeks'] ?? []);

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            children: [
              const Center(
                child: Text(
                  'Laporan Perkembangan Anak',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
              ),
              if (_anakName != null)
                Center(
                  child: Text(
                    _anakName!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Tema',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _temaController,
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

              // List of weeks
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
