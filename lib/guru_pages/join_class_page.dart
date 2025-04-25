import 'package:flutter/material.dart';
import '/theme/AppTypography.dart';
import '/theme/AppColors.dart';

class JoinClassPage extends StatefulWidget {
  @override
  _JoinClassPageState createState() => _JoinClassPageState();
}

class _JoinClassPageState extends State<JoinClassPage> {
  final TextEditingController _kodeKelasController = TextEditingController();

  void _bergabung() {
    String kodeKelas = _kodeKelasController.text;
    // Logika untuk bergabung bisa ditambahkan di sini
    print('Bergabung dengan kode kelas: $kodeKelas');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.primary5,
      appBar: AppBar(
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo_paud.png', height: 150), // Pastikan logo tersedia di direktori 'assets'
            // SizedBox(height: 20),
            Text(
              'Bergabung ke Kelas',
              style: AppTypography.SmallRegular
            ),
            SizedBox(height: 10),
            TextField(
              controller: _kodeKelasController,
              decoration: InputDecoration(
                hintText: 'Masukkan kode kelas',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              maxLength: 8,
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            Text(
              'Untuk masuk dengan kode kelas',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              '• Gunakan akun yang telah terdaftar',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              '• Gunakan kode kelas dengan 6-8 huruf atau angka, tanpa spasi atau simbol',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _bergabung,
              child: Text('Bergabung'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
