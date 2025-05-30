import 'package:flutter/material.dart';
import 'package:lifesync_capstone_project/guru_pages/guru_create_activity_pages/weekly/guru_add_tema.dart';
import 'package:lifesync_capstone_project/theme/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifesync_capstone_project/widgets/custom_snackbar.dart';

class AddWeeklyPage extends StatefulWidget {
  final String classId;
  const AddWeeklyPage({super.key, required this.classId});

  @override
  State<AddWeeklyPage> createState() => _AddWeeklyPageState();
}

class _AddWeeklyPageState extends State<AddWeeklyPage> {
  List<TextEditingController> deskripsiControllers = [];
  List<String> childrenNames = [];
  List<String> temaList = [];
  List<Map<String, dynamic>> subTemaList = [];
  List<Map<String, dynamic>> childrenData = [];
  List<String> weekTitles = [];

  // Tambahkan untuk menyimpan existing reports
  List<Map<String, dynamic>> existingReports = [];
  bool isEditMode = false;
  String? currentReportId;

  String? _selectedLaporan;
  String? _selectedTema;
  String? _selectedTemaId;
  DateTime selectedDate = DateTime.now();

  final TextEditingController judulTemaController = TextEditingController();
  final TextEditingController pesanGuruController = TextEditingController();

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xff1D99D3),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchChildren();
    _fetchTemas();
  }

  Future<void> _fetchTemas() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('kelas')
              .doc(widget.classId)
              .collection('tema')
              .get();

      if (snapshot.docs.isNotEmpty) {
        List<String> temas = [];
        List<Map<String, dynamic>> temasWithDetails = [];

        for (var doc in snapshot.docs) {
          Map<String, dynamic> data = doc.data();
          temas.add(data['Tema'] ?? 'Tema tanpa judul');

          temasWithDetails.add({
            'id': doc.id,
            'Tema': data['Tema'],
            'minggu': data['minggu'] ?? [],
          });
        }

        setState(() {
          temaList = temas;
          subTemaList = temasWithDetails;
        });
      }
    } catch (e) {
      debugPrint('Gagal mengambil daftar tema: $e');
    }
  }

  // Fungsi baru untuk mengambil existing reports
  Future<void> _fetchExistingReports() async {
    if (_selectedLaporan == null) return;

    try {
      // Cari anakId berdasarkan nama
      final anakSnapshot =
          await FirebaseFirestore.instance
              .collection('kelas')
              .doc(widget.classId)
              .collection('anak')
              .where('name', isEqualTo: _selectedLaporan)
              .get();

      if (anakSnapshot.docs.isEmpty) return;

      String anakId = anakSnapshot.docs.first.id;

      // Ambil semua laporan mingguan untuk anak ini
      final reportsSnapshot =
          await FirebaseFirestore.instance
              .collection('kelas')
              .doc(widget.classId)
              .collection('anak')
              .doc(anakId)
              .collection('laporanMingguan')
              .get();

      List<Map<String, dynamic>> reports = [];
      for (var doc in reportsSnapshot.docs) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id; // Tambahkan document ID
        reports.add(data);
      }

      setState(() {
        existingReports = reports;
      });
    } catch (e) {
      debugPrint('Gagal mengambil existing reports: $e');
    }
  }

  void _handleTemaSelected(String? selectedTema) {
    if (selectedTema == null) return;

    setState(() {
      _selectedTema = selectedTema;

      Map<String, dynamic>? selectedTemaData = subTemaList.firstWhere(
        (tema) => tema['Tema'] == selectedTema,
        orElse: () => <String, dynamic>{},
      );

      if (selectedTemaData.isNotEmpty) {
        _selectedTemaId = selectedTemaData['id'];
        judulTemaController.text = selectedTemaData['Tema'] ?? '';

        List<dynamic> mingguData = selectedTemaData['minggu'] ?? [];

        for (var controller in deskripsiControllers) {
          controller.dispose();
        }
        deskripsiControllers.clear();
        weekTitles.clear();

        // Cek apakah ada existing report untuk tema ini
        Map<String, dynamic>? existingReport = existingReports.firstWhere(
          (report) => report['tema'] == selectedTema,
          orElse: () => <String, dynamic>{},
        );

        for (int i = 0; i < mingguData.length; i++) {
          var minggu = mingguData[i];
          weekTitles.add(minggu['Sub-Tema'] ?? 'Minggu ${i + 1}');
          TextEditingController descController = TextEditingController();

          // Jika ada existing report, isi dengan data yang sudah ada
          if (existingReport.isNotEmpty) {
            List<dynamic> weeks = existingReport['weeks'] ?? [];
            if (i < weeks.length) {
              descController.text = weeks[i]['deskripsi'] ?? '';
            }
          }

          deskripsiControllers.add(descController);
        }

        if (mingguData.isEmpty) {
          weekTitles.add('Minggu 1');
          TextEditingController descController = TextEditingController();

          // Jika ada existing report, isi dengan data yang sudah ada
          if (existingReport.isNotEmpty) {
            List<dynamic> weeks = existingReport['weeks'] ?? [];
            if (weeks.isNotEmpty) {
              descController.text = weeks[0]['deskripsi'] ?? '';
            }
          }

          deskripsiControllers.add(descController);
        }

        // Set mode edit dan data lainnya jika ada existing report
        if (existingReport.isNotEmpty) {
          isEditMode = true;
          currentReportId = existingReport['id'];
          pesanGuruController.text = existingReport['pesanGuru'] ?? '';

          if (existingReport['tanggal'] != null) {
            selectedDate = (existingReport['tanggal'] as Timestamp).toDate();
          }
        } else {
          // Reset jika tidak ada existing report
          isEditMode = false;
          currentReportId = null;
          pesanGuruController.clear();
          selectedDate = DateTime.now();
        }
      }
    });
  }

  Future<void> _fetchChildren() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('kelas')
              .doc(widget.classId)
              .collection('anak')
              .get();

      final sortedDocs =
          snapshot.docs.toList()..sort(
            (a, b) => (a['name'] as String).compareTo(b['name'] as String),
          );

      if (mounted) {
        setState(() {
          childrenNames =
              sortedDocs.map((doc) => doc['name'] as String).toList();
        });
      }
    } catch (e) {
      debugPrint('Gagal mengambil daftar anak: $e');
    }
  }

  String _monthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month - 1];
  }

  void _refreshAfterAddingTema() async {
    await _fetchTemas();
  }

  @override
  void dispose() {
    for (var controller in deskripsiControllers) {
      controller.dispose();
    }
    judulTemaController.dispose();
    pesanGuruController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown untuk pilih anak
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary30, width: 3),
              borderRadius: BorderRadius.circular(9999),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  spreadRadius: 0,
                  blurRadius: 2,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedLaporan,
                hint: const Text(
                  'Pilih nama anak',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: AppColors.black,
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
                items:
                    childrenNames.map((String name) {
                      return DropdownMenuItem<String>(
                        value: name,
                        child: Text(name),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLaporan = newValue;
                    // Reset form ketika ganti anak
                    _selectedTema = null;
                    _selectedTemaId = null;
                    isEditMode = false;
                    currentReportId = null;
                    judulTemaController.clear();
                    pesanGuruController.clear();
                    for (var controller in deskripsiControllers) {
                      controller.dispose();
                    }
                    deskripsiControllers.clear();
                    weekTitles.clear();
                  });
                  // Fetch existing reports untuk anak yang dipilih
                  _fetchExistingReports();
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Row untuk dropdown tema dan tombol tambah tema
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary30, width: 3),
                    borderRadius: BorderRadius.circular(9999),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedTema,
                      hint: const Text(
                        'Pilih Tema',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: AppColors.black,
                          fontSize: 14,
                        ),
                      ),
                      isExpanded: true,
                      iconSize: 24,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: AppColors.black,
                        fontSize: 14,
                      ),
                      items:
                          temaList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        _handleTemaSelected(newValue);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => GuruAddTema(classId: widget.classId),
                    ),
                  );
                  _refreshAfterAddingTema();
                },
                icon: const Icon(Icons.add, color: AppColors.neutral100),
                label: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: const Text("Tambah Tema"),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary50,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(50, 50),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Date picker section
          const Text(
            'Pilih Tanggal',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var item in [
                selectedDate.day.toString(),
                _monthName(selectedDate.month),
                selectedDate.year.toString(),
              ])
                GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(0xffC5E7F7),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400,
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Tema section
          Center(
            child: Text(
              isEditMode ? 'Edit Tema' : 'Tema',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: judulTemaController,
            textAlign: TextAlign.center,
            enabled: false,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.only(bottom: 4),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            style: const TextStyle(fontSize: 20, color: Colors.black),
          ),
          const SizedBox(height: 24),

          // Weekly blocks
          if (_selectedTema != null && weekTitles.isNotEmpty)
            Column(
              children: [
                // Mode indicator
                if (isEditMode)
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.warning50),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: AppColors.warning500),
                        const SizedBox(width: 5),
                        Text(
                          'Mode Edit - Update Laporan',
                          maxLines: 2,
                          style: TextStyle(
                            color: AppColors.warning500,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Weekly blocks
                ...List.generate(weekTitles.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary10,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Minggu ${index + 1} :',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary10,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    weekTitles[index],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary5,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(6),
                              bottomRight: Radius.circular(6),
                            ),
                          ),
                          child: TextField(
                            controller: deskripsiControllers[index],
                            maxLines: 6,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(10),
                              hintText: 'Masukkan deskripsi tema...',
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 40),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3C2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE17B),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6),
                          ),
                        ),
                        child: const Text(
                          textAlign: TextAlign.center,
                          'Pesan Guru',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextField(
                        controller: pesanGuruController,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(8),
                          hintText: 'Masukkan pesan guru...',
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),

                // Save button
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Find anakId
                      String? anakId;
                      final anakSnapshot =
                          await FirebaseFirestore.instance
                              .collection('kelas')
                              .doc(widget.classId)
                              .collection('anak')
                              .where('name', isEqualTo: _selectedLaporan)
                              .get();
                      if (anakSnapshot.docs.isNotEmpty) {
                        anakId = anakSnapshot.docs.first.id;
                      }

                      // Validation
                      bool isValid =
                          _selectedLaporan != null &&
                          _selectedTema != null &&
                          judulTemaController.text.trim().isNotEmpty &&
                          // pesanGuruController.text.trim().isNotEmpty &&
                          deskripsiControllers.any(
                            (c) => c.text.trim().isNotEmpty,
                          ) &&
                          anakId != null;

                      if (isValid) {
                        try {
                          Map<String, dynamic> reportData = {
                            'studentName': _selectedLaporan,
                            'tema': judulTemaController.text,
                            'pesanGuru': pesanGuruController.text,
                            'tanggal': selectedDate,
                            'weeks': List.generate(
                              deskripsiControllers.length,
                              (index) => {
                                'mingguKe': index + 1,
                                'judul': weekTitles[index],
                                'deskripsi': deskripsiControllers[index].text,
                              },
                            ),
                          };

                          if (isEditMode && currentReportId != null) {
                            // Update existing report
                            reportData['updatedAt'] =
                                FieldValue.serverTimestamp();
                            await FirebaseFirestore.instance
                                .collection('kelas')
                                .doc(widget.classId)
                                .collection('anak')
                                .doc(anakId)
                                .collection('laporanMingguan')
                                .doc(currentReportId)
                                .update(reportData);
                          } else {
                            // Create new report
                            reportData['createdAt'] =
                                FieldValue.serverTimestamp();
                            await FirebaseFirestore.instance
                                .collection('kelas')
                                .doc(widget.classId)
                                .collection('anak')
                                .doc(anakId)
                                .collection('laporanMingguan')
                                .doc(_selectedTemaId)
                                .set(reportData);
                          }

                          // Refresh existing reports
                          _fetchExistingReports();

                          if (!context.mounted) return;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  isEditMode ? "Berhasil Diupdate" : "Berhasil",
                                ),
                                content: Text(
                                  isEditMode
                                      ? "Laporan berhasil diupdate."
                                      : "Laporan berhasil disimpan.",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      // Reset form after save
                                      setState(() {
                                        if (!isEditMode) {
                                          // Reset hanya kalau bukan edit mode (simpan baru)
                                          pesanGuruController.clear();
                                          for (var controller
                                              in deskripsiControllers) {
                                            controller.clear();
                                          }
                                          _selectedTema = null;
                                          _selectedTemaId = null;
                                        }
                                        isEditMode = false;
                                        currentReportId = null;
                                      });
                                    },
                                    child: const Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Gagal menyimpan: ${e.toString()}"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        if (!context.mounted) return;
                        showErrorSnackBar(
                          context,
                          "Harap pilih tema dan isi semua kolom sebelum menyimpan.",
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
                      shadowColor: Colors.black.withAlpha(25),
                    ),
                    child: Text(
                      isEditMode ? 'Update' : 'Simpan',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),

          // Show message when no theme is selected
          if (_selectedTema == null)
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Silakan pilih tema terlebih dahulu untuk menampilkan minggu-minggu',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
