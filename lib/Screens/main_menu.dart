import 'package:cse_routine_web/Screens/available_room.dart';
import 'package:cse_routine_web/Screens/contacts.dart';
import 'package:cse_routine_web/Screens/course_code.dart';
import 'package:cse_routine_web/Screens/splash_screen.dart';
import 'package:cse_routine_web/Screens/t_splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("MIU CONVERGENCE")),
        ),
        body: Column(
          children: [
            // const Row(
            //   children: [Text("Manarat International Universdity")],
            // ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(const TSplashPage());
                    },
                    child: const Card(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.school,
                            size: 80,
                          ),
                          Text("Teachers Class Routine")
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(const SplashPage());
                    },
                    child: const Card(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_box,
                            size: 80,
                          ),
                          Text("Student Class Routine")
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(const AvailableRooms());
                    },
                    child: const Card(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home,
                            size: 80,
                          ),
                          Text("Available Rooms")
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(const Contacts());
                    },
                    child: const Card(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.contacts,
                            size: 80,
                          ),
                          Text("Teachers Contacts")
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(const CourseCode());
                    },
                    child: const Card(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info,
                            size: 80,
                          ),
                          Text("Course Info")
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Card(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bus_alert,
                            size: 80,
                          ),
                          Text("Bus Schedule")
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
