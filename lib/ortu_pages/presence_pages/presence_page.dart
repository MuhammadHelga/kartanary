import 'package:flutter/material.dart';
import '../../widgets/bottom_navbar.dart';

class PresencePage extends StatefulWidget {
  const PresencePage({super.key});

  @override
  State<PresencePage> createState() => _PresencePageState();
}

class _PresencePageState extends State<PresencePage> {
  DateTime selectedDate = DateTime.now();

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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(color: Color(0xff1D99D3)),
              child: Row(
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
                            builder: (context) => BottomNavbar(),
                          ),
                        );
                      },
                      tooltip: 'Back',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Presensi',
                      style: TextStyle(
                        color: Color(0xffF2F9FD),
                        fontWeight: FontWeight.w600,
                        fontSize: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // PILIH TANGGAL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
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
                            width: 120,
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
                            width: 184,
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
                            width: 184,
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
                            width: 184,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Color(0xffA8EE87),
                              ),
                            ),
                            child: Text('data'),
                          ),
                          Container(
                            width: 184,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Color(0xffF8D96D),
                              ),
                            ),
                            child: Text('data'),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 184,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Color(0xffFFA470)),
                            child: Text(
                              'Sakit',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Container(
                            width: 184,
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
                            width: 184,
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
                            child: Text(
                              'Hadir',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Container(
                            width: 184,
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
                            child: Text('Izin', style: TextStyle(fontSize: 20)),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
