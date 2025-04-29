import 'package:flutter/material.dart';
import '../../widgets/bottom_navbar.dart';
import '../../pages/login_page.dart';
import 'edit_profile.dart';

class ProfilePage extends StatelessWidget {
  final String role;
  const ProfilePage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            // padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xff1D99D3),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xffF2F9FD),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.chevron_left,
                                color: Color(0xff1D99D3),
                                size: 34,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => BottomNavbar(role: role),
                                  ),
                                );
                              },
                              tooltip: 'Back',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: const Text(
                              'Profil',
                              style: TextStyle(
                                color: Color(0xffF2F9FD),
                                fontWeight: FontWeight.w600,
                                fontSize: 28,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 20,
                        ),
                        child: Row(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'assets/images/photo1.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Riani',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffF2F9FD),
                                  ),
                                ),
                                Text(
                                  'Orang Tua',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xffF2F9FD),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.edit_square,
                                color: Color(0xffF2F9FD),
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => EditProfile(role: role),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                    color: Color(0xffFDF2CE),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              'assets/images/photo2.png',
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Anak',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Liana Almira',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text('KB - A1', style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 50),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'PENGATURAN',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 238, 242, 245),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 18,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: InkWell(
                          child: Row(
                            children: [
                              Icon(
                                Icons.settings_outlined,
                                color: Color(0xff333333),
                                size: 30,
                              ),
                              Text('Umum', style: TextStyle(fontSize: 20)),
                              Spacer(),
                              Icon(
                                Icons.chevron_right,
                                color: Color(0xffA8A8A8),
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Container(
                            color: Color(0xffAFB1B6),
                            width: double.infinity,
                            height: 1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: InkWell(
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outlined,
                                color: Color(0xff333333),
                                size: 30,
                              ),
                              Text('Tentang', style: TextStyle(fontSize: 20)),
                              Spacer(),
                              Icon(
                                Icons.chevron_right,
                                color: Color(0xffA8A8A8),
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Container(
                            color: Color(0xffAFB1B6),
                            width: double.infinity,
                            height: 1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(role: role),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout_outlined,
                                color: Color(0xffDC040F),
                                size: 30,
                              ),
                              Text(
                                'LogOut',
                                style: TextStyle(
                                  color: Color(0xffDC040F),
                                  fontSize: 20,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.chevron_right,
                                color: Color(0xffA8A8A8),
                                size: 30,
                              ),
                            ],
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
