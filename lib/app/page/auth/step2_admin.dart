import 'package:bikestore/admin_mainpage.dart';
import 'package:bikestore/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart'; // Make sure you import this for Navigator.
import '../../../mainpage.dart'; // Import the home_screen.dart file

class Step2Admin extends StatefulWidget {
  const Step2Admin({super.key});

  @override
  State<Step2Admin> createState() => _Step2AdminState();
}

class _Step2AdminState extends State<Step2Admin> {
  TextEditingController codeController = TextEditingController();

  void _verifyCode() {
    // The correct code for verification
    const correctCode = '1122334455';

    // Get the entered code
    String enteredCode = codeController.text.trim();

    // Check if the entered code matches the correct code
    if (enteredCode == correctCode) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminMainpage()),
      );
    } else {
      // Show an error message if the code is incorrect
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mã không đúng, vui lòng nhập lại!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bước 2: Xác minh quản trị viên'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Nhập mã xác minh',
                style: GoogleFonts.kanit(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: codeController,
                decoration: InputDecoration(
                  labelText: 'Mã xác minh',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  prefixIcon: const Icon(Icons.code),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyCode,
                child: const Text('Xác thực',
                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),)
                ,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
