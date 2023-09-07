import 'package:connectivity/connectivity.dart';
import 'package:fetan2/Scanner.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class PaymentPage extends StatefulWidget {
  final String fee;
  final String barcode;
  final String username;
  PaymentPage({this.fee, this.barcode, this.username});
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool submit = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Your fee is",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Color(0xFF0A0E21),
            brightness: Brightness.light),
        body: ModalProgressHUD(
          inAsyncCall: submit,
          child: SafeArea(
              child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Your Fee is ${widget.fee} Birr",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyButton(
                      text: "Paid",
                      pressed: () async {
                        setState(() {
                          submit = true;
                        });
                        var result = await Connectivity().checkConnectivity();
                        if (result != ConnectivityResult.mobile &&
                            result != ConnectivityResult.wifi) {
                          setState(() {
                            submit = false;
                          });
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text("Something went wrong"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                          var url = Uri.parse(
                              "https://bycicle.herokuapp.com/station/paid");
                          var response = await http.post(url, body: {
                            "username": widget.username,
                            "barcode": widget.barcode,
                            "ispaid": "true",
                            "paidAmount": widget.fee
                          });
                          setState(() {
                            submit = false;
                          });
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text("Successfully paid"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "The customer has paid it's charge fee")
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
                      },
                    ),
                    MyButton(
                      text: "Unpaid",
                      pressed: () async {
                        setState(() {
                          submit = true;
                        });
                        var result = await Connectivity().checkConnectivity();
                        if (result != ConnectivityResult.mobile &&
                            result != ConnectivityResult.wifi) {
                          setState(() {
                            submit = false;
                          });
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text("Something went wrong"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                          var url = Uri.parse(
                              "https://bycicle.herokuapp.com/station/paid");
                          var response = await http.post(url, body: {
                            "username": widget.username,
                            "barcode": widget.barcode,
                            "ispaid": "false",
                            "paidAmount": widget.fee
                          });
                          setState(() {
                            submit = false;
                          });
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text("Added to debit"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "since the user hasn't paid it has been added to it's debit")
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
                      },
                    )
                  ],
                )
              ],
            ),
          )),
        ));
  }
}
