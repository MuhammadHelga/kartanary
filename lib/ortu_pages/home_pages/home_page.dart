import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:lifesync_capstone_project/firebase_options.dart';
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
                return !tanggalTanpaWaktu.isBefore(
                  today,
                ); // hari ini atau masa depan
              })
              .toList();
      // Sort by date ascending (paling dekat ke atas)
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

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _fetchAnnouncements();
    // notificationService.requestNotificationPermission();
    // notificationService.getDeviceToken();
    // notificationService.firebaseInit(context);
    // notificationService.setupInteractMessage(context);
    // FcmService.firebaseInit();
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

  int _currentIndex = 0;
  final CarouselController _controller = CarouselController();

  final List<Map<String, String>> outingClasses = [
    {
      'image': 'assets/images/placeholder_slider.jpg',
      'title': 'Outing Class "Balai Pengkajian Teknologi Pertanian (BPTP)"',
    },
    {
      'image': 'assets/images/placeholder_slider.jpg',
      'title': 'Outing Class "Balai Pengkajian Teknologi Pertanian (BPTP)"',
    },
    {
      'image': 'assets/images/placeholder_slider.jpg',
      'title': 'Outing Class "Balai Pengkajian Teknologi Pertanian (BPTP)"',
    },
  ];

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
                _name != null ? 'Miss $_name' : 'Loading...',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),

              // Slider
              _buildOutingClassSlider(),

              // School Updates
              Text(
                'Update Kegiatan Sekolah',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              ..._announcements.map((announcement) {
                return UpdateCard(
                  tanggal: announcement['tanggal'],
                  lokasi: announcement['lokasi'],
                  title: announcement['title'],
                  description: announcement['description'],
                  imageUrl: announcement['imageUrl'],
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutingClassSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider(
          items:
              outingClasses.map((outingClass) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          outingClass['image']!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 212,
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 16,
                        right: 16,
                        child: Text(
                          outingClass['title']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 4,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
          options: CarouselOptions(
            height: 220,
            viewportFraction: 0.8,
            enableInfiniteScroll: true,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              outingClasses.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = entry.key;
                    });
                  },
                  child: Container(
                    width: 10.0,
                    height: 10.0,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4.0,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          _currentIndex == entry.key
                              ? Colors.blueAccent
                              : Colors.grey.shade300,
                    ),
                  ),
                );
              }).toList(),
        ),
        SizedBox(height: 16),
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

  UpdateCard({
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
