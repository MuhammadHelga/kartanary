import 'package:flutter/material.dart';
import '../screens/role_option_page.dart';
import '../pages/register_page.dart';
import '../pages/forgot_password.dart';
import '../guru_pages/choose_class_page.dart';
import '../services/auth_service.dart';
import '../ortu_pages/class_options.dart';
import '../theme/app_colors.dart';

class LoginPage extends StatefulWidget {
  final String role;
  final String classId;
  const LoginPage({super.key, required this.role, required this.classId});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _hidepass = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color.fromARGB(255, 176, 230, 255), Color(0xFFFFFFFF)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            padding: const EdgeInsets.only(left: 20),
            icon: Container(
              padding: EdgeInsets.all(6.5), // Padding di sekitar ikon
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Membuat bentuk bulat
                color: AppColors.neutral100, // Warna latar belakang bulatan
              ),
              child: Icon(Icons.chevron_left, color: AppColors.primary50),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RoleOptionPage(classId: widget.classId),
                ),
              );
            },
          ),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics:
                    constraints.maxHeight < 600
                        ? const BouncingScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 30,
                        top: 10,
                        right: 30,
                        bottom: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/images/kartanary_logo.png',
                              height: 200,
                              width: 200,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Memantau perkembangan anak dengan lebih mudah',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ..._buildLoginForm(),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLoginForm() {
    return [
      const Text(
        'Masuk',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 10),
      const Text(
        'Email',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      TextField(
        controller: _emailController,
        decoration: InputDecoration(
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Icon(Icons.email, color: Color(0xff1D99D3), size: 30),
          ),
          hintText: 'Masukkan Email',
          hintStyle: const TextStyle(fontSize: 18, color: Colors.grey),
          filled: true,
          fillColor: const Color(0xffF8FAFC),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 28,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xff1D99D3), width: 3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xff1D99D3), width: 3),
          ),
        ),
      ),
      const SizedBox(height: 10),
      const Text(
        'Password',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      TextField(
        controller: _passwordController,
        obscureText: _hidepass,
        decoration: InputDecoration(
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Icon(Icons.lock, color: Color(0xff1D99D3), size: 30),
          ),
          hintText: 'Masukkan Password',
          hintStyle: const TextStyle(fontSize: 18, color: Colors.grey),
          filled: true,
          fillColor: const Color(0xffF8FAFC),
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _hidepass = !_hidepass;
              });
            },
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                _hidepass ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xff1D99D3),
                size: 26,
              ),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xff1D99D3), width: 3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xff1D99D3), width: 3),
          ),
        ),
      ),
      const SizedBox(height: 10),
      Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ForgotPassword(
                      role: widget.role,
                      classId: widget.classId,
                    ),
              ),
            );
          },
          child: Text(
            'Lupa password?',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ),
      ),
      const SizedBox(height: 20),
      SizedBox(
        height: 55,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            // String userDeviceToken = await notificationService.getDeviceToken();

            final user = await AuthService().loginWithEmail(
              _emailController.text.trim(),
              _passwordController.text.trim(),
              context,
              selectedRole: widget.role,
            );

            if (user != null) {
              // // Simpan device token ke Firestore
              // await FirebaseFirestore.instance
              //     .collection('users')
              //     .doc(user.uid)
              //     .update({'deviceToken': userDeviceToken});
              if (widget.role == 'Guru') {
                if (!mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ChooseClassPage(
                          role: widget.role,
                          classId: widget.classId,
                        ),
                  ),
                );
              } else if (widget.role == 'Orang Tua') {
                if (!mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ClassOptions(
                          role: widget.role,
                          classId: widget.classId,
                        ),
                  ),
                );
              }
            }
          },

          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff1D99D3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: const Text(
            'Masuk',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
      const SizedBox(height: 20),
      Center(
        child: TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => RegisterPage(
                      role: widget.role,
                      classId: widget.classId,
                    ),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Belum Punya Akun?',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              Text(
                ' Daftar disini',
                style: TextStyle(
                  color: Color(0xff1D99D3),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }
}
