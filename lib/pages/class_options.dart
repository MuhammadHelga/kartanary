import 'package:flutter/material.dart';
import '../pages/register_page.dart';
import '../widgets/bottom_navbar.dart';

class ClassOptions extends StatelessWidget {
  const ClassOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F9FD),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Center(
                child: Image.asset(
                  'assets/images/logo_paud.png',
                  height: 200,
                  width: 200,
                  fit: BoxFit.fill,
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
              Text(
                'Nama Siswa',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Pilih Nama Siswa Anda',
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
              Padding(
                padding: const EdgeInsets.only(top: 110),
                child: SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BottomNavbar()),
                      );
                    },
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
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
