import 'package:flutter/material.dart';
import '../pages/login_page.dart';

class RoleOptionPage extends StatelessWidget {
  final String classId;
  const RoleOptionPage({super.key, required this.classId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color.fromARGB(255, 176, 230, 255), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/kartanary_logo.png'),
                    Text(
                      'Pilih Role',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    roleBtn('Guru', 'assets/images/logo_guru.png'),
                    roleBtn('Orang Tua', 'assets/images/logo_ortu.png'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget roleBtn(String name, String imgPath) {
    return Builder(
      builder: (context) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: 300,
          height: 100,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(role: name, classId: classId),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffC5E7F7),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(imgPath, height: 50, width: 50),
                SizedBox(width: 20),
                Text(
                  'Saya $name',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
