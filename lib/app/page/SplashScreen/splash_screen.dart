//import 'package:emart_app/consts/colors.dart'; // Đảm bảo rằng bạn có tệp colors.dart với các màu được định nghĩa
import 'package:bikestore/app/page/auth/login.dart';
import 'package:bikestore/app/consts/consts.dart';
// import 'package:emart_app/views/auth_screen/login_screen.dart';


// import 'package:emart_app/views/home_screen/home_screen.dart';
// import 'package:emart_app/widgets_common/applogo_widget.dart';

// import 'package:emart_app/widgets_common/bg_widget.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../widget_common/applogo_widget_splash.dart';
import '../../widget_common/splashbg_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
//Tạo method để chuyển đổi screen
  changeScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      //Sử dụng Get để chuyển đổi màn hình Login
      Get.to(() => const LoginScreen());
    });
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return splashbgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //     colors: [
          //       Color.fromARGB(255, 115, 215, 255),
          //       Color.fromARGB(255, 0, 24, 34)
          //     ], // Thay đổi màu sắc theo ý muốn
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //   ),
          // ),
          child: Column(
            children: [
              250.heightBox,
              const Align(
                alignment: Alignment.center,
                // child: Image.asset(icSplashBg, width: 300),
              ),
              20.heightBox,
              applogoWidgetSplash(),
              10.heightBox,
              "Chào mừng bạn đến với"
                  .text
                  .fontFamily(bold)
                  .black
                  .size(24)
                  .make(),
              10.heightBox,
              Stack(
                children: [
                  // Text with stroke (black color)
                  Text(
                    'BIKESTORE',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 1
                        ..color = Colors.black,
                      shadows: const [
                        Shadow(
                            color: Color.fromARGB(128, 0, 0, 0),
                            blurRadius: 4, //độ mờ
                            offset: Offset(0, 4) //độ x, y
                        )
                      ],
                    ),
                  ),
                  // Solid text on top (white color)
                  const Text(
                    'BIKESTORE',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // 5.heightBox,
              // appversion.text.size(15).black.make(),
              // const Spacer(),
              // credits.text.black.fontFamily(semibold).make(),
              // 30.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
