import 'package:flutter/material.dart';
import '../../../main.dart';
import '../home/home_screen.dart'; // Import your home screen

class PaymentFailurePage extends StatelessWidget {
  const PaymentFailurePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán thất bại'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              color: Colors.red,
              size: 100.0,
            ),
            SizedBox(height: 20.0),
            Text(
              'Thanh toán của bạn đã thất bại!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainApp()),
                );
              },
              child: const Text('Quay lại Trang Chính'),
            ),
          ],
        ),
      ),
    );
  }
}
