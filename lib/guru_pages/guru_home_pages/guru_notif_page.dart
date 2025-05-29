import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifesync_capstone_project/theme/app_colors.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'guru_detail_notif_page.dart'; // pastikan path ini sesuai

class GuruNotificationPage extends StatefulWidget {
  final String classId;
  const GuruNotificationPage({super.key, required this.classId});

  @override
  State<GuruNotificationPage> createState() => _GuruNotificationPageState();
}

class _GuruNotificationPageState extends State<GuruNotificationPage> {
  List<Map<String, dynamic>> _notification = [];

  Future<void> _fetchNotification() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('kelas')
              .doc(widget.classId)
              .collection('pengumuman')
              .orderBy('tanggal', descending: true)
              .get();

      final List<Map<String, dynamic>> loadednotification =
          snapshot.docs.map((doc) {
            final data = doc.data();
            final rawTanggal = data['tanggal'];
            Timestamp safeTimestamp;

            if (rawTanggal is Timestamp) {
              safeTimestamp = rawTanggal;
            } else if (rawTanggal is String) {
              final parsedDate = DateTime.tryParse(rawTanggal);
              safeTimestamp =
                  parsedDate != null
                      ? Timestamp.fromDate(parsedDate)
                      : Timestamp.fromDate(DateTime.now());
            } else {
              safeTimestamp = Timestamp.fromDate(DateTime.now());
            }

            return {
              'title': data['title'] ?? '',
              'description': data['deskripsi'] ?? '',
              'tanggal': safeTimestamp,
              'lokasi': data['lokasi'] ?? '-',
              'imageUrl':
                  (data['imageUrls'] as List<dynamic>).isNotEmpty
                      ? (data['imageUrls'] as List<dynamic>)[0] as String
                      : 'assets/images/placeholder_updates.png',
            };
          }).toList();

      setState(() {
        _notification = loadednotification;
      });
    } catch (error) {
      debugPrint('Error fetching notification: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('id', timeago.IdMessages());
    _fetchNotification();
  }

  String _formatTimeAgo(DateTime dateTime) {
    return timeago.format(dateTime, locale: 'id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FBFF),
      appBar: AppBar(
        backgroundColor: AppColors.primary50,
        elevation: 0,
        title: Text(
          'Notifikasi',
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
      body:
          _notification.isEmpty
              ? Center(
                child: Text(
                  'Belum ada notifikasi',
                  style: TextStyle(color: AppColors.neutral400),
                ),
              )
              : ListView.builder(
                itemCount: _notification.length,
                itemBuilder: (context, index) {
                  final announcement = _notification[index];
                  final timestamp = announcement['tanggal'] as Timestamp;
                  final dateTime = timestamp.toDate();

                  return Container(
                    color: const Color(0xFFF4FBFF),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFF3CD),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.notifications,
                          color: Color(0xFFFFC107),
                        ),
                      ),
                      title: Text(
                        announcement['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            announcement['description'],
                            style: const TextStyle(fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatTimeAgo(dateTime),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => GuruDetailNotifPage(
                                  title: announcement['title'],
                                  tanggal: timestamp,
                                  lokasi: announcement['lokasi'],
                                  description: announcement['description'],
                                  imageUrl: announcement['imageUrl'],
                                ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
