import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../theme/AppColors.dart';
import 'package:intl/date_symbol_data_local.dart';

class DetailNotifPage extends StatefulWidget {
  final String title;
  final Timestamp tanggal;
  final String lokasi;
  final String description;
  final String imageUrl;

  const DetailNotifPage({
    Key? key,
    required this.title,
    required this.tanggal,
    required this.lokasi,
    required this.description,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<DetailNotifPage> createState() => _DetailNotifPageState();
}

class _DetailNotifPageState extends State<DetailNotifPage> {
  String? formattedDate;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id', null).then((_) {
      final format = DateFormat('dd MMMM yyyy', 'id');
      setState(() {
        formattedDate = format.format(widget.tanggal.toDate());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body:
          formattedDate == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(30),
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
                                widget.imageUrl.startsWith('http')
                                    ? Image.network(
                                      widget.imageUrl,
                                      width: double.infinity,
                                      fit: BoxFit.fitWidth,
                                    )
                                    : Image.asset(
                                      widget.imageUrl,
                                      width: double.infinity,
                                      fit: BoxFit.fitWidth,
                                    ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            widget.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildInfoRow('Tanggal', formattedDate!),
                    const SizedBox(height: 8),
                    _buildInfoRow('Lokasi', widget.lokasi),
                    const SizedBox(height: 10),
                    const Text(
                      'Deskripsi :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.description,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(height: 1.5),
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
        Text('$label : ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value)),
      ],
    );
  }
}
