import 'package:flutter/material.dart';
import '../ortu_pages/profile_pages/profile_page.dart';
import '../ortu_pages/home_pages/home_page.dart';
import '../ortu_pages/reporting_pages/reporting_page.dart';
import '../ortu_pages/presence_pages/presence_page.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> pages = [
    HomePage(),
    PresencePage(),
    ReportingPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          backgroundColor: Color(0xff1D99D3),
          type: BottomNavigationBarType.fixed,
          // showSelectedLabels: false,
          // showUnselectedLabels: false,
          iconSize: 35,
          selectedItemColor: Color(0xffF8FAFC),
          currentIndex: _selectedIndex,
          onTap: _onTap,
          items: [
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 0 ? Icons.home : Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 0 ? Icons.list : Icons.list),
              label: 'Presensi',
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 0 ? Icons.book : Icons.book),
              label: 'Laporan',
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 0 ? Icons.person : Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
