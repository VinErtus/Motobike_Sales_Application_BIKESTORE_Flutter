import 'package:bikestore/app/page/SplashScreen/splash_screen.dart';
import 'package:bikestore/app/page/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/page/auth/login.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      // initialRoute: "/",
      // onGenerateRoute: AppRoute.onGenerateRoute,  -> su dung auto route (pushName)
    );
  }
}
