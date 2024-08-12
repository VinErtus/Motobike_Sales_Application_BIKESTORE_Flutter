import 'package:bikestore/app/page/category/category_datas.dart';
import 'package:bikestore/app/widget_common/bg1_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'category_add.dart';
import 'category_data.dart';

class CategoryLists extends StatefulWidget {
  const CategoryLists({super.key});

  @override
  State<CategoryLists> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryLists> {
  // get list

  @override
  Widget build(BuildContext context) {
    return bgWidget1(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: Text.rich(
        //     TextSpan(
        //       children: [
        //
        //         TextSpan(
        //           text: 'Danh mục',
        //           style: GoogleFonts.afacad(
        //             color: Color.fromARGB(255, 5, 85, 179), // Màu cho "List"
        //             fontWeight: FontWeight.bold,
        //             fontSize: 36,
        //           ),
        //         ),
        //       ],
        //     ),
        //   )
        // ),
        body: const Center(child: CategoryBuilders()),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.of(context)
        //         .push(
        //       MaterialPageRoute(
        //         builder: (_) => const CategoryAdd(),
        //         fullscreenDialog: true,
        //       ),
        //     )
        //         .then((_) => setState(() {}));
        //   },
        //   tooltip: 'Add New',
        //   backgroundColor: const Color.fromARGB(
        //       255, 44, 119, 210), // Thay đổi màu nền
        //   shape: RoundedRectangleBorder( // Bo tròn góc button
        //     borderRadius: BorderRadius.circular(16.0),
        //   ),
        //   elevation: 8.0, // Điều chỉnh độ cao của button
        //   child: const Icon(
        //     Icons.add,
        //     size: 32.0, // Thay đổi kích thước icon
        //     color: Colors.white, // Thay đổi màu icon
        //   ),
        // ),
      ),
    );
  }
}
