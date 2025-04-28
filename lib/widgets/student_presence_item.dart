import 'package:flutter/material.dart';
import '../theme/AppColors.dart';

typedef PresenceChanged = void Function(String newStatus);

class StudentPresenceItem extends StatelessWidget {
  final String name;
  final String status;
  final PresenceChanged onStatusChanged;

  const StudentPresenceItem({
    Key? key,
    required this.name,
    required this.status,
    required this.onStatusChanged,
  }) : super(key: key);

  Color get _presenceColor {
    switch (status) {
      case 'Hadir':  return Color(0xffA8EE87);
      case 'Izin':   return Color(0xffF8D96D);
      case 'Sakit':  return Color(0xffFFA470);
      case 'Alpha':  return Color(0xffFF6666);
      default:       return AppColors.secondary50;
    }
  }

  String get _initial => status.isNotEmpty ? status[0] : '';

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Color(0xffF7FAFC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header: icon + status
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: _presenceColor,
                  radius: 30,
                  child: Text(
                    _initial,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Text(
              'Ubah keterangan kehadiran:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),

            // Buttons
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: ['Hadir', 'Sakit', 'Izin', 'Alpha']
                  .map((label) => _buildButton(context, label))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label) {
    final color = {
      'Hadir': Color(0xffA8EE87),
      'Izin':  Color(0xffF8D96D),
      'Sakit': Color(0xffFFA470),
      'Alpha': Color(0xffFF6666),
    }[label]!;

    return GestureDetector(
      onTap: () {
        onStatusChanged(label);
        Navigator.of(context).pop();
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDialog(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary10,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Nama di kiri
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),

            // CircleAvatar di kanan
            CircleAvatar(
              backgroundColor: _presenceColor,
              radius: 28,
              child: Text(
                _initial,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
