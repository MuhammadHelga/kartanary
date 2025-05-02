import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../../theme/AppColors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class AddSemesterPage extends StatefulWidget {
  const AddSemesterPage({Key? key}) : super(key: key);

  @override
  State<AddSemesterPage> createState() => _AddSemesterPageState();
}

class _AddSemesterPageState extends State<AddSemesterPage> {
  final List<String> childrenNames = ['Dokja', 'Rafayel', 'Caleb', 'Moran', 'WKWK'];
  final List<String> semesterOptions = [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4',
    'Semester 5',
  ];

  String? _selectedLaporan;
  String? _selectedSemester;
  File? _selectedFile;

  Future<void> _pickDocument() async {
    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;

      if (deviceInfo.version.sdkInt >= 33) {
        // Android 13+ biasanya tidak butuh izin storage untuk FilePicker
        // Tapi kalau perlu bisa pakai Permission.manageExternalStorage
        var status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          _showDeniedSnackBar();
          return;
        }
      } else {
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          _showDeniedSnackBar();
          return;
        }
      }
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
      _selectedFile = File(result.files.single.path!);
      });
    }
  }


  void _showDeniedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Permission ditolak')),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SizedBox(height: 20),
          _buildDropdown(
            hint: 'Pilih nama anak',
            value: _selectedLaporan,
            items: childrenNames,
            onChanged: (val) => setState(() => _selectedLaporan = val),
          ),
          const SizedBox(height: 20),
          _buildDropdown(
            hint: 'Pilih Semester',
            value: _selectedSemester,
            items: semesterOptions,
            onChanged: (val) => setState(() => _selectedSemester = val),
          ),
          const SizedBox(height: 50),
          const Text(
            'Upload Laporan Pembelajaran',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          const SizedBox(height: 20),
          Center(
            child: GestureDetector(
              // onTap: _pickDocument,
              child: _selectedFile != null
                  ? Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Text(
                        'Dokumen dipilih: ${_selectedFile!.path.split('/').last}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    )
                  : OutlinedButton(
                      onPressed: _pickDocument,
                      style: OutlinedButton.styleFrom(
                        fixedSize: const Size(270, 120),
                        side: BorderSide(color: AppColors.primary30, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.upload_file, size: 32, color: AppColors.primary30),
                          SizedBox(height: 8),
                          Text('Unggah PDF/Dokumen'),
                        ],
                      ),
                    ),
            ),
          ),
          SizedBox(height: 200),
          
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Validasi semua TextField
                bool isValid = _selectedLaporan != null &&
                    _selectedSemester != null &&
                    _selectedFile != null;
                if (isValid) {
                  // Tampilkan pop up sukses
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Berhasil"),
                        content: const Text("Laporan berhasil disimpan."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Tutup dialog
                              Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Tampilkan error jika ada field kosong
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Harap isi semua kolom sebelum menyimpan."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
                ),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical:10),
                elevation: 5,
                shadowColor: Colors.black.withOpacity(0.25),
              ),
              child: const Text(
                'Simpan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary30, width: 3),
        borderRadius: BorderRadius.circular(9999),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            blurRadius: 2,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: AppColors.black,
            fontSize: 14,
          ),
          items: items.map((String name) {
            return DropdownMenuItem<String>(
              value: name,
              child: Text(name),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
