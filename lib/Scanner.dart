import 'dart:convert';

import 'package:fetan2/BanPage.dart';
import 'package:fetan2/ConfirmationPage.dart';
import 'package:fetan2/PaymentTextField.dart';
import 'package:fetan2/Registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

import 'PaymentPage.dart';
import 'UnbanPage.dart';

class Scanner extends StatefulWidget {
  final String username;
  Scanner({this.username});
  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  var barCode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.username),
          backgroundColor: Color(0xFF0A0E21),
          brightness: Brightness.light,
        ),
        drawer: Drawer(
            child: ListView(
          children: [
            DrawerHeader(
              child: Text('Register and Serve Users'),
              decoration: BoxDecoration(
                color: Color(0xFF0A0E21),
              ),
            ),
            ListTile(
              title: Text("Logout"),
              onTap: () async {
                var url = "https://bycicle.herokuapp.com/station/logout";
                Navigator.pop(context);
                Navigator.pop(context);
                await http.get(url);
              },
            )
          ],
        )),
        body: SafeArea(
            child: Container(
                alignment: Alignment.center,
                height: 530,
                width: 320,
                margin: EdgeInsets.only(top: 80, left: 20, right: 20),
                padding:
                    EdgeInsets.only(top: 50, left: 50, right: 50, bottom: 20),
                child: Column(
                  children: [
                    Expanded(
                      child: MyButton(
                          text: "Register new Customer",
                          pressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegistrationPage()));
                          }),
                    ),
                    SizedBox(height: 30),
                    Expanded(
                      child: MyButton(
                        text: "Serve a Customer",
                        pressed: () async {
                          try {
                            barCode = await FlutterBarcodeScanner.scanBarcode(
                                "#7600ec", "Cancel", true, ScanMode.BARCODE);
                            var url =
                                Uri.parse("https://bycicle.herokuapp.com/who");
                            var response = await http
                                .post(url, body: {"barcode": barCode});
                            var data = jsonDecode(response.body);
                            var response2 = await http
                                .post("https://bycicle.herokuapp.com/was_it");
                            if (response2.body.contains("true")) {
                              url = Uri.parse(
                                  'https://bycicle.herokuapp.com/station/stop');
                              response = await http
                                  .post(url, body: {'barcode': barCode});
                              var fee = jsonDecode(response.body);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PaymentPage(
                                            fee: fee['fee'],
                                            barcode: barCode,
                                            username: widget.username,
                                          )));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ConfirmationPage(
                                            data: data,
                                            barcode: barCode,
                                            username: widget.username,
                                          )));
                            }
                          } on Exception {
                            print("There is an error");
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    Expanded(
                      child: MyButton(
                          text: "Pay Credit",
                          pressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PaymentTextField(
                                          username: widget.username,
                                        )));
                          }),
                    ),
                    SizedBox(height: 30),
                    Expanded(
                      child: MyButton(
                          text: "Ban a Customer",
                          pressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BanPage()));
                          }),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: MyButton(
                        text: "Unban a Customer",
                        pressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UnbanPage()));
                        },
                      ),
                    )
                  ],
                ))));
  }
}

class MyButton extends StatelessWidget {
  final String text;
  final Function pressed;
  MyButton({this.text, this.pressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Color(0xFF0A0E21),
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
