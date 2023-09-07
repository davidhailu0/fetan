import 'package:connectivity/connectivity.dart';
import 'package:fetan2/Registration.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Scanner.dart';

class BanPage extends StatelessWidget {
  TextEditingController banController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Ban"),
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
                controller: banController,
                cursorColor: Color(0xFF0A0E21),
                decoration: InputDecoration(
                    hintText: "Enter the Id of the Student",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF0A0E21)))),
              ),
              SizedBox(height: 30),
              MyButton(
                  text: "Ban",
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
                      var url = Uri.parse(
                          "https://bycicle.herokuapp.com/station/banne");
                      var response = await http
                          .put(url, body: {"id": banController.value.text});
                      if (response.body.contains("False")) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text("Something went wrong"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("Banning the Student Failed")
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.pop(context);
                                        },
                                        child: Text("Ok"))
                                  ],
                                ));
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text("Success"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("banning the Student Successful")
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.pop(context);
                                        },
                                        child: Text("Ok"))
                                  ],
                                ));
                      }
                    }
                  }),
            ],
          ),
        )));
  }
}
