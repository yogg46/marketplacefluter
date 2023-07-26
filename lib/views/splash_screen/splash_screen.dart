import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketplace/auth_screen/login_screen.dart';
import 'package:marketplace/consts/consts.dart';
import 'package:marketplace/home_screen/home.dart';

import '../../consts/colors.dart';
import '../../home_screen/home_screen.dart';
import '../../widget_common/applogo.widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


    changeScreen() {
      Future.delayed(const Duration(seconds: 3), () {

        auth.authStateChanges().listen((User? user) { 
          if (user == null && mounted ){
            Get.to(() => const Home());
          } else {
            Get.to(() => const Home());
          }
        });
      });

    }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greenColor,
      body: Center(
        child: Column(
          children: [
            Align(alignment: Alignment.topLeft,child: Image.asset(icSplashBg, width: 300,)),
            20.heightBox,
            applogoWidget(),
            10.heightBox,
            appname.text.fontFamily(bold).size(22).white.make(),
            5.heightBox,
            appversion.text.white.make(),
            Spacer(),
            credits.text.white.fontFamily(semibold).make(),
            30.heightBox
          ],
        ),
      ),
    );
  }
}