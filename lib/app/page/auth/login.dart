import 'package:bikestore/app/consts/consts.dart';
import 'package:bikestore/app/page/user_manual/user_manual_app.dart';
import 'package:bikestore/app/widget_common/bg_wigdet.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../mainpage.dart';
import '../../config/const.dart';
import '../../consts/lists.dart';
import '../../data/api.dart';
import '../../quenmk/quenmatkhau.dart';
import '../register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/sharepre.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AdminLogin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;


  login() async {
    String username = accountController.text;
    String password = passwordController.text;

    // Check if the username is '/loginadmin' and password is empty
    if (username == '/ad' && password.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminLogin()),
        // Assuming AdminLogin is the page you want to navigate to
      );
      return; // Exit the function early
    }

    // Proceed with the usual login process
    try {
      String token = await APIRepository().login(username, password);
      var user = await APIRepository().current(token);
      saveUser(user);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Mainpage()),
      );
    } catch (e) {
      // Handle login failure (e.g., show an error message)
      print('Login failed: $e');
    }
  }

  @override
  void initState() {
    super.initState();

  }


  autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Mainpage()));
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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

                             // Container(
                             //   padding: const EdgeInsets.symmetric(
                             //       horizontal: 24, vertical: 12),
                             //   decoration: BoxDecoration(
                             //     gradient: const LinearGradient(
                             //       colors: [Colors.purple, Colors.blue],
                             //       begin: Alignment.topLeft,
                             //       end: Alignment.bottomRight,
                             //     ),
                             //     borderRadius: BorderRadius.circular(30),
                             //   ),
                             //   child: Text(
                             //     "Flowers Store",
                             //     style: GoogleFonts.pacifico(
                             //       fontSize: 28,
                             //       fontWeight: FontWeight.bold,
                             //       color: Colors.white,
                             //     ),
                             //   ),
                             // ),

                            Text(
                            "Nhập tài khoản của bạn",
                            style: GoogleFonts.kanit(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 32),
                            AnimatedContainer(
                              duration: const Duration(seconds: 3),
                               // decoration: BoxDecoration(
                               //   borderRadius: BorderRadius.circular(15),
                               //   boxShadow: [
                               //     BoxShadow(
                               //       color: const Color.fromARGB(255, 5, 85, 179).withOpacity(0.5),
                               //       blurRadius: 10,
                               //       spreadRadius: 5,
                               //       offset: const Offset(0, 0),
                               //     ),
                               //   ],
                               // ),
                              child: TextField(
                                controller: accountController,
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
                               // decoration: BoxDecoration(
                               //   borderRadius: BorderRadius.circular(15),
                               //   boxShadow: [
                               //     BoxShadow(
                               //       color: const Color.fromARGB(255, 5, 85, 179).withOpacity(0.5),
                               //       blurRadius: 10,
                               //       spreadRadius: 5,
                               //       offset: const Offset(0, 0),
                               //     ),
                               //   ],
                               // ),
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

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const QuenMatKhau()),
                                  );
                                  },
                                child: const Text(
                                  "Quên mật khẩu?",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextButton(
                              onPressed: (){},
                              child: ElevatedButton(
                                onPressed: login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 5, 85, 179),
                                  padding: const EdgeInsets.symmetric(horizontal:50, vertical: 20),
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
                            ),
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Hoặc tạo tài khoản mới",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16
                                ),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Register()));
                                },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color.fromARGB(255, 5, 85, 179)),
                                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                                textStyle: GoogleFonts.roboto(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                "Đăng ký",
                                style: TextStyle(color: Color.fromARGB(255, 5, 85, 179)),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Đăng nhập với",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16
                                ),
                              ),
                            ),



                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                socialIconList.length,
                                    (index) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                       // Mở liên kết khi người dùng nhấp vào biểu tượng
                                       _launchURL(socialIconList[index].link);
                                        },
                                        child: CircleAvatar(
                                          radius: 25,
                                          child: Image.asset(
                                            socialIconList[index].imagePath,
                                            width: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                              ),
                            ),


                           ],

                         ),
                       ),
                     ),
                  ),
                  Row(
                    children: [
                      SizedBox(width: 30,),
                      Text(
                          'Hướng dẫn sử dụng app BikeStore: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      TextButton(onPressed: (){Get.to(() => const UserManualApp());}, child: "Xem ngay".text.size(16).fontWeight(FontWeight.w600).color(redColor).make()),
                    ],
                  ),
                 ],
               ),
            ),
          ),
        ),
    );
  }
}



