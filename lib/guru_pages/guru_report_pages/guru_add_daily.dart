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
  final TextEditingController lokasiController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(0), // biar ga mepet
      child:  Column(
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
            'Lokasi',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: lokasiController,
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
          Center(
            child: GestureDetector(
              onTap: () => _showImageSourceOptions(context),
              child: _selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _selectedImage!,
                        width: 300,
                        height: 150,
                        fit: BoxFit.fitWidth,
                      ),
                    )
                  : OutlinedButton(
                      onPressed: () => _showImageSourceOptions(context),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        fixedSize: const Size(270, 120),
                        side: BorderSide(color: Colors.grey.shade400, width: 2),
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
          ),

          const SizedBox(height: 40),
          Center(
            child: ElevatedButton(
              onPressed: () {
                print("Nama: ${namaKegiatanController.text}");
                print("Lokasi: ${lokasiController.text}");
                print("Deskripsi: ${deskripsiController.text}");
                print("Image path: ${_selectedImage?.path}");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
                ),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical:10),
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
        ],
      )
    );
  }
}
