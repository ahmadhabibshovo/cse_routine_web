import 'package:flutter/material.dart';
import 'package:cse_routine_web/global.dart' as globe;
import 'package:excel/excel.dart';
import 'package:cse_routine_web/global.dart' as global;
import 'package:cse_routine_web/functions.dart';
import 'package:loadingkit_flutter/loadingkit_flutter.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

final TextEditingController _searchController = TextEditingController();

class _ContactsState extends State<Contacts> {
  Future download() async {
    global.bytes = await downloadFile();
    var excel = Excel.decodeBytes(globe.bytes);
    var sheet3 = excel['Faculty Contact Info'];
    List<String> alpha = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];
    for (int i = 1; i < 2; i++) {
      for (int x = 2; x < sheet3.maxRows; x++) {
        globe.contacts.add([
          sheet3
              .cell(CellIndex.indexByString('${alpha[i]}$x'))
              .value
              .toString(),
          sheet3
              .cell(CellIndex.indexByString('${alpha[i + 2]}$x'))
              .value
              .toString(),
          "0${sheet3.cell(CellIndex.indexByString('${alpha[i + 3]}$x')).value.toString()}"
        ]);
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

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _makeMessages(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !load
          ? const Center(
              child: FlutterLoading(
                  isLoading: true, color: Colors.green, child: Text('Loading')),
            )
          : Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Add a search icon or button outside the border of the search bar
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(() {});
                      },
                    ),
                    Expanded(
                      // Use a Material design search bar
                      child: TextField(
                        onChanged: (value) {
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
                                setState(() {});
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
                child: SingleChildScrollView(
                  child: Column(
                    children: globe.contacts.map((e) {
                      return !e[0].toString().toUpperCase().contains(
                              _searchController.text.toString().toUpperCase())
                          ? const SizedBox()
                          : Card(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        child: Icon(Icons.person),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        children: [
                                          Text(e[0]),
                                          Text(e[2]),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        child: const Icon(Icons.call),
                                        onTap: () {
                                          _makePhoneCall(e[2]);
                                        },
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      InkWell(
                                        child: const Icon(Icons.message),
                                        onTap: () {
                                          _makeMessages(e[2]);
                                        },
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      InkWell(
                                        child: const Icon(Icons.mail),
                                        onTap: () {},
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                    }).toList(),
                  ),
                ),
              )
            ]),
    );
  }
}
