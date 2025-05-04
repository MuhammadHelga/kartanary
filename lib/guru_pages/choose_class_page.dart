import 'package:flutter/material.dart';
import '../theme/AppColors.dart';
import 'create_class_page.dart';
import '../widgets/bottom_navbar.dart';
import 'join_class_page.dart';

class ChooseClassPage extends StatefulWidget {
  final String role;
  const ChooseClassPage({Key? key, required this.role}) : super(key: key);

  @override
  State<ChooseClassPage> createState() => _ChooseClassPageState();
}

class _ChooseClassPageState extends State<ChooseClassPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F9FD),
      appBar: AppBar(
        backgroundColor: AppColors.primary5,
        leading: IconButton(
          padding: const EdgeInsets.only(left: 20),
          icon: Container(
            padding: EdgeInsets.all(6.5), // Padding di sekitar ikon
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Membuat bentuk bulat
              color: AppColors.primary20, // Warna latar belakang bulatan
            ),
            child: Icon(
              Icons.chevron_left,
              color: AppColors.primary50, // Warna ikon
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // Menambahkan SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.only(
              top: 100,
            ), // Menambahkan padding agar konten naik
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment:
                  MainAxisAlignment.start, // Mengubah alignment jadi start
              children: <Widget>[
                // Logo
                Image.asset(
                  'assets/images/logo_paud.png',
                  width: 250,
                  height: 250,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Tambahkan kelas untuk memulai',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffF2F9FD),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        BottomNavbar(role: widget.role),
                              ),
                            );
                          },
                          child: const Text(
                            'Bergabung\nke Kelas',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF1779A6),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF54B7EB),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 6,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateClassPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Buat\nKelas Baru',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
