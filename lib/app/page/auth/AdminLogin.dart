import 'package:bikestore/app/page/auth/step2_admin.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bikestore/app/widget_common/bg_wigdet.dart';
import '../../../mainpage.dart';
import '../../data/api.dart';
import '../../data/sharepre.dart';
import '../register.dart'; // Adjust the import path according to your project structure

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController adminController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true; // State variable to toggle password visibility

  login() async {
    String token = await APIRepository()
        .login(adminController.text, passwordController.text);
    var user = await APIRepository().current(token);
    saveUser(user);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Step2Admin()));
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 120,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image, size: 100),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: const Color.fromARGB(255, 245, 244, 244),
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Nhập tài khoản quản trị viên",
                            style: GoogleFonts.kanit(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 32),
                          AnimatedContainer(
                            duration: const Duration(seconds: 3),
                            child: TextField(
                              controller: adminController,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: "Tên đăng nhập",
                                labelStyle: const TextStyle(color: Colors.grey),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(color: Color.fromARGB(255, 5, 85, 179)),
                                ),
                                prefixIcon: const Icon(Icons.person, color: Color.fromARGB(255, 5, 85, 179)),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          AnimatedContainer(
                            duration: const Duration(seconds: 3),
                            child: TextField(
                              controller: passwordController,
                              obscureText: _obscurePassword,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: "Mật khẩu",
                                labelStyle: const TextStyle(color: Colors.grey),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(color: Color.fromARGB(255, 5, 85, 179)),
                                ),
                                prefixIcon: const Icon(Icons.lock, color: Color.fromARGB(255, 5, 85, 179)),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    color: const Color.fromARGB(255, 5, 85, 179),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 5, 85, 179),
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                              textStyle: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              "Đăng nhập",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
