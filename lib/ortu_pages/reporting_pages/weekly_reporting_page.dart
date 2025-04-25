import 'package:flutter/material.dart';
import 'reporting_page.dart';

class WeeksReportingPage extends StatelessWidget {
  const WeeksReportingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
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
                        Navigator.pop(context);
                      },
                      tooltip: 'Back',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: const Text(
                      'Laporan Mingguan',
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
          ],
        ),
      ),
    );
  }
}
