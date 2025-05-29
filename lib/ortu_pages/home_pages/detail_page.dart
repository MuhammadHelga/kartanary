import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';

class DetailPage extends StatelessWidget {
  final String title;
  final Timestamp tanggal;
  final String lokasi;
  final String description;
  final String imageUrl;

  const DetailPage({
    super.key,
    required this.title,
    required this.tanggal,
    required this.lokasi,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMMM yyyy').format(tanggal.toDate());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary50,
        elevation: 0,
        title: Text(
          'Update Kegiatan',
          style: TextStyle(
            fontSize: 22,
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
            child: Icon(Icons.chevron_left, color: AppColors.primary50),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        toolbarHeight: 70,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 399 / 300,
                    child:
                        imageUrl.startsWith('http')
                            ? Image.network(
                              imageUrl,
                              width: double.infinity,
                              // height: 200,
                              fit: BoxFit.fitWidth,
                            )
                            : Image.asset(
                              imageUrl,
                              width: double.infinity,
                              // height: 200,
                              fit: BoxFit.fitWidth,
                            ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withAlpha(7),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: EdgeInsets.all(12),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildInfoRow('Tanggal', formattedDate),
            SizedBox(height: 8),
            _buildInfoRow('Lokasi', lokasi),
            SizedBox(height: 10),
            Text('Deskripsi :', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text(
              description,
              textAlign: TextAlign.justify,
              style: TextStyle(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label : ', style: TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value)),
      ],
    );
  }
}
