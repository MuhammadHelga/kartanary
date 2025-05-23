import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/AppColors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSemesterPage extends StatefulWidget {
  final String classId;

  const AddSemesterPage({Key? key, required this.classId}) : super(key: key);

  @override
  State<AddSemesterPage> createState() => _AddSemesterPageState();
}

class _AddSemesterPageState extends State<AddSemesterPage> {
  final List<String> semesterOptions = ['Semester 1', 'Semester 2'];

  List<Map<String, dynamic>> _children = [];
  bool _isLoadingChildren = true;

  String? _selectedChildId;
  String? _selectedSemester;
  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    print('classId dari widget: ${widget.classId}');
    fetchChildrenFromFirestore();
  }

  Future<void> fetchChildrenFromFirestore() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('kelas')
              .doc(widget.classId)
              .collection('anak')
              .get();

      print('Ditemukan ${snapshot.docs.length} anak');
      for (var doc in snapshot.docs) {
        print('Anak: ${doc.id}, data: ${doc.data()}');
      }

      setState(() {
        _children =
            snapshot.docs
                .map((doc) => {'id': doc.id, 'name': doc['name']})
                .toList();
        if (mounted) {
          setState(() {
            _isLoadingChildren = false;
          });
        }
      });
    } catch (e) {
      print('Gagal mengambil data anak: $e');
      setState(() => _isLoadingChildren = false);
    }
  }

  Future<void> uploadPdfAndSaveToFirebase(
    String anakId,
    String semester,
    File file,
  ) async {
    final fileName = '${widget.classId}_${anakId}_$semester.pdf';
    final supabase = Supabase.instance.client;

    try {
      // 1. Upload ke Supabase Storage
      final filePath = 'laporan/$fileName';
      await supabase.storage
          .from('semester-report')
          .upload(filePath, file, fileOptions: const FileOptions(upsert: true));

      final publicUrl = supabase.storage
          .from('semester-report')
          .getPublicUrl(filePath);

      // 2. Simpan ke Firestore dengan struktur baru
      final batch = FirebaseFirestore.instance.batch();

      // Simpan di koleksi anak utama (untuk akses global)
      final anakRef = FirebaseFirestore.instance
          .collection('anak')
          .doc(anakId)
          .collection('laporanSemester')
          .doc(semester);

      batch.set(anakRef, {
        'pdfUrl': publicUrl,
        'uploadedAt': Timestamp.now(),
        'semester': semester,
        'classId': widget.classId, // Tambahkan classId untuk referensi
      });

      // Simpan di koleksi kelas -> classId -> anak (untuk akses per kelas)
      final kelasAnakRef = FirebaseFirestore.instance
          .collection('kelas')
          .doc(widget.classId)
          .collection('anak')
          .doc(anakId)
          .collection('laporanSemester')
          .doc(semester);

      batch.set(kelasAnakRef, {
        'pdfUrl': publicUrl,
        'uploadedAt': Timestamp.now(),
        'semester': semester,
      });

      await batch.commit();
      _showSuccessDialog(publicUrl);
    } catch (e) {
      print('Error saat upload: $e');
      _showErrorSnackBar("Gagal mengunggah file.");
    }
  }

  Future<void> _pickDocument() async {
    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;

      if (deviceInfo.version.sdkInt >= 33) {
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
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  void _showDeniedSnackBar() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Permission ditolak')));
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessDialog(String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Berhasil"),
          content: const Text("Laporan berhasil diunggah."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _isLoadingChildren
              ? const Center(child: CircularProgressIndicator())
              : _buildDropdown(
                hint: 'Pilih nama anak',
                value: _selectedChildId,
                items: _children.map((e) => e['id'] as String).toList(),
                itemLabels: _children.map((e) => e['name'] as String).toList(),
                onChanged: (val) => setState(() => _selectedChildId = val),
              ),
          const SizedBox(height: 20),
          _buildDropdown(
            hint: 'Pilih Semester',
            value: _selectedSemester,
            items: semesterOptions,
            itemLabels: semesterOptions,
            onChanged: (val) => setState(() => _selectedSemester = val),
          ),
          const SizedBox(height: 40),
          const Text(
            'Upload Laporan Pembelajaran',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          const SizedBox(height: 20),
          Center(
            child:
                _selectedFile != null
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
                          Icon(
                            Icons.upload_file,
                            size: 32,
                            color: AppColors.primary30,
                          ),
                          SizedBox(height: 8),
                          Text('Unggah PDF'),
                        ],
                      ),
                    ),
          ),
          const SizedBox(height: 100),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_selectedChildId != null &&
                    _selectedSemester != null &&
                    _selectedFile != null) {
                  uploadPdfAndSaveToFirebase(
                    _selectedChildId!,
                    _selectedSemester!,
                    _selectedFile!,
                  );
                } else {
                  _showErrorSnackBar(
                    "Harap lengkapi semua kolom dan unggah dokumen.",
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 10,
                ),
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
    required List<String> itemLabels,
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
          hint: Text(hint),
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: AppColors.black,
            fontSize: 14,
          ),
          items: List.generate(items.length, (index) {
            return DropdownMenuItem<String>(
              value: items[index],
              child: Text(itemLabels[index]),
            );
          }),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
