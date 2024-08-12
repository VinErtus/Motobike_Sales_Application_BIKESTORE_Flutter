import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/api.dart';
import '../../model/bill.dart';
import 'history_detail.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Future<List<BillModel>> _getBills() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository().getHistory(prefs.getString('token').toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Background color blue
      body: FutureBuilder<List<BillModel>>(
        future: _getBills(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Không có dữ liệu",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (context, index) {
              final itemBill = snapshot.data![index];
              return _billWidget(itemBill, context);
            },
          );
        },
      ),
    );
  }

  Widget _billWidget(BillModel bill, BuildContext context) {
    // Get the last 4 characters of the bill ID
    String billId = bill.id.length > 4 ? bill.id.substring(bill.id.length - 4) : bill.id;

    return Card(
      elevation: 6,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      shadowColor: Colors.black45,
      child: InkWell(
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var temp = await APIRepository().getHistoryDetail(bill.id, prefs.getString('token').toString());
          Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryDetail(bill: temp)));
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.white], // Blue gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Mã đơn hàng: #$billId', // Display the last 4 characters of the bill ID
                          style: GoogleFonts.lato(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(DateFormat('dd/MM/yyyy').parse(bill.dateCreated)),
                        style: GoogleFonts.lato(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    bill.fullName,
                    style: GoogleFonts.lato(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Tổng tiền: ${NumberFormat('#,##0').format(bill.total)} VNĐ',
                    style: GoogleFonts.abel(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 234, 121, 87), // Gold color
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20.0,
              right: 8.0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 107, 213, 36),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Đã thanh toán',
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
