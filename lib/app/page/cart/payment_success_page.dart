import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../main.dart';
import '../home/home_screen.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán thành công'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100.0,
            ),
            SizedBox(height: 20.0),
            Text(
              'Thanh toán của bạn đã thành công!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to HomeBuilder screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainApp()),
                );
              },
              child: Column(
                children: [
                  _buildDetailItem(Icons.check_circle, 'Quay về trang chủ'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, /*String? value*/) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.white,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: Icon(icon, color: Color(0xFF1976D2), size: 30),
              title: Text(
                label,
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              // trailing: Text(
              //   value ?? 'Không có dữ liệu',
              //   style: GoogleFonts.lato(
              //     fontSize: 16,
              //     fontWeight: FontWeight.w400,
              //     color: Color.fromARGB(255, 93, 92, 92),
              //   ),
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
