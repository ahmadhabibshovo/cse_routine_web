import 'package:flutter/material.dart';
import 'package:cse_routine_web/global.dart' as globe;
import 'package:cse_routine_web/functions.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:loadingkit_flutter/loadingkit_flutter.dart';

class AvailableRooms extends StatefulWidget {
  const AvailableRooms({super.key});

  @override
  State<AvailableRooms> createState() => _AvailableRoomsState();
}

final TextEditingController _searchController = TextEditingController();

var date = DateTime.now();
String todayName = gTodayName();
String todayhour = gTodayHour();

String gTodayHour() {
  String time = DateFormat('j').format(date);

  if (time.contains('PM')) {
    time = time.replaceAll("PM", "");
  } else {
    time = time.replaceAll("AM", "");
  }
  time = time.trim();
  if (time.length == 1) {
    return "0$time".trim();
  }

  return time;
}

String gTodayName() {
  String day = DateFormat('E').format(date);
  if (day == "Thu" || day == "Fri") {
    return "Sat";
  }
  return day;
}

class _AvailableRoomsState extends State<AvailableRooms> {
  List<String> dayName = ["Sat", "Sun", "Mon", "Tue", "Wed"];
  List<String> today() {
    List<String> temp = [...dayName];

    String tempDayName = temp.removeAt(temp.indexOf(todayName));
    temp.insert(0, tempDayName);
    return temp;
  }

  List<String> rawWidget() {
    if (selected == "Sat") {
      return globe.satRoutineEmpty;
    }
    if (selected == "Sun") {
      return globe.sunRoutineEmpty;
    }
    if (selected == "Mon") {
      return globe.monRoutineEmpty;
    }
    if (selected == "Tue") {
      return globe.tueRoutineEmpty;
    }
    return globe.wedRoutineEmpty;
  }

  List<String> showWidget() {
    List<String> raw = [...rawWidget()];
    if (raw.every((element) {
      return element.substring(0, 2) == todayhour;
    })) {
      int index =
          raw.indexWhere((element) => element.substring(0, 2) == todayhour);

      List<String> temp = raw.sublist(index, raw.length);
      raw.removeRange(index, raw.length);
      raw.insertAll(0, temp);
    }

    return raw;
  }

  List<String> data = [];

  dynamic looded = false;
  String selected = todayName;
  Future availableRoom() async {
    globe.bytes = await downloadFile();
    var excel = Excel.decodeBytes(globe.bytes);
    var sheet = excel['Routine'];

    List<String> alpha = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];
    for (int i = 0; i < 10; i++) {
      for (int x = 1; x < 51; x++) {
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
      }
    }
  }

  @override
  void initState() {
    // todayhour = gTodayHour();
    // todayName = gTodayName();

    // print(gTodayName());
    // print(gTodayHour());

    availableRoom().whenComplete(() {
      setState(() {
        looded = true;
        data = showWidget();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Room"),
      ),
      body: !looded
          ? const Center(
              child: FlutterLoading(
                  isLoading: true, color: Colors.green, child: Text('Loading')),
            )
          : Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: today().map((e) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            selected = e;
                            data = showWidget();
                          });
                        },
                        child: Expanded(
                          child: Card(
                            color: selected == e
                                ? ThemeData().primaryColor
                                : Colors.blueGrey,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(e),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Add a search icon or button outside the border of the search bar
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {},
                    ),
                    Expanded(
                      // Use a Material design search bar
                      child: TextField(
                        onChanged: (value) {
                          data = showWidget();
                          if (value.length == 1) {
                            if (value.isNotEmpty) {
                              data.removeWhere((element) {
                                return !element
                                    .toString()
                                    .substring(0, 2)
                                    .contains("0${value.toString()}");
                              });
                            } else {}
                          } else {
                            if (value.isNotEmpty) {
                              data.removeWhere((element) {
                                return !element
                                    .toString()
                                    .substring(0, 2)
                                    .contains(value.toString());
                              });
                            } else {}
                          }
                          setState(() {});
                        },
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          // Add a clear button to the search bar
                          suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  data = showWidget();
                                });
                              }),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20),
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int x) {
                      return Card(
                        child: Center(
                          child: Text(
                            data[x],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      );
                    }),
              )
            ]),
    );
  }
}
