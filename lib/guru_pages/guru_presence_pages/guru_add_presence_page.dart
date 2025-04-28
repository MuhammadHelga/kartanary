import 'package:flutter/material.dart';
import '../../theme/AppColors.dart';
import '../../widgets/bottom_navbar.dart';

class GuruPresencePage extends StatefulWidget {
  const GuruPresencePage({super.key});

  @override
  State<GuruPresencePage> createState() => _GuruPresencePageState();
}

class _GuruPresencePageState extends State<GuruPresencePage> {
  DateTime selectedDate = DateTime.now();

    // Tambahkan daftar nama anak
  final List<String> childrenNames = [
    'Ahmad',
    'Budi',
    'Citra',
    'Dina',
    'Eko',
  ];

  final List<String> presenceStatus = [
    'Hadir',
    'Sakit',
    'Izin',
    'Alpha',
  ];

  String getInitial(String presence) {
    return presence.isNotEmpty ? presence[0].toUpperCase() : '';
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
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: AppColors.primary50,
        elevation: 0,
        title: Text(
          'Presensi',
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Tanggal',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                            width: 115,
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
                  SizedBox(height: 20),
                  Text(
                    'Total Kehadiran',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 170,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(0xffA8EE87),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                              ),
                            ),
                            child: Text(
                              'Hadir',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Container(
                            width: 170,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(0xffF8D96D),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child: Text('Izin', style: TextStyle(fontSize: 20)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 170,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Color(0xffA8EE87),
                              ),
                            ),
                            child: Text('1', style: TextStyle(fontSize: 20)),
                          ),
                          Container(
                            width: 170,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Color(0xffF8D96D),
                              ),
                            ),
                            child: Text('1', style: TextStyle(fontSize: 20)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 170,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Color(0xffFFA470)),
                            child: Text(
                              'Sakit',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Container(
                            width: 170,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Color(0xffFF6666)),
                            child: Text(
                              'Alpha',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 170,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Color(0xffFFA470),
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                              ),
                            ),
                            child: Text('1', style: TextStyle(fontSize: 20)),
                          ),
                          Container(
                            width: 170,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Color(0xffFF6666),
                              ),
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            child: Text('1', style: TextStyle(fontSize: 20)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  const Text(
                    'Nama Anak',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: childrenNames.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final name = childrenNames[index];
                  final presence = presenceStatus[index % presenceStatus.length];
                  final initial_presence = getInitial(presence);

                  Color presenceColor;
                  switch (presence) {
                    case 'Hadir':
                      presenceColor = Color(0xffA8EE87); // Hijau
                      break;
                    case 'Izin':
                      presenceColor = Color(0xffF8D96D); // Kuning
                      break;
                    case 'Sakit':
                      presenceColor = Color(0xffFFA470); // Orange
                      break;
                    case 'Alpha':
                      presenceColor = Color(0xffFF6666); // Merah
                      break;
                    default:
                      presenceColor = AppColors.secondary50;
                  }
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: presenceColor,
                          radius: 28,
                          child: Text(
                            initial_presence,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}


