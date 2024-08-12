
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:bikestore/app/page/product/product_add.dart';
import 'package:bikestore/app/page/product/product_data.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text.rich(
      //     TextSpan(
      //       children: [
      //         TextSpan(
      //           text: 'Sản phẩm',
      //           style: GoogleFonts.afacad(
      //             color: const Color.fromARGB(
      //                 255, 44, 119, 210), // Màu cho "Category"
      //             fontWeight: FontWeight.bold,
      //             fontSize: 36
      //           ),
      //         ),
      //
      //       ],
      //     ),
      //   )
      // ),
      body: const Center(child: ProductBuilder()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (_) => const ProductAdd(),
                  fullscreenDialog: true,
                ),
              )
              .then((_) => setState(() {}));
        },
        tooltip: 'Thêm mới',
        backgroundColor: const Color.fromARGB(
            255, 44, 119, 210), // Thay đổi màu nền
        shape: RoundedRectangleBorder( // Bo tròn góc button
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 8.0, // Điều chỉnh độ cao của button
        child: const Icon(
          Icons.add,
          size: 32.0, // Thay đổi kích thước icon
          color: Color.fromARGB(255, 255, 255, 255), // Thay đổi màu icon
        ),
      ),
    );
  }
}
