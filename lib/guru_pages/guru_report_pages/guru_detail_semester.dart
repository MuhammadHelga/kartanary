import 'package:flutter/material.dart';
import '../../theme/AppColors.dart';

class DetailSemesterReportPage extends StatefulWidget {
  const DetailSemesterReportPage({super.key});

  @override
  State<DetailSemesterReportPage> createState() => _DetailSemesterReportPageState();
}

class _DetailSemesterReportPageState extends State<DetailSemesterReportPage> {
  List<String> childrenNames = ['Dokja', 'Rafayel', 'Caleb', 'Moran', 'WKWK'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary5,
      appBar: AppBar(
        backgroundColor: AppColors.primary50,
        elevation: 0,
        title: Text(
          'Laporan Semester',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.primary5,
          ),
        ),
        leading: IconButton(
          padding: const EdgeInsets.only(left: 12.0),
          icon: Container(
            padding: const EdgeInsets.all(3.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'Semester 1',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: childrenNames.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary10,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.picture_as_pdf, color: Colors.red),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            childrenNames[index],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.blue),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Konfirmasi'),
                                content: Text('Yakin ingin menghapus Laporan Semester ${childrenNames[index]}" dari daftar?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(), // Tutup dialog
                                    child: Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        childrenNames.removeAt(index); // Hapus anak
                                      });
                                      Navigator.of(context).pop(); // Tutup dialog
                                    },
                                    child: Text('Hapus', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
                
              ),
              
            ),
            
          ],
          
        ),
        
      ),
    );
  }
}
