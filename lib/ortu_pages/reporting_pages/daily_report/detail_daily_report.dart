import 'package:flutter/material.dart';
import '../../../theme/AppColors.dart';

class DetailDailyReport extends StatelessWidget {
  const DetailDailyReport({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffF2F9FD),
      appBar: AppBar(
        backgroundColor: AppColors.primary50,
        elevation: 0,
        title: Text(
          'Laporan Harian',
          style: TextStyle(
            fontSize: 26,
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
              size: 26,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        toolbarHeight: 70,
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/laporan_img.png',
            height: screenHeight * 0.4,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(
                top: 100,
                right: 30,
                left: 30,
                bottom: 50,
              ),
              height: screenHeight * 0.8,
              width: double.infinity,
              margin: EdgeInsets.only(top: 300),
              decoration: BoxDecoration(
                color: AppColors.neutral50,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: SingleChildScrollView(
                child: Text(
                  'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. '
                  'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. '
                  'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. '
                  'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. '
                  'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. '
                  'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. '
                  'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. '
                  'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. '
                  'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. '
                  'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. '
                  'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. '
                  'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. '
                  'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. '
                  'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. ',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                width: double.infinity,
                margin: EdgeInsets.only(top: screenHeight * 0.28),
                decoration: BoxDecoration(
                  color: AppColors.secondary300,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'KB - A1 Belajar Menggambar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Jumat, 2 Mei 2025',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Positioned(
          //   top: screenHeight * 0.35,
          //   left: 0,
          //   right: 0,
          //   bottom: 0,
          //   child: SingleChildScrollView(
          //     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          //     child: Column(
          //       children: [
          //         Text(
          //           'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. '
          //           'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. '
          //           'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. '
          //           'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. '
          //           'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. '
          //           'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. '
          //           'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. '
          //           'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. '
          //           'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. '
          //           'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. '
          //           'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. '
          //           'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. '
          //           'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. '
          //           'Ananda mulai menunjukkan pemahaman mengenai identitas dirinya. ',
          //           style: TextStyle(fontSize: 16),
          //           textAlign: TextAlign.justify,
          //         ),
          //         SizedBox(height: 20),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
