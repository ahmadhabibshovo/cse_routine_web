import 'package:cse_routine_web/Screens/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'navigator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cse_routine_web/global.dart' as globe;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

String? path;

class _HomePageState extends State<HomePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController retakeController = TextEditingController();

  bool isNumeric(String s) {
    if (s.toString() == '') {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  void initState() {
    super.initState();
  }

  int? _value = 0;
  List<String> item = ["Combine", "Male", "Female"];
  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    return Title(
      color: globe.color,
      title: "Login Page",
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Student Routine")),
          leading: IconButton(
              onPressed: () {
                Get.to(const Menu());
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            Color.fromARGB(255, 47, 61, 68),
            Color.fromARGB(255, 43, 57, 63)
          ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 80,
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "MIU Routine CSE",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "You are Welcome",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // const Text(
                                //   'Section',
                                // ),
                                // const SizedBox(height: 10.0),
                                Wrap(
                                  spacing: 5.0,
                                  children: List<Widget>.generate(
                                    3,
                                    (int index) {
                                      return ChoiceChip(
                                        selectedColor: Colors.blueGrey.shade400,
                                        label: Text(item[index]),
                                        selected: _value == index,
                                        onSelected: (bool selected) {
                                          setState(() {
                                            _value = selected ? index : null;
                                          });
                                        },
                                      );
                                    },
                                  ).toList(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom:
                                              BorderSide(color: Colors.white))),
                                  child: TextField(
                                    onChanged: (e) {
                                      nameController.text = e.toUpperCase();
                                      nameController.selection =
                                          TextSelection.collapsed(
                                              offset:
                                                  nameController.text.length);
                                    },
                                    autofocus: true,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    controller: nameController,
                                    decoration: const InputDecoration(
                                        labelText: 'Enter Your Batch No',
                                        hintText: 'Ex.  50 , 56 , 60',
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        hintStyle:
                                            TextStyle(color: Colors.white38),
                                        border: InputBorder.none),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.transparent))),
                                  child: TextField(
                                    controller: retakeController,
                                    onChanged: (e) {
                                      retakeController.text = e.toUpperCase();
                                      retakeController.selection =
                                          TextSelection.collapsed(
                                              offset:
                                                  retakeController.text.length);
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Retake or Extra Course',
                                      hintText: 'Ex. CSE314 or  CSE314:CSE443 ',
                                      hintStyle:
                                          TextStyle(color: Colors.white38),
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // const SizedBox(
                          //   height: 40,
                          // ),
                          const SizedBox(
                            height: 30,
                          ),
                          InkWell(
                            onTap: clicked
                                ? null
                                : () async {
                                    nameController.text =
                                        nameController.text.replaceAll(' ', '');
                                    retakeController.text = retakeController
                                        .text
                                        .replaceAll(' ', '');
                                    final prefs =
                                        await SharedPreferences.getInstance();

                                    await prefs.setString('RETK',
                                        retakeController.text.toString());
                                    await prefs.setString(
                                        'SEC', _value.toString());

                                    if (isNumeric(nameController.text)) {
                                      if (int.parse(nameController.text) >=
                                          50) {
                                        setState(() {
                                          clicked = true;
                                        });
                                        Fluttertoast.showToast(
                                          msg: "Loading.. \nPlease Wait",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 3,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 20.0,
                                          webPosition: "center",
                                          webBgColor:
                                              "linear-gradient(to right, #203020, #204030)",
                                        );
                                        await Future.delayed(
                                            const Duration(seconds: 1), () {});
                                        await prefs.setString(
                                            'ID', nameController.text);
                                        // ignore: use_build_context_synchronously

                                        Get.offAll(const Navigate());
                                      }
                                    } else {
                                      if (nameController.text.toString() !=
                                          "") {
                                        setState(() {
                                          clicked = true;
                                        });

                                        Fluttertoast.showToast(
                                          msg: "Loading.. \nPlease Wait",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 3,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 20.0,
                                          webPosition: "center",
                                          webBgColor:
                                              "linear-gradient(to right, #203020, #204030)",
                                        );
                                        await Future.delayed(
                                            const Duration(seconds: 1), () {});
                                        await prefs.setString(
                                            'ID', nameController.text);

                                        // ignore: use_build_context_synchronously

                                        Get.offAll(const Navigate());
                                      }
                                    }
                                  },
                            child: Container(
                              height: 50,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color:
                                      const Color.fromARGB(255, 17, 73, 119)),
                              child: const Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          // const Text(
                          //   "Continue with social media",
                          //   style: TextStyle(color: Colors.grey),
                          // ),
                          // const SizedBox(
                          //   height: 30,
                          // ),
                          // Row(
                          //   children: <Widget>[
                          //     Expanded(
                          //       child: Container(
                          //         height: 50,
                          //         decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.circular(50),
                          //             color: Colors.blue),
                          //         child: const Center(
                          //           child: Text(
                          //             "Facebook",
                          //             style: TextStyle(
                          //                 color: Colors.white,
                          //                 fontWeight: FontWeight.bold),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //     const SizedBox(
                          //       width: 30,
                          //     ),
                          //     Expanded(
                          //       child: Container(
                          //         height: 50,
                          //         decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.circular(50),
                          //             color: Colors.black),
                          //         child: const Center(
                          //           child: Text(
                          //             "Github",
                          //             style: TextStyle(
                          //                 color: Colors.white,
                          //                 fontWeight: FontWeight.bold),
                          //           ),
                          //         ),
                          //       ),
                          //     )
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
