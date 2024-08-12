import 'package:bikestore/app/widget_common/bg_wigdet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../mainpage.dart';
import '../data/api.dart';
import '../data/sharepre.dart';
import '../page/auth/login.dart';

class QuenMatKhau extends StatefulWidget {
  const QuenMatKhau({super.key});

  @override
  State<QuenMatKhau> createState() => QuenMatKhauState();
}

class QuenMatKhauState extends State<QuenMatKhau> {
  final _formKey = GlobalKey<FormState>();
  var accountIdController = TextEditingController();
  var newPasswordController = TextEditingController();
  var numberIdController = TextEditingController();
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login() async {
    String token = await APIRepository()
        .login(accountController.text, passwordController.text);
    var user = await APIRepository().current(token);
    saveUser(user);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Mainpage()));
    return token;
  }

  void quenmatkhau() async {
    if (_formKey.currentState!.validate()) {
      try {
        String accountId = accountIdController.text;
        String numberId = numberIdController.text;
        String newPassword = newPasswordController.text;

        String token =
            await APIRepository().quenmatkhau(accountId, numberId, newPassword);
        if (token.isNotEmpty) {
          var user = await APIRepository().current(token);
          if (user != null) {
            saveUser(user); // Make sure saveUser function saves the user data
            Navigator.pop(context);
          } else {
            showErrorDialog("User not found.");
          }
        } else {
          showErrorDialog("Invalid token received.");
        }
      } catch (e) {
        showErrorDialog("Error during password reset: $e");
      }
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          // Background color updated to pink
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.check,
                color: const Color.fromARGB(255, 44, 141, 252),
                size: 80,
              ),
              SizedBox(height: 20),
              Text(
                'Thành công',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 18, 124, 250),
                  // Button background color updated to deeper pink
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 24.0),
                  child: Text(
                    'Quay lại trang đăng nhập',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: Text(
            "Quên mật khẩu",
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //     colors: [const Color.fromARGB(255, 249, 177, 64), Colors.black], // Pink gradient
          //   ),
          // ),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/logo.png",
                              height: 120,
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
                                      controller: accountIdController,
                                      decoration: InputDecoration(
                                        labelText: "Tên dăng nhập",
                                        prefixIcon: const Icon(Icons.person,
                                            color: Color.fromARGB(255, 5, 85, 179)),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Vui lòng nhập tên đăng nhập';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: passwordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        labelText: "Mật khẩu cũ",
                                        prefixIcon: const Icon(Icons.lock,
                                            color: Color.fromARGB(255, 5, 85, 179)),
                                        filled: true,
                                        fillColor: Colors.white,
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
                                        prefixIcon: const Icon(Icons.lock,
                                            color: Color.fromARGB(255, 5, 85, 179)),
                                        filled: true,
                                        fillColor: Colors.white,
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
                                      onPressed: quenmatkhau,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 5, 85, 179),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16.0, horizontal: 32.0),
                                        textStyle: const TextStyle(fontSize: 18),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      child: const Text(
                                        "Đổi mật khẩu",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

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
