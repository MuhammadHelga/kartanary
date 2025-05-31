import 'package:flutter/material.dart';
import 'package:lifesync_capstone_project/widgets/custom_snackbar.dart';
import '../../theme/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailSemesterReportPage extends StatefulWidget {
  final String classId;
  final String selectedSemester;
  const DetailSemesterReportPage({
    super.key,
    required this.classId,
    required this.selectedSemester,
  });

  @override
  State<DetailSemesterReportPage> createState() =>
      _DetailSemesterReportPageState();
}

class _DetailSemesterReportPageState extends State<DetailSemesterReportPage> {
  List<Map<String, dynamic>> laporanList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLaporanSemester();
  }

  Future<void> fetchLaporanSemester() async {
    try {
      final anakSnapshot =
          await FirebaseFirestore.instance
              .collection('kelas')
              .doc(widget.classId)
              .collection('anak')
              .get();

      List<Map<String, dynamic>> laporan = [];

      for (var anakDoc in anakSnapshot.docs) {
        final anakId = anakDoc.id;
        final anakName = anakDoc['name'];

        final laporanDoc =
            await FirebaseFirestore.instance
                .collection('anak')
                .doc(anakId)
                .collection('laporanSemester')
                .doc(widget.selectedSemester)
                .get();

        if (laporanDoc.exists) {
          final data = laporanDoc.data()!;
          laporan.add({
            'anakName': anakName,
            'semester': data['semester'],
            'fileUrl': data['pdfUrl'],
            'uploadedAt': (data['uploadedAt'] as Timestamp).toDate(),
            'anakId': anakId,
          });
        }
      }

      if (!mounted) return;
      setState(() {
        laporanList = laporan;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching laporan: $e');
      setState(() => isLoading = false);
      if (!mounted) return;
      showErrorSnackBar(context, 'Gagal mengambil data laporan: $e');
    }
  }

  Future<void> _deleteLaporan(String anakId, int index) async {
    try {
      // Tampilkan dialog konfirmasi
      bool confirmDelete = await showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('Konfirmasi Hapus'),
              content: Text('Apakah Anda yakin ingin menghapus laporan ini?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Batal'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Hapus', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
      );

      if (confirmDelete == true) {
        if (mounted) {
          setState(() => isLoading = true);
        }

        // Hapus dokumen dari Firestore
        await FirebaseFirestore.instance
            .collection('anak')
            .doc(anakId)
            .collection('laporanSemester')
            .doc(widget.selectedSemester)
            .delete();

        // Hapus dari list lokal
        if (mounted) {
          setState(() {
            laporanList.removeAt(index);
            isLoading = false;
          });
        }
        if (!mounted) return;
        showSuccessSnackBar(context, 'Laporan berhasil dihapus');
      }
    } catch (e) {
      setState(() => isLoading = false);

      if (!mounted) return;
      showErrorSnackBar(context, 'Gagal menghapus laporan: $e');
    }
  }

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
            fontSize: 22,
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
                    widget.selectedSemester,
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
              child:
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : laporanList.isEmpty
                      ? Center(
                        child: Text('Belum ada laporan untuk semester ini.'),
                      )
                      : ListView.builder(
                        itemCount: laporanList.length,
                        itemBuilder: (context, index) {
                          final laporan = laporanList[index];
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
                                const Icon(
                                  Icons.picture_as_pdf,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    '${laporan['anakName']}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    size: 28,
                                    color: AppColors.primary40,
                                  ),
                                  onPressed:
                                      () => _deleteLaporan(
                                        laporan['anakId'],
                                        index,
                                      ),
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
