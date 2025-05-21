import 'package:flutter/material.dart';
import '../../theme/AppColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddWeeklyPage extends StatefulWidget {
  final String classId;
  const AddWeeklyPage({Key? key, required this.classId}) : super(key: key);

  @override
  State<AddWeeklyPage> createState() => _AddWeeklyPageState();
}

class _AddWeeklyPageState extends State<AddWeeklyPage> {
  List<String> childrenNames = [];
  String? _selectedLaporan;
  DateTime selectedDate = DateTime.now();

  final TextEditingController judulTemaController = TextEditingController();
  final TextEditingController pesanGuruController = TextEditingController();

  List<Map<String, TextEditingController>> weeklyThemes = [];
  List<TextEditingController> judulMingguControllers = [];
  List<TextEditingController> deskripsiControllers = [];

  @override
  void initState() {
    super.initState();
    _addWeeklyBlock();
    _fetchChildren();
  }

  Future<void> _fetchChildren() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('kelas')
              .doc(widget.classId)
              .collection('anak')
              .get();

      print('Jumlah anak yang diambil: ${snapshot.docs.length}'); // Debugging

      setState(() {
        childrenNames =
            snapshot.docs.map((doc) => doc['name'] as String).toList();
      });

      print('Daftar anak: $childrenNames');
    } catch (e) {
      print('Gagal mengambil daftar anak: $e');
    }
  }

  void _addWeeklyBlock() {
    setState(() {
      judulMingguControllers.add(TextEditingController());
      deskripsiControllers.add(TextEditingController());
    });
  }

  Future<void> _simpanLaporan() async {
    bool isValid =
        _selectedLaporan != null &&
        judulTemaController.text.trim().isNotEmpty &&
        pesanGuruController.text.trim().isNotEmpty &&
        deskripsiControllers.every((c) => c.text.trim().isNotEmpty) &&
        judulMingguControllers.every((c) => c.text.trim().isNotEmpty);

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Harap isi semua kolom sebelum menyimpan."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Buat data minggu
      List<Map<String, String>> mingguData = [];
      for (int i = 0; i < deskripsiControllers.length; i++) {
        mingguData.add({
          'judul': judulMingguControllers[i].text.trim(),
          'deskripsi': deskripsiControllers[i].text.trim(),
        });
      }

      // Simpan laporan mingguan ke Firestore
      DocumentReference temaRef = FirebaseFirestore.instance
          .collection('laporan_mingguan')
          .doc(_selectedLaporan); // Menggunakan tema yang dipilih

      // Simpan data minggu ke sub-koleksi
      for (var minggu in mingguData) {
        await temaRef.collection('minggu').add(minggu);
      }

      // Simpan informasi tema
      await temaRef.set({
        'nama': _selectedLaporan,
        'kelasId': widget.classId,
        'tema': judulTemaController.text.trim(),
        'tanggal': selectedDate,
        'pesanGuru': pesanGuruController.text.trim(),
      }, SetOptions(merge: true)); // Menggunakan merge untuk memperbarui data

      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text("Berhasil"),
              content: Text("Laporan berhasil disimpan."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 0),
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
          TextField(
            controller: judulTemaController,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.only(bottom: 4),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            style: const TextStyle(fontSize: 20),
          ),
          SizedBox(height: 24),
          Column(
            children: [
              ...List.generate(deskripsiControllers.length, (index) {
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
                              child: TextField(
                                controller: judulMingguControllers[index],
                                decoration: const InputDecoration(
                                  hintText: 'Judul Minggu...',
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 5,
                                  ),
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(
                          color:
                              AppColors.primary5, // Warna background deskripsi
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
              // Tombol tambah minggu
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: FloatingActionButton(
                    onPressed: _addWeeklyBlock,
                    child: const Icon(Icons.add, color: Colors.white),
                    backgroundColor: Color(0xFF1D99D3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Blok Pesan Guru
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 40, left: 10, right: 10),
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
                  onPressed: () {
                    // Validasi semua TextField
                    bool isValid =
                        _selectedLaporan != null &&
                        judulTemaController.text.trim().isNotEmpty &&
                        pesanGuruController.text.trim().isNotEmpty &&
                        deskripsiControllers.every(
                          (c) => c.text.trim().isNotEmpty,
                        ) &&
                        judulMingguControllers.every(
                          (c) => c.text.trim().isNotEmpty,
                        );

                    if (isValid) {
                      _simpanLaporan();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Berhasil"),
                            content: const Text("Laporan berhasil disimpan."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
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
                          content: Text(
                            "Harap isi semua kolom sebelum menyimpan.",
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
            ],
          ),
        ],
      ),
    );
  }
}
