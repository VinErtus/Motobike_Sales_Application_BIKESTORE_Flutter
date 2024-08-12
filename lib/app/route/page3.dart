import 'package:bikestore/app/widget_common/bg_wigdet.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../mainpage.dart';
import '../data/api.dart';
import '../data/sharepre.dart';

class Page3 extends StatefulWidget {
  const Page3({super.key});

  @override
  State<Page3> createState() => Page3State();
}

class Page3State extends State<Page3> {
  final _formKey = GlobalKey<FormState>();
  var oldPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();


  void forget() async {
    if (_formKey.currentState!.validate()) {
      try {
        var oldPassword = oldPasswordController.text;
        var newPassword = newPasswordController.text;

        String token = await APIRepository().forget(oldPassword, newPassword);

        if (token.isNotEmpty) {
          var user = await APIRepository().current(token);
          if (user != null) {
            saveUser(user); // Assuming saveUser function saves user data
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Mainpage()),
            );
          } else {
            showErrorDialog("Không tìm thấy người dùng");
          }
        } else {
          showErrorDialog("Invalid token received.");
        }
      } catch (e) {
        showErrorDialog("Error during password change: $e");
      }
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Thành công"),
        actions: [
          TextButton(
            onPressed: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Mainpage()))
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // autoLogin();
  }

  autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Mainpage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //     colors: [Color.fromARGB(255, 250, 209, 109), Color.fromARGB(
          //         255, 255, 217, 158)], // Pink gradient
          //   ),
          // ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: 150,
                    ),
                    const SizedBox(height: 32),
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Đổi mật khẩu',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Deep pink text
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: oldPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Mật khẩu cũ",
                                prefixIcon: const Icon(
                                    Icons.person, color: Color.fromARGB(
                                    255, 44, 119, 210)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập mật khẩu cũ';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: newPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Mật khẩu mới",
                                prefixIcon: const Icon(
                                    Icons.lock, color: Color.fromARGB(
                                    255, 44, 119, 210)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập mật khẩu mới';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton(
                              onPressed: forget,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                    255, 44, 119, 210),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 32.0),
                                textStyle: const TextStyle(fontSize: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: const Text(
                                "Đổi mật khẩu",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
