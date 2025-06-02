import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cek status login yang disimpan
  Future<Map<String, dynamic>?> checkSavedLoginState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      final classId = prefs.getString('classId') ?? '';
      final role = prefs.getString('role') ?? '';

      final currentUser = _auth.currentUser;

      if (isLoggedIn &&
          currentUser != null &&
          classId.isNotEmpty &&
          role.isNotEmpty) {
        return {
          'isLoggedIn': true,
          'classId': classId,
          'role': role,
          'user': currentUser,
        };
      }

      await currentUser?.reload();
      if (currentUser?.emailVerified == false) {
        await clearLoginState();
        return null;
      }
    } catch (e) {
      debugPrint('Error checking saved login state: $e');
    }
    return null;
  }

  // Logout tapi hanya hapus status login
  Future<void> clearLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    // Pilih salah satu:
    // 1. Hapus isLoggedIn:
    await prefs.remove('isLoggedIn');
    // 2. ATAU set isLoggedIn ke false:
    // await prefs.setBool('isLoggedIn', false);
  }

  // Simpan status login dan data user
  Future<void> saveLoginState({
    required bool isLoggedIn,
    required String classId,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
    await prefs.setString('classId', classId);
    await prefs.setString('role', role);
  }

  // Register
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await cred.user!.sendEmailVerification();
      return cred.user;
    } catch (e) {
      debugPrint('Error saat register: $e');
      return null;
    }
  }

  // Simpan data user baru ke Firestore
  Future<void> saveUserData(
    String uid,
    String name,
    String role, {
    String fcmToken = '',
    String joinedClassId = '',
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'role': role,
        'fcmToken': fcmToken,
        'joinedClassId': joinedClassId,
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saat menyimpan data user: $e');
    }
  }

  // Login
  Future<User?> loginWithEmail(
    String email,
    String password,
    BuildContext context, {
    required String selectedRole,
  }) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = cred.user;

      if (!user!.emailVerified) {
        await _auth.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email belum diverifikasi. Silakan cek email anda'),
          ),
        );
        return null;
      }

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        debugPrint('Dokumen user tidak ditemukan');
        return null;
      }

      String storedRole = userDoc['role'];
      final userData = userDoc.data() as Map<String, dynamic>;

      String classId =
          userData.containsKey('joinedClassId')
              ? userData['joinedClassId'] ?? ''
              : '';

      if (storedRole != selectedRole) {
        await _auth.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              padding: const EdgeInsets.all(10),
              height: 70,
              decoration: const BoxDecoration(
                color: AppColors.error300,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.error_outline, color: Colors.white, size: 26),
                  SizedBox(width: 10),
                  Text(
                    'Peran tidak sesuai. Silakan pilih peran yang sesuai saat login.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );
        return null;
      }

      await saveLoginState(
        isLoggedIn: true,
        classId: classId,
        role: storedRole,
      );

      return user;
    } catch (e) {
      debugPrint('Error saat login: $e');
      return null;
    }
  }

  // Reset Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint('Error saat mengirim email reset password: $e');
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    await clearLoginState(); // Tidak menghapus classId & role
  }

  // Update email
  Future<String?> updateUserEmail(String newEmail) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.verifyBeforeUpdateEmail(newEmail);
        return 'Verifikasi telah dikirim ke email baru. Silakan cek dan konfirmasi.';
      } else {
        return 'User tidak ditemukan.';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return 'Silakan login ulang untuk mengubah email.';
      }
      return 'Gagal mengubah email: ${e.message}';
    } catch (e) {
      return 'Terjadi kesalahan: $e';
    }
  }

  // Tambah kelas
  Future<String> simpanKelas({
    required String namaKelas,
    required String ruangan,
    required String tahunAjaran,
  }) async {
    String generateKodeKelas({int length = 6}) {
      const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
      final random = DateTime.now().millisecondsSinceEpoch;
      return List.generate(
        length,
        (index) => chars[(random + index * 17) % chars.length],
      ).join();
    }

    final user = _auth.currentUser;
    if (user == null) throw Exception('Pengguna belum login');

    final String kodeKelas = generateKodeKelas();

    try {
      final docRef = await _firestore.collection('kelas').add({
        'kode_kelas': kodeKelas,
        'nama_kelas': namaKelas,
        'ruangan': ruangan,
        'tahun_ajaran': tahunAjaran,
        'dibuat_oleh': user.uid,
        'dibuat_pada': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      debugPrint('Error saat menyimpan kelas: $e');
      throw e;
    }
  }

  // Tambah anak
  Future<void> tambahAnak({
    required String name,
    required String gender,
    required String age,
    required String classId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('kelas')
          .doc(classId)
          .collection('anak')
          .add({
            'name': name,
            'gender': gender,
            'age': age,
            'createdAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      debugPrint('Error saat menambah anak: $e');
      throw e;
    }
  }
}
