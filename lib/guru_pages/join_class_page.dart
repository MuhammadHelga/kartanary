import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/bottom_navbar.dart';
import '/theme/AppColors.dart';

class JoinClassPage extends StatefulWidget {
  final String role;
  final String classId;
  const JoinClassPage({super.key, required this.role, required this.classId});

  @override
  _JoinClassPageState createState() => _JoinClassPageState();
}

class _JoinClassPageState extends State<JoinClassPage> {
  final TextEditingController _kodeKelasController = TextEditingController();

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
              .get();

      if (snapshot.docs.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Kode kelas tidak ditemukan')));
        return;
      }

      final classDoc = snapshot.docs.first;
      final classId = classDoc.id;

      debugPrint('✅ Bergabung ke classId: $classId');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavbar(classId: classId, role: 'Guru'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    }
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
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            padding: const EdgeInsets.only(left: 20),
            icon: Container(
              padding: EdgeInsets.all(6.5), // Padding di sekitar ikon
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Membuat bentuk bulat
                color: AppColors.neutral100, // Warna latar belakang bulatan
              ),
              child: Icon(Icons.chevron_left, color: AppColors.primary50),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics:
                    constraints.maxHeight < 600
                        ? const BouncingScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                // SizedBox(height: 50),
                                Image.asset(
                                  'assets/images/logo_paud.png',
                                  height: 150,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Bergabung ke Kelas',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 25),
                          Text(
                            'Kode Kelas',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: _kodeKelasController,
                            decoration: InputDecoration(
                              hintText: 'Masukkan Kode Kelas',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                              filled: true,
                              fillColor: Color(0xffF8FAFC),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 20,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Color(0xff1D99D3),
                                  width: 3,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Color(0xff1D99D3),
                                  width: 3,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Untuk masuk dengan kode kelas',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '• Gunakan akun yang telah terdaftar',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '• Gunakan kode kelas dengan 6-8 huruf atau angka, tanpa spasi atau simbol',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          // SizedBox(height: 20),
                          SizedBox(
                            height: 60,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _bergabung,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary50,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: Text(
                                'Bergabung',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
