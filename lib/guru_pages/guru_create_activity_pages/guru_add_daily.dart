import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/AppColors.dart';

class AddDailyPage extends StatefulWidget {
  const AddDailyPage({super.key});

  @override
  State<AddDailyPage> createState() => _AddDailyPageState();
}

class _AddDailyPageState extends State<AddDailyPage> {
  final TextEditingController namaKegiatanController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];

  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.gallery) {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        setState(() {
          // Tambahkan gambar baru ke daftar yang sudah ada
          _selectedImages.addAll(pickedFiles.map((xfile) => File(xfile.path)).toList());
        });
      }
    } else {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _selectedImages.add(File(pickedFile.path));
        });
      }
    }
  }

  void _showImageSourceOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil dari Kamera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text(
            'Nama Kegiatan',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: namaKegiatanController,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.only(bottom: 4),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 24),
          const Text(
            'Deskripsi',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: deskripsiController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.only(bottom: 4),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 24),
          const Text(
            'Upload Gambar',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            child: _selectedImages.isNotEmpty
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _selectedImages.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    // Mengekstrak nama file dari path
                    String fileName = _selectedImages[index].path.split('/').last;
                    
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          // Preview gambar di sebelah kiri
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8)
                            ),
                            child: Image.file(
                              _selectedImages[index],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Nama file di sebelah kanan
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                fileName,
                                style: const TextStyle(fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          // Tombol hapus
                          IconButton(
                            onPressed: () => _removeImage(index),
                            icon: const Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Tombol untuk menambahkan gambar lagi
                Center(
                  child: OutlinedButton.icon(
                    onPressed: () => _showImageSourceOptions(context),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      side: BorderSide(color: AppColors.primary30, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    icon: Icon(
                      Icons.add_photo_alternate,
                      color: AppColors.primary30,
                    ),
                    label: Text(
                      'Tambah Gambar Lagi',
                      style: TextStyle(color: AppColors.primary30),
                    ),
                  ),
                ),
              ],
            )
            : OutlinedButton(
              onPressed: () => _showImageSourceOptions(context),
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.white,
                fixedSize: const Size(270, 120),
                side: BorderSide(color: AppColors.primary30, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Icon(
                Icons.upload_outlined,
                color: AppColors.primary30,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (namaKegiatanController.text.isEmpty ||
                    deskripsiController.text.isEmpty ||
                    _selectedImages.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Harap isi semua kolom dan upload gambar."),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                print("Nama: ${namaKegiatanController.text}");
                print("Deskripsi: ${deskripsiController.text}");
                for (var img in _selectedImages) {
                  print("Image path: ${img.path}");
                }

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Berhasil"),
                    content: const Text("Data kegiatan berhasil disimpan."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.25),
              ),
              child: const Text(
                'Simpan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}