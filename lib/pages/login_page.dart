import 'package:flutter/material.dart';
import '../screens/role_option_page.dart';
import '../pages/register_page.dart';
import '../pages/forgot_password.dart';
import '../widgets/bottom_navbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _hidepass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F9FD),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff98D5F1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Color(0xff1D99D3),
                        size: 36,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoleOptionPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Center(
                child: Image.asset(
                  'assets/images/logo_paud.png',
                  height: 200,
                  width: 200,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Memantau perkembangan anak dengan lebih mudah',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Email',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Icon(
                      Icons.email,
                      color: Color(0xff1D99D3),
                      size: 34,
                    ),
                  ),
                  hintText: 'Masukkan Email',
                  hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xffF8FAFC),
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Color(0xff1D99D3), width: 3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Color(0xff1D99D3), width: 3),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Password',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextField(
                obscureText: _hidepass,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Icon(Icons.lock, color: Color(0xff1D99D3), size: 34),
                  ),
                  hintText: 'Masukkan Password',
                  hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xffF8FAFC),
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _hidepass = !_hidepass;
                      });
                    },
                    icon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Icon(
                        _hidepass ? Icons.visibility_off : Icons.visibility,
                        color: Color(0xff1D99D3),
                        size: 34,
                      ),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Color(0xff1D99D3), width: 3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Color(0xff1D99D3), width: 3),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPassword()),
                    );
                  },
                  child: Text(
                    'Lupa password?',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BottomNavbar()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff1D99D3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: Text(
                    'Belum Punya Akun? Register',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
