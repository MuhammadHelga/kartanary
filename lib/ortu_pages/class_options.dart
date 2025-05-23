import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../ortu_pages/choose_student_page.dart';

class ClassOptions extends StatefulWidget {
  final String role;
  final String classId;
  const ClassOptions({super.key, required this.role, required this.classId});

  @override
  State<ClassOptions> createState() => _ClassOptionsState();
}

class _ClassOptionsState extends State<ClassOptions> {
  final TextEditingController _kodeKelasController = TextEditingController();

  // Function to save classId and studentName to SharedPreferences
  void _bergabung() async {
    String kodeKelas = _kodeKelasController.text.trim();

    if (kodeKelas.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Kode kelas tidak boleh kosong')));
      return;
    }

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('kelas')
              .where('kode_kelas', isEqualTo: kodeKelas)
              .limit(1)
              .get();

      if (snapshot.docs.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Kode kelas tidak ditemukan')));
        return;
      }

      final classDoc = snapshot.docs.first;
      final classId = classDoc.id;

      // ✅ Update joinedClassId di Firestore untuk user yang login
      final user = FirebaseFirestore.instance.collection('users');
      final uid = await _getCurrentUserId();
      if (uid == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mendapatkan UID pengguna')),
        );
        return;
      }

      await user.doc(uid).update({'joinedClassId': kodeKelas});

      print('✅ Bergabung ke classId: $classId');

      // Arahkan ke halaman yang memerlukan classId
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  ChooseStudentPage(classId: classId, role: 'Orang Tua'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    }
  }

  Future<String?> _getCurrentUserId() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return uid;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color.fromARGB(255, 176, 230, 255), Color(0xFFFFFFFF)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.only(
            left: 30,
            top: 30,
            right: 30,
            bottom: 60,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff98D5F1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Color(0xff1D99D3),
                        size: 36,
                      ),
                      onPressed: () {
                        Navigator.pop(
                          context,
                        ); // Navigasi ke halaman sebelumnya
                      },
                    ),
                  ),
                ),
              ),
              Center(
                child: Image.asset(
                  'assets/images/logo_paud.png',
                  height: 200,
                  width: 300,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Memantau perkembangan anak dengan lebih mudah',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Kode Kelas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _kodeKelasController,
                decoration: InputDecoration(
                  hintText: 'Masukkan Kode Kelas',
                  hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xffF8FAFC),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Color(0xff1D99D3), width: 3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Color(0xff1D99D3), width: 3),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Spacer(),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _bergabung,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff1D99D3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Bergabung',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
