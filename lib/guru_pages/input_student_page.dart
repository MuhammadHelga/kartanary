import 'package:flutter/material.dart';
import '../theme/AppColors.dart';
import '/guru_pages/list_student_page.dart';

class InputStudentPage extends StatefulWidget {

  final Function(String) onAddChild; // Callback untuk mengirim data ke halaman sebelumnya

  InputStudentPage({required this.onAddChild});

  @override
  _InputStudentPageState createState() => _InputStudentPageState();
}

class _InputStudentPageState extends State<InputStudentPage> {
  String? _selectedGender;
  String _childName = '';
  List<String> _childrenNames = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary50,
        elevation: 0,
        title: Text(
          'Tambah Anak',
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
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Nama Anak',
                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _childName = value;
                        });
                      },
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "👨‍🎓",
                            style: TextStyle(fontSize: 30),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        hintText: 'Masukkan Nama Anak',
                        hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                        filled: true,
                        fillColor: Color(0xffF8FAFC),
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Color(0xff1D99D3), width: 3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Color(0xff1D99D3), width: 3),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Umur Anak',
                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    TextField(
    
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "🎂",
                            style: TextStyle(fontSize: 30),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        hintText: 'Masukkan Umur Anak',
                        hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                        filled: true,
                        fillColor: Color(0xffF8FAFC),
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Color(0xff1D99D3), width: 3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Color(0xff1D99D3), width: 3),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Jenis Kelamin Anak',
                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Laki-laki',
                              groupValue: _selectedGender,
                              activeColor: Color(0xff1D99D3),
                              visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                            ),
                            Text('Laki-laki', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        SizedBox(width: 50),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Perempuan',
                              groupValue: _selectedGender,
                              activeColor: Color(0xff1D99D3),
                              visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                            ),
                            Text('Perempuan', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Tombol di bawah
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_childName.isNotEmpty) {
                        setState(() {
                          _childrenNames.add(_childName);
                        });
                        widget.onAddChild(_childName);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Anak berhasil ditambahkan!')),
                        );

                        _childName = '';
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary50,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      'Tambahkan',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_childrenNames.isNotEmpty) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ListStudentPage(
                              childrenNames: _childrenNames,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Tambah anak dulu ya!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary5,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(color: AppColors.primary50, width: 2),
                      ),
                    ),
                    child: Text(
                      'Lihat Daftar Anak',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary50,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
