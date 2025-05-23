import 'package:flutter/material.dart';
import 'package:lifesync_capstone_project/guru_pages/guru_create_activity_pages/weekly/guru_add_tema.dart';
import 'package:lifesync_capstone_project/theme/AppColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddWeeklyPage extends StatefulWidget {
  final String classId;
  const AddWeeklyPage({Key? key, required this.classId}) : super(key: key);

  @override
  State<AddWeeklyPage> createState() => _AddWeeklyPageState();
}

class _AddWeeklyPageState extends State<AddWeeklyPage> {
  List<TextEditingController> deskripsiControllers = [];
  List<String> childrenNames = [];
  List<String> temaList = [];
  List<Map<String, dynamic>> subTemaList = [];
  List<Map<String, dynamic>> childrenData = [];
  List<String> weekTitles = []; // Store week titles from Firebase

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

          // Store complete tema data with document ID
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
      print('Gagal mengambil daftar tema: $e');
    }
  }

  void _handleTemaSelected(String? selectedTema) {
    if (selectedTema == null) return;

    setState(() {
      _selectedTema = selectedTema;

      // Find the matching tema in our details list
      Map<String, dynamic>? selectedTemaData = subTemaList.firstWhere(
        (tema) => tema['Tema'] == selectedTema,
        orElse: () => <String, dynamic>{},
      );

      if (selectedTemaData.isNotEmpty) {
        _selectedTemaId = selectedTemaData['id'];

        // Set the tema title (read-only)
        judulTemaController.text = selectedTemaData['Tema'] ?? '';

        // Get minggu data
        List<dynamic> mingguData = selectedTemaData['minggu'] ?? [];

        // Clear existing controllers
        for (var controller in deskripsiControllers) {
          controller.dispose();
        }
        deskripsiControllers.clear();
        weekTitles.clear();

        // Create new controllers for each minggu based on Firebase data
        for (int i = 0; i < mingguData.length; i++) {
          var minggu = mingguData[i];

          // Store week titles from Firebase (read-only)
          weekTitles.add(minggu['Sub-Tema'] ?? 'Minggu ${i + 1}');

          // Create controller for description (editable)
          TextEditingController descController = TextEditingController();
          deskripsiControllers.add(descController);
        }

        // If no minggu data was found, add at least one empty block
        if (mingguData.isEmpty) {
          weekTitles.add('Minggu 1');
          deskripsiControllers.add(TextEditingController());
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

      print('Jumlah anak yang diambil: ${snapshot.docs.length}');

      // Urutkan dulu dokumen berdasarkan field 'name'
      final sortedDocs =
          snapshot.docs.toList()..sort(
            (a, b) => (a['name'] as String).compareTo(b['name'] as String),
          );

      // Lalu set state jika widget masih aktif
      if (mounted) {
        setState(() {
          childrenNames =
              sortedDocs.map((doc) => doc['name'] as String).toList();
        });
      }

      print('Daftar anak (terurut): $childrenNames');
    } catch (e) {
      print('Gagal mengambil daftar anak: $e');
    }
  }

  // String? _getAnakId(String? selectedName) {
  //   if (selectedName == null) return null;

  //   try {
  //     Map<String, dynamic> child = childrenData.firstWhere(
  //       (child) => child['name'] == selectedName,
  //     );
  //     return child['id'];
  //   } catch (e) {
  //     print('Anak tidak ditemukan: $e');
  //     return null;
  //   }
  // }

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

  // Function to handle refresh after adding a new tema
  void _refreshAfterAddingTema() async {
    await _fetchTemas();
  }

  @override
  void dispose() {
    // Dispose all controllers
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
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 16),
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
                  // Navigate to the GuruAddTema page and wait for it to return
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => GuruAddTema(classId: widget.classId),
                    ),
                  );
                  // Refresh temas after returning
                  _refreshAfterAddingTema();
                },
                icon: const Icon(Icons.add),
                label: const Text("Tambah Tema"),
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

          SizedBox(height: 20),
          const Text(
            'Pilih Tanggal',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
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
          Center(
            child: Text(
              'Tema',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
          ),
          const SizedBox(height: 10),

          // Read-only tema title
          TextField(
            controller: judulTemaController,
            textAlign: TextAlign.center,
            enabled: false, // Make it read-only
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.only(bottom: 4),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            style: const TextStyle(fontSize: 20, color: Colors.black),
          ),
          SizedBox(height: 24),

          // Weekly blocks based on Firebase data
          if (_selectedTema != null && weekTitles.isNotEmpty)
            Column(
              children: [
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
                            borderRadius: BorderRadius.only(
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
                                    weekTitles[index], // Read-only week title from Firebase
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
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(6),
                              bottomRight: Radius.circular(6),
                            ),
                          ),
                          child: TextField(
                            controller: deskripsiControllers[index],
                            maxLines: 6,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10),
                              hintText: 'Masukkan deskripsi tema...',
                            ),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                SizedBox(height: 20),

                // Message block
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

                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Find anakId (document ID) based on selected name
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
                          pesanGuruController.text.trim().isNotEmpty &&
                          deskripsiControllers.every(
                            (c) => c.text.trim().isNotEmpty,
                          ) &&
                          anakId != null;

                      if (isValid) {
                        try {
                          // Create weekly report in Firestore
                          await FirebaseFirestore.instance
                              .collection('kelas')
                              .doc(widget.classId)
                              .collection('anak')
                              .doc(anakId)
                              .collection('laporanMingguan')
                              .doc(_selectedTemaId)
                              .set({
                                'studentName': _selectedLaporan,
                                'tema': judulTemaController.text,
                                'pesanGuru': pesanGuruController.text,
                                'tanggal': selectedDate,
                                'weeks': List.generate(
                                  deskripsiControllers.length,
                                  (index) => {
                                    'mingguKe': index + 1,
                                    'judul':
                                        weekTitles[index], // Use Firebase data
                                    'deskripsi':
                                        deskripsiControllers[index].text,
                                  },
                                ),
                                'createdAt': FieldValue.serverTimestamp(),
                              });

                          // Show success dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Berhasil"),
                                content: const Text(
                                  "Laporan berhasil disimpan.",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(
                                        context,
                                      ).pop(); // Close dialog
                                      // Navigator.of(context).pop(); // Go back
                                    },
                                    child: const Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Gagal menyimpan: ${e.toString()}"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        // Show error if fields are empty
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Harap pilih tema dan isi semua kolom sebelum menyimpan.",
                            ),
                            backgroundColor: Colors.red,
                          ),
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
                SizedBox(height: 20),
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
