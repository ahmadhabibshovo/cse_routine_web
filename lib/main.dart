import 'package:cse_routine_web/Screens/main_menu.dart';
import 'package:flutter/material.dart';
import 'global.dart' as global;
import 'package:get/get.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      color: global.color,
      title: 'MIU Routine APP',
      theme: ThemeData.dark(useMaterial3: true),
      home: const Menu(),
    );
  }
}
