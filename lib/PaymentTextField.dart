import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'Registration.dart';
import 'Scanner.dart';

class PaymentTextField extends StatefulWidget {
  final String username;
  PaymentTextField({this.username});
  @override
  _PaymentTextFieldState createState() => _PaymentTextFieldState();
}

class _PaymentTextFieldState extends State<PaymentTextField> {
  TextEditingController paymentText = TextEditingController();
  String barcode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Pay Debit",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
            backgroundColor: Color(0xFF0A0E21),
            brightness: Brightness.light),
        body: SafeArea(
            child: Container(
          alignment: Alignment.center,
          height: 530,
          width: 320,
          margin: EdgeInsets.only(top: 80, left: 20, right: 20),
          padding: EdgeInsets.only(top: 50, left: 60, right: 60, bottom: 20),
          child: ListView(
            children: [
              TextField(
                controller: paymentText,
                cursorColor: Color(0xFF0A0E21),
                decoration: InputDecoration(
                    hintText: "Enter Paid Amount",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF0A0E21)))),
              ),
              SizedBox(height: 30),
              MyButton(
                  text: "Pay Debit",
                  pressed: () async {
                    var result = await Connectivity().checkConnectivity();
                    if (result != ConnectivityResult.mobile &&
                        result != ConnectivityResult.wifi) {
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
                        barcode = await FlutterBarcodeScanner.scanBarcode(
                            "#7600ec", "Cancel", true, ScanMode.BARCODE);
                        var url = Uri.parse(
                            'https://bycicle.herokuapp.com/station/pay_creadit');
                        var response = await http.post(url, body: {
                          "username": widget.username,
                          "barcode": barcode,
                          "paidAmount": paymentText.value.text
                        });
                        var data = jsonDecode(response.body);
                        if (data['msg'] == "The customer is not reigstored") {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text("Incorrect Barcode"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                            "There is no customer registered is with this barcode")
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
                        } else if (data['msg'] == "The customer creadit is 0") {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text("Nothing to pay"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text("The customer has no debit")
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
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text("Successfully Paid the debit"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                            "The customer has successfully paid the debit")
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
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
                  }),
            ],
          ),
        )));
  }
}
