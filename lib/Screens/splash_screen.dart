import 'dart:async';
import 'package:get/get.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:cse_routine_web/Screens/login_screen.dart';
import 'navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cse_routine_web/global.dart' as global;
import 'package:cse_routine_web/functions.dart';

String? userSID;

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  Future getValidationData() async {
    global.bytes = await downloadFile();
    final prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString("ID");

    setState(() {
      userSID = userId;
    });
  }

  @override
  void initState() {
    getValidationData().whenComplete(() async {
      Timer(const Duration(seconds: 1), () {
        Get.offAll(userSID == null ? const HomePage() : const Navigate());
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Title(
        color: global.color,
        title: "Loading",
        child: EasySplashScreen(
          backgroundColor: Colors.black12,
          loaderColor: Colors.white,
          logo: const Image(
            image: AssetImage('assets/transparent.png'),
          ),
          // backgroundImage: const AssetImage("assets/Daily-Routine.png"),
          title: const Text(
            "",
          ),
          showLoader: true,
          loadingText: const Text(
            "Loading...",
            style: TextStyle(color: Colors.white),
          ),
          durationInSeconds: 1,
        ));
  }
}
