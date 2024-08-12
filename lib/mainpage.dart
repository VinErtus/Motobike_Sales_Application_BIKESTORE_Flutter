import 'dart:convert';
import 'package:bikestore/app/widget_common/bg1_widget.dart';
import 'package:bikestore/app/widget_common/bg_wigdet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bikestore/app/model/user.dart';
import 'package:bikestore/app/page/cart/cart_screen.dart';
import 'package:bikestore/app/page/category/category_list.dart';
import 'package:bikestore/app/page/detail.dart';
import 'package:bikestore/app/page/history/history_screen.dart';
import 'package:bikestore/app/page/home/home_screen.dart';
import 'package:bikestore/app/page/product/product_list.dart';
import 'package:bikestore/app/route/favorite.dart';
import 'package:bikestore/app/route/page3.dart';
import 'package:bikestore/constants.dart';
import 'app/page/defaultwidget.dart';
import 'app/data/sharepre.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({Key? key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
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
          return HomeBuilder();
        }
      case 1:
        {
          return HistoryScreen();
        }
      case 2:
        {
          return CartScreen();
        }
      case 3:
        {
          return const Detail();
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
        appBar: AppBar(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 255),
              Image.asset(
                'assets/images/logo.png', // Replace with the path to your new logo image
                height: 68,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image, size: 60),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0, // Loại bỏ shadow của AppBar
          // actions: <Widget>[
          //   IconButton(
          //     icon: SvgPicture.asset(
          //       "assets/icons/cart.svg",
          //       colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
          //     ),
          //     onPressed: () {
          //       _selectedIndex = 2;
          //       setState(() {});
          //     },
          //   ),
          //   SizedBox(width: kDefaultPaddin / 2)
          // ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 5, 85, 179),
                      Color.fromARGB(255, 44, 141, 252),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    user.imageURL!.length < 5
                        ? CircleAvatar(
                      radius: 40,
                      backgroundImage:
                      AssetImage('assets/images/avt.png'),
                    )
                        : CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(
                        'assets/images/avatar.jpg',
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      user.fullName!,
                      style: GoogleFonts.rowdies(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              _buildListTile(
                icon: Icons.home,
                title: 'Trang chủ',
                onTap: () {
                  _navigate(0);
                },
              ),
              _buildListTile(
                icon: Icons.history,
                title: 'Lịch sử',
                onTap: () {
                  _navigate(1);
                },
              ),
              _buildListTile(
                icon: Icons.shopping_cart,
                title: 'Giỏ hàng',
                onTap: () {
                  _navigate(2);
                },
              ),
              _buildListTile(
                icon: Icons.favorite,
                title: 'Yêu thích',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FavScreen()),
                  );
                },
              ),
              _buildListTile(
                icon: Icons.security,
                title: 'Đổi mật khẩu',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Page3()),
                  );
                },
              ),
              Divider(
                color: Colors.grey[400],
                height: 1,
              ),
              user.accountId == ''
                  ? SizedBox()
                  : _buildListTile(
                icon: Icons.exit_to_app,
                title: 'Đăng xuất',
                onTap: () {
                  logOut(context);
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Lịch sử',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shop),
              label: 'Giỏ hàng',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Tài khoản',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color.fromARGB(255, 5, 85, 179), // Adjusted to pink color
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
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black87, // Adjusted to black color
        ),
      ),
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
