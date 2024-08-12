import 'package:bikestore/app/data/api.dart';
import 'package:bikestore/app/data/sharepre.dart';
import 'package:bikestore/app/page/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/const.dart';

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
          backgroundColor:Color(0xFFE3F2FD),
          // Background color updated to pink
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.check_circle,
                color: Colors.green.shade600,
                size: 60,
              ),
              SizedBox(height: 20),
              Text(
                'Success',
                style: GoogleFonts.rowdies(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(232, 3, 18, 148),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
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
                      vertical: 16.0, horizontal: 24.0),
                  child: Text(
                    'Continue',
                    style: GoogleFonts.rowdies(
                      fontSize: 20,
                      color: const Color(0xFFE3F2FD),
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
              colors: [Color(0xFF64B5F6), Color(0xFFE3F2FD)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                          Image.asset(
                            urlLogo,
                            height: 200,
                          ),
                          const Text(
                            'Change Password',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(232, 3, 18, 148), // Deep pink text
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: accountIdController,
                            decoration: InputDecoration(
                              labelText: "Account",
                              prefixIcon: const Icon(Icons.person,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please fill in old password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: numberIdController,
                            decoration: InputDecoration(
                              labelText: "Number ID",
                              prefixIcon: const Icon(Icons.person,),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please fill in old password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: newPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "New Password",
                              prefixIcon: const Icon(Icons.lock,),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please fill in old password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Back",
                                  style: GoogleFonts.rowdies(color: const Color.fromARGB(232, 3, 18, 148)),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: quenmatkhau,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 221, 123, 24),
                                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Change",
                                  style: GoogleFonts.rowdies(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
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
    );
  }
}
