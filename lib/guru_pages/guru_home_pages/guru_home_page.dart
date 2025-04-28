import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lifesync_capstone_project/theme/AppColors.dart';

class GuruHomePage extends StatelessWidget {
  const GuruHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: AppColors.primary50, // Ganti warna sesuai kebutuhan
        elevation: 0,
        // title: Text(
        //   'My App Bar',
        //   style: TextStyle(
        //     fontSize: 20,
        //     fontWeight: FontWeight.w600,
        //     color: Colors.white,
        //   ),
        // ),
         automaticallyImplyLeading: false, 
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white, size: 30),
            onPressed: () {
              // Tindakan ketika notifikasi diklik
              print("Notifikasi diklik");
            },
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ), // Menambahkan radius di bagian bawah
        clipBehavior: Clip.hardEdge, 
        toolbarHeight: 70,
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
                    Column(
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
                          'Miss Nana!',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    //Slider
                    OutingClassSlider(),

                    //School Updates
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
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder:
                        //         (_) => UpdateDetailPage(
                        //           title: 'Kado Cinta Ramadhan',
                        //           description:
                        //               'Lorem ipsum dolor sit amet consectetur. Dolor interdum odio quam sed aliquam.',
                        //           imageUrl:
                        //               'assets/images/placeholder_updates.jpg', // Aksi saat card di klik
                        //         ),
                        //   ),
                        // );
                      },
                    ),
                    UpdateCard(
                      title: 'Cooking Class',
                      description:
                          'Lorem ipsum dolor sit amet consectetur. Dolor interdum odio quam sed aliquam.',
                      imageUrl: 'assets/images/placeholder_updates.jpg',
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder:
                        //         (_) => UpdateDetailPage(
                        //           title: 'Kado Cinta Ramadhan',
                        //           description:
                        //               'Lorem ipsum dolor sit amet consectetur. Dolor interdum odio quam sed aliquam.',
                        //           imageUrl:
                        //               'assets/images/placeholder_updates.jpg', // Aksi saat card di klik
                        //         ),
                        //   ),
                        // );
                      },
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

class OutingClassSlider extends StatefulWidget {
  @override
  State<OutingClassSlider> createState() => _OutingClassSliderState();
}

class _OutingClassSliderState extends State<OutingClassSlider> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider(
          items:
              outingClasses.map((outingClass) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // Radius pada card
                  ),
                  elevation: 4, // Menambahkan bayangan pada card
                  child: Column(
                    children: [
                      // Stack untuk menempatkan gambar di bawah dan teks di atas
                      Stack(
                        children: [
                          // Gambar
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                              bottom: Radius.circular(16),
                            ), // Radius pada gambar
                            child: Container(
                              height:
                                  212, // Menyesuaikan tinggi card dengan gambar
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                  bottom: Radius.circular(16),
                                ),
                                boxShadow: [
                                  BoxShadow(color: Colors.black),
                                  BoxShadow(
                                    color: Colors.white70,
                                    blurRadius: 20.0,
                                    spreadRadius: -7.0,
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                outingClass['image']!,
                                fit: BoxFit.cover,
                                height: 212,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8, // Jarak teks dari bawah
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
                _currentIndex = index; // Update index saat halaman berubah
              });
            },
          ),
        ),
        // Indikator titik untuk carousel
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              outingClasses.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () {
                    // Menggunakan setState untuk perubahan halaman
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