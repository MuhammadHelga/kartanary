import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lifesync_capstone_project/ortu_pages/home_pages/detail_page.dart';
import 'package:lifesync_capstone_project/theme/AppColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  final String classId;
  const HomePage({super.key, required this.classId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _name;
  List<Map<String, dynamic>> _announcements = [];

  Future<void> _fetchAnnouncements() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('kelas')
              .doc(widget.classId)
              .collection('pengumuman')
              .orderBy('tanggal', descending: false)
              .get();

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final List<Map<String, dynamic>> loadedAnnouncements =
          snapshot.docs
              .map((doc) {
                final data = doc.data();
                final Timestamp tanggal =
                    data['tanggal'] is Timestamp
                        ? data['tanggal']
                        : Timestamp.fromDate(DateTime.parse(data['tanggal']));
                return {
                  'title': data['title'],
                  'tanggal':
                      data['tanggal'] is Timestamp
                          ? data['tanggal'] as Timestamp
                          : Timestamp.fromDate(DateTime.parse(data['tanggal'])),
                  'lokasi': data['lokasi'],
                  'description': data['deskripsi'],
                  'imageUrl':
                      (data['imageUrls'] as List<dynamic>).isNotEmpty
                          ? (data['imageUrls'] as List<dynamic>)[0] as String
                          : 'assets/images/placeholder_updates.png',
                };
              })
              .where((announcement) {
                final tgl = (announcement['tanggal'] as Timestamp).toDate();
                final tanggalTanpaWaktu = DateTime(
                  tgl.year,
                  tgl.month,
                  tgl.day,
                );
                return !tanggalTanpaWaktu.isBefore(today);
              })
              .toList();

      loadedAnnouncements.sort((a, b) {
        final dateA = (a['tanggal'] as Timestamp).toDate();
        final dateB = (b['tanggal'] as Timestamp).toDate();
        return dateA.compareTo(dateB);
      });

      if (!mounted) return;
      setState(() {
        _announcements = loadedAnnouncements;
      });
    } catch (error) {
      print('Error fetching announcements: $error');
    }
  }

  List<Map<String, dynamic>> _latestReports = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.8);
  Timer? _autoSlideTimer;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _fetchAnnouncements();
    _fetchLatestReports();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoSlide();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoSlideTimer?.cancel();
    super.dispose();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentIndex < _latestReports.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _loadUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      if (doc.exists) {
        if (!mounted) return;
        setState(() {
          _name = doc['name'];
        });
      }
    }
  }

  Future<void> _fetchLatestReports() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collectionGroup('laporan')
              .where('classId', isEqualTo: widget.classId)
              .orderBy('tanggal', descending: true)
              .limit(3)
              .get();

      print("Jumlah laporan ditemukan: ${querySnapshot.docs.length}");
      for (var doc in querySnapshot.docs) {
        print(
          "Judul: ${doc['title']}, Tanggal: ${doc['tanggal']}, Deskripsi: ${doc['deskripsi']}",
        );
      }

      final reports =
          querySnapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'title': data['title'] ?? 'Tanpa Judul',
              'description': data['deskripsi'] ?? '',
              'imageUrl':
                  (data['imageUrls'] is List && data['imageUrls'].isNotEmpty)
                      ? data['imageUrls'][0]
                      : null,
              'date':
                  (data['tanggal'] != null && data['tanggal'] is Timestamp)
                      ? data['tanggal'].toDate()
                      : null,
            };
          }).toList();

      if (mounted) {
        setState(() {
          _latestReports = reports;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching reports: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: AppColors.primary50,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white, size: 38),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder:
              //         (context) =>
              //              NotificationPage(classId: widget.classId),
              //   ),
              // );
            },
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        clipBehavior: Clip.hardEdge,
        toolbarHeight: 70,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hai,',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _name != null ? 'Mom $_name !' : 'Loading...',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              _buildLatestReportsSlider(),
              Text(
                'Update Kegiatan Sekolah',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              _announcements.isEmpty
                  ? Text(
                    'Belum ada update kegiatan sekolah.',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      color: Colors.grey,
                    ),
                  )
                  : Column(
                    children:
                        _announcements.map((announcement) {
                          return UpdateCard(
                            tanggal: announcement['tanggal'],
                            lokasi: announcement['lokasi'],
                            title: announcement['title'],
                            description: announcement['description'],
                            imageUrl: announcement['imageUrl'],
                          );
                        }).toList(),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLatestReportsSlider() {
    if (_isLoading) return Center(child: CircularProgressIndicator());
    if (_latestReports.isEmpty) return Text('Tidak ada laporan terbaru');

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemCount: _latestReports.length,
            itemBuilder: (context, index) {
              final report = _latestReports[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child:
                            report['imageUrl'] != null
                                ? Image.network(
                                  report['imageUrl'],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 212,
                                )
                                : Container(
                                  height: 212,
                                  color: Colors.grey,
                                  child: Icon(Icons.image, size: 50),
                                ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              report['title'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            if (report['date'] != null)
                              Text(
                                DateFormat(
                                  'dd MMM yyyy',
                                ).format(report['date']),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_latestReports.length, (index) {
            return GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  index,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                width: 10,
                height: 10,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentIndex == index
                          ? Colors.blueAccent
                          : Colors.grey.shade300,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class UpdateCard extends StatelessWidget {
  final String title;
  final String description;
  final Timestamp tanggal;
  final String lokasi;
  final String imageUrl;

  const UpdateCard({
    required this.title,
    required this.lokasi,
    required this.tanggal,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFC5E7F7),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => DetailPage(
                    title: title,
                    description: description,
                    lokasi: lokasi,
                    tanggal: tanggal,
                    imageUrl: imageUrl,
                  ),
            ),
          );
        },
        child: ListTile(
          leading:
              imageUrl.startsWith('http')
                  ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                  )
                  : Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                  ),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat('dd MMMM yyyy').format(tanggal.toDate())),
              Text(description, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
