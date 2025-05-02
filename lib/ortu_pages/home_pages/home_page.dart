import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _name;

  @override
  void initState() {
    super.initState();
    _loadUserName();
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: AppBar(
            backgroundColor: Color(0xff1D99D3),
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(Icons.notifications, color: Colors.white, size: 38),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
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
                    _name != null
                        ? Row(
                          children: [
                            Text(
                              'Mom $_name !',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.favorite, color: Colors.red, size: 24),
                          ],
                        )
                        : Text(
                          'Loading...',
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
                      'School Updates',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),

                    UpdateCard(
                      title: 'Kado Cinta Ramadhan',
                      description:
                          'Lorem ipsum dolor sit amet consectetur. Dolor interdum odio quam sed aliquam.',
                      imageUrl: 'assets/images/placeholder_updates.jpg',
                      onTap: (
                      ) {
                      },
                    ),
                    UpdateCard(
                      title: 'Cooking Class',
                      description:
                          'Lorem ipsum dolor sit amet consectetur. Dolor interdum odio quam sed aliquam.',
                      imageUrl: 'assets/images/placeholder_updates.jpg',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
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
                    height: 30.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
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
  final String imageUrl;
  final VoidCallback onTap;

  UpdateCard({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFC5E7F7),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          leading: Image.asset(
            imageUrl,
            fit: BoxFit.cover,
            width: 60,
            height: 60,
          ),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(description),
        ),
      ),
    );
  }
}
