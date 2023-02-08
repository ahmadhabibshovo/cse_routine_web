import 'package:flutter/material.dart';
import 'package:cse_routine_web/Screens/show_data.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required this.textFontSize,
    required this.btitle,
    required this.show,
    required this.abtitle,
  }) : super(key: key);

  final double textFontSize;
  final String btitle;
  final String abtitle;
  final List<Widget> show;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        onPressed: () async {
          Fluttertoast.showToast(
            msg: "Loading.. \nPlease Wait",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 20.0,
            webPosition: "center",
            webBgColor: "linear-gradient(to right, #203020, #204030)",
            webShowClose: true,
          );
          await Future.delayed(const Duration(seconds: 1), () {});

          Get.to(
            ShowData(
              show: show,
              title: abtitle,
            ),
          );
        },
        child: Text(
          '\n$btitle\n',
          style: TextStyle(
              color: Colors.white,
              fontSize: textFontSize,
              fontFamily: "Uchen",
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
