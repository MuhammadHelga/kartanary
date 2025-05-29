import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifesync_capstone_project/theme/app_colors.dart';

class GuruAddTema extends StatefulWidget {
  final String classId;

  const GuruAddTema({super.key, required this.classId});

  @override
  State<GuruAddTema> createState() => _GuruAddTemaState();
}

class _GuruAddTemaState extends State<GuruAddTema> {
  final TextEditingController _temaController = TextEditingController();
  final List<TextEditingController> _mingguControllers = [
    TextEditingController(),
  ]; // Start with 1 week

  bool _isLoading = false;

  void _addWeek() {
    if (_mingguControllers.length < 5) {
      // Max 10 weeks
      setState(() {
        _mingguControllers.add(TextEditingController());
      });
    }
  }

  void _removeWeek(int index) {
    if (_mingguControllers.length > 1) {
      // Must have at least 1 week
      setState(() {
        _mingguControllers[index].dispose();
        _mingguControllers.removeAt(index);
      });
    }
  }

  Future<void> _saveTemplate() async {
    // Validate inputs
    if (_temaController.text.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harap isi nama tema'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Check if at least one week is filled
    bool hasFilledWeek = false;
    for (var controller in _mingguControllers) {
      if (controller.text.trim().isNotEmpty) {
        hasFilledWeek = true;
        break;
      }
    }

    if (!hasFilledWeek) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harap isi minimal satu minggu'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Prevent multiple submissions
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Validate classId
      if (widget.classId.isEmpty) {
        throw Exception('Class ID tidak valid');
      }

      // Prepare data - only include filled weeks
      List<Map<String, dynamic>> mingguData = [];
      for (int i = 0; i < _mingguControllers.length; i++) {
        if (_mingguControllers[i].text.trim().isNotEmpty) {
          mingguData.add({
            'minggu-ke': i + 1,
            'Sub-Tema': _mingguControllers[i].text.trim(),
          });
        }
      }

      final temaData = {
        'Tema': _temaController.text.trim(),
        'minggu': mingguData,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Save to Firestore with timeout
      await FirebaseFirestore.instance
          .collection('kelas')
          .doc(widget.classId)
          .collection('tema')
          .add(temaData)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception('Timeout: Koneksi terlalu lama');
            },
          );

      // Success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tema berhasil ditambahkan'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate back after success
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.of(context).pop(true); // Return true to indicate success
        }
      }
    } catch (e) {
      // Error handling
      if (mounted) {
        String errorMessage;
        if (e.toString().contains('network')) {
          errorMessage = 'Gagal menyimpan: Periksa koneksi internet';
        } else if (e.toString().contains('permission')) {
          errorMessage = 'Gagal menyimpan: Tidak memiliki izin';
        } else if (e.toString().contains('Timeout')) {
          errorMessage = 'Gagal menyimpan: Koneksi timeout';
        } else {
          errorMessage = 'Gagal menyimpan tema: ${e.toString()}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      // Log error for debugging
      debugPrint('Error saving tema: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin ingin menyimpan tema ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveTemplate();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF24A0DB),
              ),
              child: const Text(
                'Simpan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _temaController.dispose();
    for (var controller in _mingguControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary50,
        elevation: 0,
        title: Text(
          'Tambahkan Tema',
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
          _isLoading
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Menyimpan tema...'),
                  ],
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Tema Laporan Mingguan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Tema field
                    const Center(
                      child: Text(
                        'Tema',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildUnderlinedTextField(_temaController),
                    const SizedBox(height: 25),

                    // Dynamic Minggu fields
                    ...List.generate(_mingguControllers.length, (index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Sub-Tema Minggu ${_getRomanNumeral(index + 1)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              if (_mingguControllers.length >
                                  1) // Only show remove button if more than 1 week
                                IconButton(
                                  onPressed: () => _removeWeek(index),
                                  icon: const Icon(Icons.remove_circle_outline),
                                  color: Colors.red,
                                  tooltip: 'Hapus minggu',
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildUnderlinedTextField(_mingguControllers[index]),
                        ],
                      );
                    }),

                    const SizedBox(height: 20),

                    // Add week button
                    if (_mingguControllers.length < 10)
                      Center(
                        child: TextButton.icon(
                          onPressed: _addWeek,
                          icon: const Icon(Icons.add_circle_outline),
                          label: const Text('Tambah Minggu'),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF24A0DB),
                          ),
                        ),
                      ),

                    const SizedBox(height: 40),

                    // Simpan button
                    Center(
                      child: SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _showConfirmDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF24A0DB),
                            disabledBackgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child:
                              _isLoading
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text(
                                    'Simpan',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
    );
  }

  Widget _buildUnderlinedTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      enabled: !_isLoading, // Disable during loading
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(bottom: 4),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.5),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
      ),
    );
  }

  String _getRomanNumeral(int number) {
    switch (number) {
      case 1:
        return 'I';
      case 2:
        return 'II';
      case 3:
        return 'III';
      case 4:
        return 'IV';
      case 5:
        return 'V';
      default:
        return number.toString();
    }
  }
}
