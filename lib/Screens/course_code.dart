import 'package:flutter/material.dart';
import 'package:cse_routine_web/functions.dart';
import 'package:cse_routine_web/global.dart' as globe;
import 'package:excel/excel.dart';
import 'package:loadingkit_flutter/loadingkit_flutter.dart';

class CourseCode extends StatefulWidget {
  const CourseCode({super.key});

  @override
  State<CourseCode> createState() => _CourseCodeState();
}

final TextEditingController _searchController = TextEditingController();

class _CourseCodeState extends State<CourseCode> {
  Future _download() async {
    globe.bytes = await downloadFile();
    var excel = Excel.decodeBytes(globe.bytes);
    var sheet2 = excel['Course Info'];
    List<String> alpha = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];
    for (int i = 0; i < 1; i++) {
      for (int x = 1; x < sheet2.maxRows; x++) {
        globe.course.add(
            "${sheet2.cell(CellIndex.indexByString('${alpha[i]}$x')).value.toString().replaceAll(' ', '')} -> ${sheet2.cell(CellIndex.indexByString('${alpha[i + 1]}$x')).value.toString()}");
      }
    }
  }

  bool _lodding = false;
  List courseData = [];
  List<String> filterData() {
    List<String> filtered = [...globe.course];
    filtered.removeWhere((element) {
      return !element
          .toUpperCase()
          .contains(_searchController.text.toUpperCase());
    });

    return filtered;
  }

  @override
  void initState() {
    _download().whenComplete(() {
      setState(() {
        courseData = filterData();
        _lodding = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Course Info")),
      ),
      body: !_lodding
          ? const Center(
              child: FlutterLoading(
                  isLoading: true, color: Colors.green, child: Text('Loading')),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
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
                              setState(() {
                                courseData = filterData();
                              });
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
                                      courseData = filterData();
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
                  DataTable(
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Code',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                      ],
                      rows: List<DataRow>.generate(courseData.length, (index) {
                        return DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Text(
                                courseData[index],
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
                      }))
                ],
              ),
            ),
    );
  }
}
