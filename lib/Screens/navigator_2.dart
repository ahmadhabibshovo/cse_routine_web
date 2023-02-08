import 'package:flutter/material.dart';
import 'package:cse_routine_web/Componants/rounded_button.dart';
import 'package:cse_routine_web/global.dart' as globe;

class Navigate2 extends StatelessWidget {
  const Navigate2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    double textFontSize = height / 43;
    return Title(
      color: globe.color,
      title: "Empty Room",
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Empty Rooms'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: RoundedButton(
                  textFontSize: textFontSize,
                  btitle: "Saturday",
                  show: globe.satRoutineWidgetsEmpty,
                  abtitle: "Saturday Empty Rooms"),
            ),
            Expanded(
              child: RoundedButton(
                  textFontSize: textFontSize,
                  btitle: "Sunday",
                  show: globe.sunRoutineWidgetsEmpty,
                  abtitle: "Sunday Empty Rooms"),
            ),
            Expanded(
              child: RoundedButton(
                  textFontSize: textFontSize,
                  btitle: "Monday",
                  show: globe.monRoutineWidgetsEmpty,
                  abtitle: "Monday Empty Rooms"),
            ),
            Expanded(
              child: RoundedButton(
                  textFontSize: textFontSize,
                  btitle: "Tuesday",
                  show: globe.tueRoutineWidgetsEmpty,
                  abtitle: "Tuesday Empty Rooms"),
            ),
            Expanded(
              child: RoundedButton(
                  textFontSize: textFontSize,
                  btitle: "Wednesday",
                  show: globe.wedRoutineWidgetsEmpty,
                  abtitle: "Wednesday Empty Rooms"),
            ),
          ],
        ),
      ),
    );
  }
}
