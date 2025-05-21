import 'package:flutter/material.dart';
import '../../../theme/AppColors.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailWeeklyReport extends StatefulWidget {
  final String docId;
  const DetailWeeklyReport({super.key, required this.docId});

  @override
  State<DetailWeeklyReport> createState() => _DetailWeeklyReportState();
}

class _DetailWeeklyReportState extends State<DetailWeeklyReport> {
  String? _name;
  Map<String, dynamic>? laporan;
  List<Map<String, dynamic>> mingguList = [];

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _fetchLaporanMingguan();
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
          _name = doc['name'];
        });
      }
    }
  }

  Future<void> _fetchLaporanMingguan() async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('laporan_mingguan')
          .doc(widget.docId);

      final doc = await docRef.get();

      if (doc.exists) {
        final data = doc.data()!;

        final mingguSnapshot = await docRef.collection('minggu').get();

        final List<Map<String, dynamic>> minggu =
            mingguSnapshot.docs.map((d) => d.data()).toList();

        setState(() {
          laporan = data;
          mingguList = minggu;
        });
      } else {
        print("Dokumen tidak ditemukan.");
      }
    } catch (e) {
      print('Gagal mengambil laporan mingguan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
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
      body:
          laporan == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'Laporan Perkembangan Anak',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(laporan?['nama'], style: TextStyle(fontSize: 20)),
                      SizedBox(
                        child: Container(
                          width: double.infinity,
                          height: 1,
                          decoration: BoxDecoration(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        laporan?['tema'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child:
                            mingguList.isEmpty
                                ? Text("Belum ada laporan minggu.")
                                : ListView.builder(
                                  itemCount: mingguList.length,
                                  itemBuilder: (context, index) {
                                    final minggu = mingguList[index];
                                    final judul =
                                        (minggu['judul'] ?? '')
                                            .toString()
                                            .trim();
                                    final deskripsi =
                                        (minggu['deskripsi'] ?? '')
                                            .toString()
                                            .trim();
                                    final label = 'Minggu ${index + 1}: $judul';
                                    return _buildWeeklyReport(label, deskripsi);
                                  },
                                ),
                      ),
                      if ((laporan?['pesanGuru'] ?? '').toString().isNotEmpty)
                        _messageGuru(laporan!['pesanGuru']),
                      const SizedBox(height: 10),
                      Text(
                        'Malang, ${_formatTanggal(laporan!['tanggal'])}',
                        style: const TextStyle(fontSize: 20),
                        textAlign: TextAlign.end,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _name ?? '',
                        style: const TextStyle(fontSize: 20),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildWeeklyReport(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.primary10,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Text(title, style: TextStyle(fontSize: 20)),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.primary5,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: Text(description, style: TextStyle(fontSize: 16)),
        ),
        SizedBox(height: 16), // Spacer antar card
      ],
    );
  }

  Widget _messageGuru(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.secondary500,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Text('Pesan Guru', style: TextStyle(fontSize: 20)),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.secondary50,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: Text(description, style: TextStyle(fontSize: 16)),
        ),
        SizedBox(height: 16), // Spacer antar card
      ],
    );
  }

  String _formatTanggal(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    return '${date.day} ${_bulan(date.month)} ${date.year}';
  }

  String _bulan(int month) {
    const bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return bulan[month - 1];
  }
}
