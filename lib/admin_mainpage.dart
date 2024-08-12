import 'dart:convert';
import 'package:bikestore/app/consts/consts.dart';
import 'package:bikestore/app/page/category/category_data.dart';
import 'package:bikestore/app/page/details_admin.dart';
import 'package:bikestore/app/widget_common/bg1_widget.dart';
import 'package:bikestore/app/widget_common/bg_wigdet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/data/sharepre.dart';
import 'app/favorite/favorite.dart';
import 'app/model/user.dart'; // Adjust import according to your project structure
import 'app/page/cart/cart_screen.dart';
import 'app/page/category/category_list.dart';
import 'app/page/defaultwidget.dart';
import 'app/page/detail.dart';
import 'app/page/home/home_screen.dart';
import 'app/page/history/history_screen.dart';
import 'app/page/product/product_list.dart';
import 'app/page3/page3.dart'; // Adjust import according to your project structure

class AdminMainpage extends StatefulWidget {
  const AdminMainpage({super.key});

  @override
  State<AdminMainpage> createState() => _AdminMainpageState();
}

class _AdminMainpageState extends State<AdminMainpage> {
  User user = User.userEmpty();
  int _selectedIndex = 0;

  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;

    user = User.fromJson(jsonDecode(strUser));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _loadWidget(int index) {
    var nameWidgets = "Home";
    switch (index) {
      case 0:
        {
          return HomeBuilder(); // This should be adjusted to admin-specific content if needed
        }
      case 1:
        {
          return ProductList();
        }
      case 2:
        {
          return CategoryList();
        }
      case 3:
        {
          return const DetailsAdmin();
        }
      default:
        nameWidgets = "None";
        break;
    }
    return DefaultWidget(title: nameWidgets);
  }

  @override
  Widget build(BuildContext context) {
    return bgWidget1(
      child: Scaffold(
        backgroundColor: Colors.transparent,

        // appBar: AppBar(
        //
        //   title: Column(
        //     crossAxisAlignment: CrossAxisAlignment.end,
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       const SizedBox(width: 10),
        //       Image.asset(
        //         'assets/images/logo.png', // Replace with the path to your new logo image
        //         height: 75,
        //         errorBuilder: (context, error, stackTrace) =>
        //         const Icon(Icons.image, size: 100),
        //       ),
        //     ],
        //   ),
        //   backgroundColor: Colors.transparent,
        //   centerTitle: true,
        //   elevation: 0, // Remove shadow of AppBar
        // ),
        // drawer: Drawer(
        //
        //   child: ListView(
        //     padding: EdgeInsets.zero,
        //     children: [
        //       DrawerHeader(
        //
        //         decoration: const BoxDecoration(
        //           gradient: LinearGradient(
        //             begin: Alignment.topCenter,
        //             end: Alignment.bottomCenter,
        //             colors: [
        //               Color.fromARGB(255, 5, 85, 179),
        //               Color.fromARGB(255, 44, 141, 252),
        //             ],
        //           ),
        //         ),
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             user.imageURL!.length < 5
        //                 ? const CircleAvatar(
        //               radius: 40,
        //               backgroundImage:
        //               AssetImage('assets/images/default_avatar.png'),
        //             )
        //                 : CircleAvatar(
        //               radius: 40,
        //               backgroundImage: NetworkImage(
        //                 user.imageURL!,
        //               ),
        //             ),
        //             const SizedBox(
        //               height: 12,
        //             ),
        //             Text(
        //               user.fullName!,
        //               style: GoogleFonts.rowdies(
        //                   fontSize: 24,
        //                   fontWeight: FontWeight.bold,
        //                   color: Colors.white
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //       _buildListTile(
        //         icon: Icons.home,
        //         title: 'Trang chủ',
        //         onTap: () {
        //           _navigate(0);
        //         },
        //       ),
        //       _buildListTile(
        //         icon: Icons.history,
        //         title: 'Lịch sử',
        //         onTap: () {
        //           _navigate(1);
        //         },
        //       ),
        //       _buildListTile(
        //         icon: Icons.category,
        //         title: 'Danh mục',
        //         onTap: () {
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(builder: (context) => const CategoryList()),
        //           );
        //         },
        //       ),
        //       _buildListTile(
        //         icon: Icons.list,
        //         title: 'Sản phẩm',
        //         onTap: () {
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(builder: (context) => const ProductList()),
        //           );
        //         },
        //       ),
        //
        //       Divider(
        //         color: Colors.grey[300],
        //         height: 1,
        //       ),
        //       user.accountId == ''
        //           ? const SizedBox()
        //           : _buildListTile(
        //         icon: Icons.exit_to_app,
        //         title: 'Đăng xuất',
        //         onTap: () {
        //           logOut(context);
        //         },
        //       ),
        //     ],
        //   ),
        // ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.square_rounded),
              label: 'Sản phẩm',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Danh mục',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Thông tin',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color.fromARGB(255, 5, 85, 179),
          unselectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ),
        body: _loadWidget(_selectedIndex),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _navigate(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.pop(context);
    });
  }
}
