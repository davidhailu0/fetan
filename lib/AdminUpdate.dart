import 'package:connectivity/connectivity.dart';
import "package:flutter/material.dart";

import 'Registration.dart';
import 'Scanner.dart';
import 'package:http/http.dart' as http;

class AdminUpdate extends StatefulWidget {
  final String username;
  AdminUpdate({this.username});
  @override
  _AdminUpdateState createState() => _AdminUpdateState();
}

class _AdminUpdateState extends State<AdminUpdate> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController bikeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Update Admin",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
          backgroundColor: Color(0xFF0A0E21),
          brightness: Brightness.light,
        ),
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
                controller: usernameController,
                cursorColor: Color(0xFF0A0E21),
                decoration: InputDecoration(
                    hintText: "Change Admin Name to",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF0A0E21)))),
              ),
              SizedBox(height: 30),
              TextField(
                obscureText: true,
                controller: passwordController,
                cursorColor: Color(0xFF0A0E21),
                decoration: InputDecoration(
                    hintText: "Unchanged",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF0A0E21)))),
              ),
              SizedBox(height: 30),
              MyButton(
                  text: "Update Admin",
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
                      if (passwordController.value.text.isNotEmpty) {
                        var url = Uri.parse(
                            'https://bycicle.herokuapp.com/update_admin');
                        var response = await http.put(url, body: {
                          "username": widget.username,
                          "newname": usernameController.value.text
                        });
                      }
                      if (usernameController.value.text.isNotEmpty) {
                        var url = Uri.parse(
                            'https://bycicle.herokuapp.com/change_password_admin');
                        var response = await http.put(url, body: {
                          "username": usernameController.value.text,
                          "password": passwordController.value.text
                        });
                      }
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: Text("Updated Successfully"),
                                content: Text(
                                    "Your Admin Information is successfully updated"),
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
                  }),
            ],
          ),
        )));
  }
}
