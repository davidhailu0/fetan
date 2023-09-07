import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class ConfirmationPage extends StatefulWidget {
  final data;
  final barcode;
  final username;
  ConfirmationPage(
      {@required this.data, @required this.barcode, @required this.username});
  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Customer Info",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          backgroundColor: Color(0xFF0A0E21),
          brightness: Brightness.light,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
                "https://bycicle.herokuapp.com/photos/" + widget.data['url'],
                height: 200,
                width: 150),
            SizedBox(
              height: 30,
            ),
            Text(widget.data['name']),
            SizedBox(
              height: 30,
            ),
            Text(widget.data['id']),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyButton2(
                  text: "Confirm",
                  pressed: () async {
                    var result = await Connectivity().checkConnectivity();
                    if (result != ConnectivityResult.wifi &&
                        result != ConnectivityResult.mobile) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: Text("Something went wrong"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Please check your internet connection")
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Ok"))
                                ],
                              ));
                    } else {
                      try {
                        var url = Uri.parse(
                            'https://bycicle.herokuapp.com/station/start');
                        var response = await http
                            .post(url, body: {'barcode': widget.barcode});
                        var data = jsonDecode(response.body);
                        if (data['msg'] != null) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text("Something went wrong"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [Text(data['msg'])],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Ok"))
                                    ],
                                  ));
                        }
                      } on Exception {
                        print("There is an error");
                      }
                    }
                  },
                  color: Colors.greenAccent,
                ),
                SizedBox(
                  width: 25,
                ),
                MyButton2(
                    text: "Decline",
                    pressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.redAccent)
              ],
            )
          ],
        )));
  }
}

class MyButton2 extends StatelessWidget {
  final String text;
  final Function pressed;
  final Color color;
  MyButton2({this.text, this.pressed, this.color});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: this.color,
      textColor: Colors.white,
      minWidth: 120,
      elevation: 5.0,
      child: Padding(padding: EdgeInsets.all(15), child: Text(this.text)),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
      onPressed: this.pressed,
    );
  }
}
