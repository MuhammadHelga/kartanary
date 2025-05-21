import 'package:flutter/material.dart';
import '../../../theme/AppColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class GuruDetailWeeklyReport extends StatefulWidget {
  const GuruDetailWeeklyReport({super.key});

  @override
  State<GuruDetailWeeklyReport> createState() => _GuruDetailWeeklyReportState();
}

class _GuruDetailWeeklyReportState extends State<GuruDetailWeeklyReport> {
  String? _name;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  // Ambil nama pengguna dari Firestore
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
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        child: Center(
          child: Column(
            children: [
              Text(
                'Laporan Perkembangan Anak',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text('Liana Almira', style: TextStyle(fontSize: 20)),
              SizedBox(
                child: Container(
                  width: double.infinity,
                  height: 1,
                  decoration: BoxDecoration(color: Colors.black),
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Tema',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('Diri Sendiri', style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    // Setiap item 2 container digabung jadi 1 widget
                    _buildWeeklyReport(
                      'Minggu 1',
                      'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. Ia mampu menyebutkan nama lengkap, jenis kelamin, dan usia dengan percaya diri. Ananda juga mulai mengenali perbedaan dirinya dengan teman-teman sebayanya, serta menunjukkan rasa bangga terhadap dirinya sendiri.',
                    ),
                    _buildWeeklyReport(
                      'Minggu 2',
                      'Ananda mampu mengenali dan menyebutkan lima panca indera beserta fungsinya secara sederhana. Ia dapat mengaitkan kegiatan sehari-hari dengan penggunaan panca indera, seperti melihat dengan mata, mendengar dengan telinga, mencium dengan hidung, meraba dengan tangan, dan merasakan dengan lidah. Ananda juga menunjukkan rasa ingin tahu yang tinggi dalam mengeksplorasi lingkungannya menggunakan panca indera..',
                    ),
                    _buildWeeklyReport(
                      'Minggu 3',
                      'Ananda berinteraksi aktif dengan teman...',
                    ),
                    _buildWeeklyReport(
                      'Minggu 4',
                      'Ananda menunjukkan rasa empati...',
                    ),
                    _messageGuru(
                      'Kami mengapresiasi dukungan orang tua dalam proses belajar Ananda. Mohon terus dampingi dan berikan ruang eksplorasi di rumah agar perkembangan Ananda semakin optimal.',
                    ),
                    Text(
                      'Malang, 2 Mei 2025',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.end,
                    ),
                    Text(
                      'Miss Nana',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
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
}