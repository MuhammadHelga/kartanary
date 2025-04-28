import 'package:flutter/material.dart';
import 'package:lifesync_capstone_project/guru_pages/guru_report_pages/guru_add_daily.dart';
import 'package:lifesync_capstone_project/guru_pages/guru_report_pages/guru_add_semester.dart';
import 'package:lifesync_capstone_project/guru_pages/guru_report_pages/guru_add_weekly.dart';
import '../../theme/AppColors.dart';
import '../../widgets/bottom_navbar.dart';
import 'guru_add_announcement.dart';

class GuruCreateActivityPage extends StatefulWidget {
  const GuruCreateActivityPage({super.key});

  @override
  State<GuruCreateActivityPage> createState() => _GuruCreateActivityPageState();
}

class _GuruCreateActivityPageState extends State<GuruCreateActivityPage> {

  final _formKey = GlobalKey<FormState>();
  String _selectedLaporan = 'Harian';
  final List<String> _laporanOptions = [
    'Harian',
    'Mingguan',
    'Semester',
    'Pengumuman',
  ];

  final TextEditingController _namaKegiatanController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  @override
  void dispose() {
    _namaKegiatanController.dispose();
    _lokasiController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  // Menampilkan halaman yang sesuai berdasarkan dropdown
  Widget _getLaporanPage() {
    switch (_selectedLaporan) {
      case 'Harian':
        return const AddDailyPage();
      case 'Mingguan':
        return const AddWeeklyPage();
      case 'Semester':
        return const AddSemesterPage();
      case 'Pengumuman':
        return const AddAnnouncementPage();
      default:
        return const SizedBox(); // Default page empty or placeholder
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary5,
      appBar: AppBar(
        backgroundColor: AppColors.primary50,
        elevation: 0,
        title: Text(
          'Buat Laporan',
          style: TextStyle(
            fontSize: 20,
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
              size: 22,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        toolbarHeight: 70,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Laporan label
            const Text(
              'Laporan',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                fontFamily: 'Inter',
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF2196D9)),
                borderRadius: BorderRadius.circular(9999),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedLaporan,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 14,
                  ),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedLaporan = newValue;
                      });
                    }
                  },
                  items: _laporanOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Halaman dinamis berdasarkan pilihan dropdown
            _getLaporanPage(),
          ],
        ),
      ),
    );
  }
}
