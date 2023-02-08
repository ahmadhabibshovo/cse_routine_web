import 'package:cse_routine_web/Screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cse_routine_web/global.dart' as globe;
import 'package:cse_routine_web/Componants/rounded_button.dart';

import 'package:cse_routine_web/functions.dart';
import 'navigator_2.dart';

@override
class Navigate extends StatefulWidget {
  const Navigate({Key? key}) : super(key: key);

  @override
  State<Navigate> createState() => _NavigateState();
}

class _NavigateState extends State<Navigate> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    double textFontSize = height / 43;
    return FutureBuilder<dynamic>(
        future: getData(), // async work
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Title(
            color: globe.color,
            title: "Navigator",
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text('Cse Class Routine'),
              ),
              body: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 16),
                            child: Text(
                              " User : ${globe.batch}\nUpadetd on : ${globe.updated.substring(0, 10)}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(15),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  Get.offAll(const HomePage());
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.clear();
                                  globe.satRoutine = [];
                                  globe.sunRoutine = [];
                                  globe.monRoutine = [];
                                  globe.tueRoutine = [];
                                  globe.wedRoutine = [];
                                  globe.satRoutineWidgets = [];
                                  globe.sunRoutineWidgets = [];
                                  globe.monRoutineWidgets = [];
                                  globe.tueRoutineWidgets = [];
                                  globe.wedRoutineWidgets = [];
                                  globe.satRoutineEmpty = [];
                                  globe.sunRoutineEmpty = [];
                                  globe.monRoutineEmpty = [];
                                  globe.tueRoutineEmpty = [];
                                  globe.wedRoutineEmpty = [];
                                  globe.satRoutineWidgetsEmpty = [];
                                  globe.sunRoutineWidgetsEmpty = [];
                                  globe.monRoutineWidgetsEmpty = [];
                                  globe.tueRoutineWidgetsEmpty = [];
                                  globe.wedRoutineWidgetsEmpty = [];
                                },
                                child: const Text('SignOut',
                                    style: TextStyle(color: Colors.red))),
                          )
                        ],
                      ),
                    ),
                    if (globe.satRoutineWidgets.isNotEmpty)
                      Expanded(
                        flex: 6,
                        child: RoundedButton(
                          textFontSize: textFontSize,
                          show: globe.satRoutineWidgets,
                          btitle: "Saturday",
                          abtitle: "Saturday Routine",
                        ),
                      ),
                    if (globe.sunRoutineWidgets.isNotEmpty)
                      Expanded(
                        flex: 6,
                        child: RoundedButton(
                          textFontSize: textFontSize,
                          btitle: "Sunday",
                          show: globe.sunRoutineWidgets,
                          abtitle: "Sunday Routine",
                        ),
                      ),
                    if (globe.monRoutineWidgets.isNotEmpty)
                      Expanded(
                        flex: 6,
                        child: RoundedButton(
                          textFontSize: textFontSize,
                          btitle: "Monday",
                          show: globe.monRoutineWidgets,
                          abtitle: "Monday Routine",
                        ),
                      ),
                    if (globe.tueRoutineWidgets.isNotEmpty)
                      Expanded(
                        flex: 6,
                        child: RoundedButton(
                          textFontSize: textFontSize,
                          btitle: "Tuesday",
                          show: globe.tueRoutineWidgets,
                          abtitle: "Tuesday Routine",
                        ),
                      ),
                    if (globe.wedRoutineWidgets.isNotEmpty)
                      Expanded(
                        flex: 6,
                        child: RoundedButton(
                          textFontSize: textFontSize,
                          btitle: "Wednesday",
                          show: globe.wedRoutineWidgets,
                          abtitle: "Wednesday Routine",
                        ),
                      ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Get.to(const Navigate2());
                          },
                          child: Text(
                            '\nEmpty Room\n',
                            style: TextStyle(fontSize: textFontSize),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () async {
                          launchUrl(Uri.parse(
                              'https://ahmadhabibshovo.github.io/#section-contact'));
                        },
                        child: const Text(
                          'Made with love by Ahmmad Habib\nClick here for contact',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
