import 'package:http/http.dart' as http;
import 'global.dart' as globe;
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<dynamic> downloadFile() async {
  http.Response response = await http.get(
    Uri.parse(
        'https://docs.google.com/spreadsheets/d/10xq4I6JjTGGKW-vqFlJtTimF2HtRm-TLPJ_FlhjJvkk/export?format=xlsx'),
  );
  return response.bodyBytes;
}

void addRoutine(dayRoutineText, List<Widget> dayRoutineWidgets) async {
  for (int i = 0; i < dayRoutineText.length; i++) {
    final splitted = dayRoutineText[i].split('\n');
    dayRoutineWidgets.add(
      Card(
        margin: const EdgeInsets.all(10),
        elevation: 6,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              children: [
                Text(
                  splitted[0],
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                      fontFamily: "Uchen",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  splitted[1],
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                      fontFamily: "Uchen",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  splitted[2],
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                      fontFamily: "Uchen",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  splitted[3],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: "Uchen",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  splitted[4],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: "Uchen",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List courseDetails(cell) {
  int start = -1;
  int end = -1;
  int stop = -1;

  for (var i = 0; i < cell.length; i++) {
    if (start == -1 && cell[i].contains(RegExp(r'[A-Z]'))) {
      start = i;
    }
    if (start != -1 && cell[i] == "/" && end == -1) {
      end = i;
      i += 2;
    }
    if (end != -1 && cell[i] == "/" && stop == -1) {
      stop = i;
    }
  }
  if (stop == -1) {
    stop = cell.length;
    if (cell.contains(".")) {
      stop--;
    }
  }
  String courseCode = cell.substring(start, end);
  String lab = "";
  String courseBatch = cell.substring(0, start - 1);
  courseBatch = courseBatch.replaceAll('/', ' , ');
  if (cell.contains("Lab")) {
    lab = "Lab";
  }
  String courseTeacher = cell.substring(end + 1, stop);
  return [courseCode, courseBatch, courseTeacher, lab];
}

void addData(
    String day, String time, String room, String cell, String dayS, store) {
  if (day.contains(dayS)) {
    var list = courseDetails(cell);
    String margevalue =
        "$time  Room:$room \nBatch :  ${list[1]}\nCourse Code : ${list[0]} ${list[3]}\n${globe.courseNameJson[list[0]]}\n${globe.teacherNameJson[list[2]]} ";

    store.add(margevalue);
  }
}

void addDataEmpty(String day, String time, String room, String dayS, store) {
  if (day.contains(dayS)) {
    String margevalue = "$time    \nRoom: $room  ";
    store.add(margevalue);
  }
}

Future<bool> launchUrl(
  Uri url, {
  LaunchMode mode = LaunchMode.platformDefault,
  WebViewConfiguration webViewConfiguration = const WebViewConfiguration(),
  String? webOnlyWindowName,
}) async {
  if (mode == LaunchMode.inAppWebView &&
      !(url.scheme == 'https' || url.scheme == 'http')) {
    throw ArgumentError.value(url, 'url',
        'To use an in-app web view, you must provide an http(s) URL.');
  }
  return UrlLauncherPlatform.instance.launchUrl(
    url.toString(),
    LaunchOptions(
      // mode: convertLaunchMode(mode),
      // webViewConfiguration: convertConfiguration(webViewConfiguration),
      webOnlyWindowName: webOnlyWindowName,
    ),
  );
}

getData() async {
  addTime(time) {
    String time2 = time.substring(6, 8);
    late String timeUpdated;
    if (time2 != '12') {
      int time1 = int.parse(time2);
      time1++;
      timeUpdated = time1.toString();
    } else {
      timeUpdated = '01';
    }

    timeUpdated = time.replaceRange(6, 8, timeUpdated);
    return timeUpdated;
  }

  bool isRetake(cell, retakel) {
    for (var sub in retakel) {
      if (cell.contains(sub)) {
        return true;
      }
    }
    return false;
  }

  final prefs = await SharedPreferences.getInstance();

  String retk = prefs.getString('RETK').toString();

  var splitted = retk.split(':');

  if (splitted.toString() == "[]") {
    splitted = ["XXXXXXXXXXXXX"];
  }
  final String? batch = prefs.getString('ID');
  globe.batch = batch;
  final String? section = prefs.getString('SEC');
  var excel = Excel.decodeBytes(globe.bytes);
  var sheet = excel['Routine'];
  var sheet2 = excel['Course Info'];
  var sheet3 = excel['Faculty Contact Info'];
  List<String> alpha = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];
  globe.updated = sheet.cell(CellIndex.indexByString('I4')).value.toString();

  for (int i = 0; i < 10; i++) {
    for (int x = 1; x < 51; x++) {
      if (i == 0 && x <= sheet2.maxRows) {
        globe.courseNameJson.addAll({
          sheet2
                  .cell(CellIndex.indexByString('${alpha[i]}$x'))
                  .value
                  .toString()
                  .replaceAll(' ', ''):
              sheet2
                  .cell(CellIndex.indexByString('${alpha[i + 1]}$x'))
                  .value
                  .toString()
        });
      }
      if (i == 1 && x <= sheet3.maxRows) {
        globe.teacherNameJson.addAll({
          sheet3
                  .cell(CellIndex.indexByString('${alpha[i + 2]}$x'))
                  .value
                  .toString()
                  .replaceAll(' ', ''):
              sheet3
                  .cell(CellIndex.indexByString('${alpha[i]}$x'))
                  .value
                  .toString()
        });
      }
      String cell = sheet
          .cell(CellIndex.indexByString('${alpha[i]}$x'))
          .value
          .toString()
          .replaceAll(' ', '');

      String prevcell = 'noddot';
      if (i != 0) {
        prevcell = sheet
            .cell(CellIndex.indexByString('${alpha[i - 1]}$x'))
            .value
            .toString();
      }

      if (cell == 'null' && !prevcell.contains('.') && x >= 6) {
        String time = sheet
            .cell(CellIndex.indexByString('${alpha[i]}5'))
            .value
            .toString();
        String room =
            sheet.cell(CellIndex.indexByString('B$x')).value.toString();
        String day =
            sheet.cell(CellIndex.indexByString('A$x')).value.toString();
        if (day == "null") {
          int y = x;
          for (y; y >= 0; y--) {
            day = sheet.cell(CellIndex.indexByString('A$y')).value.toString();
            if (day != "null") {
              break;
            }
          }
        }
        if (room != 'null' &&
            room != "ROOM" &&
            time != 'null' &&
            time != 'DAY') {
          addDataEmpty(day, time, room, "SAT", globe.satRoutineEmpty);
          addDataEmpty(day, time, room, "SUN", globe.sunRoutineEmpty);
          addDataEmpty(day, time, room, "MON", globe.monRoutineEmpty);
          addDataEmpty(day, time, room, "TUE", globe.tueRoutineEmpty);
          addDataEmpty(day, time, room, "WED", globe.wedRoutineEmpty);
        }
      }

      if ((cell.contains(batch.toString()) &&
              cell.length > 7 &&
              ((cell.substring(cell.length - 3).contains("/F") &&
                      section == "2") ||
                  (cell.substring(cell.length - 3).contains("/M") &&
                      section == "1") ||
                  section == "0")) ||
          isRetake(cell, splitted)) {
        String day =
            sheet.cell(CellIndex.indexByString('A$x')).value.toString();
        //Get DayNames
        if (day == "null") {
          int y = x;
          for (y; y >= 0; y--) {
            day = sheet.cell(CellIndex.indexByString('A$y')).value.toString();
            if (day != "null") {
              break;
            }
          }
        }
        String time = sheet
            .cell(CellIndex.indexByString('${alpha[i]}5'))
            .value
            .toString();
        String room =
            sheet.cell(CellIndex.indexByString('B$x')).value.toString();

        //Valid Times
        if (cell.contains('.')) {
          time = addTime(time);
        }
        addData(day, time, room, cell, "SAT", globe.satRoutine);
        addData(day, time, room, cell, "SUN", globe.sunRoutine);
        addData(day, time, room, cell, "MON", globe.monRoutine);
        addData(day, time, room, cell, "TUE", globe.tueRoutine);
        addData(day, time, room, cell, "WED", globe.wedRoutine);
      }
    }
  }
  addRoutine(globe.satRoutine, globe.satRoutineWidgets);
  addRoutine(globe.sunRoutine, globe.sunRoutineWidgets);
  addRoutine(globe.monRoutine, globe.monRoutineWidgets);
  addRoutine(globe.tueRoutine, globe.tueRoutineWidgets);
  addRoutine(globe.wedRoutine, globe.wedRoutineWidgets);
  addRoutineEmpty(globe.satRoutineEmpty, globe.satRoutineWidgetsEmpty);
  addRoutineEmpty(globe.sunRoutineEmpty, globe.sunRoutineWidgetsEmpty);
  addRoutineEmpty(globe.monRoutineEmpty, globe.monRoutineWidgetsEmpty);
  addRoutineEmpty(globe.tueRoutineEmpty, globe.tueRoutineWidgetsEmpty);
  addRoutineEmpty(globe.wedRoutineEmpty, globe.wedRoutineWidgetsEmpty);
}

void addRoutineEmpty(dayRoutineText, List<Widget> dayRoutineWidgets) {
  for (int i = 0; i < dayRoutineText.length; i++) {
    dayRoutineWidgets.add(
      Card(
        margin: const EdgeInsets.all(10),
        elevation: 6,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Center(
                child: Text(dayRoutineText[i],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "Uchen",
                        fontSize: 20,
                        fontWeight: FontWeight.bold))),
          ),
        ),
      ),
    );
  }
}
