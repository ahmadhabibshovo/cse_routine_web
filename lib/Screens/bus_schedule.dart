import 'package:flutter/material.dart';
import 'package:cse_routine_web/global.dart' as globe;
import 'package:excel/excel.dart';
import 'package:cse_routine_web/functions.dart';
import 'package:loadingkit_flutter/loadingkit_flutter.dart';

class BusSc extends StatefulWidget {
  const BusSc({super.key});

  @override
  State<BusSc> createState() => _BusScState();
}

class _BusScState extends State<BusSc> {
  Future download() async {
    globe.bytes = await downloadFile();
    var excel = Excel.decodeBytes(globe.bytes);
    var sheet3 = excel['Bus Schedule'];
    List<String> alpha = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];
    for (int i = 0; i < 1; i++) {
      for (int x = 1; x < sheet3.maxRows; x++) {
        globe.course.add(
            "${sheet2.cell(CellIndex.indexByString('${alpha[i]}$x')).value.toString().replaceAll(' ', '')} -> ${sheet2.cell(CellIndex.indexByString('${alpha[i + 1]}$x')).value.toString()}");
      }
    }
  }

  bool load = false;
  @override
  void initState() {
    download().whenComplete(() {
      setState(() {
        load = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Bus Schedule")),
      ),
      body: !load
          ? const Center(
              child: FlutterLoading(
                  isLoading: true, color: Colors.green, child: Text('Loading')),
            )
          : Image.network(
              globe.busscimg,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
    );
  }
}
