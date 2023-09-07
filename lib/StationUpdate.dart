import 'package:connectivity/connectivity.dart';
import "package:flutter/material.dart";

import 'Registration.dart';
import 'Scanner.dart';
import 'package:http/http.dart' as http;

class StationUpdate extends StatefulWidget {
  @override
  _StationUpdateState createState() => _StationUpdateState();
}

class _StationUpdateState extends State<StationUpdate> {
  TextEditingController idStation = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController bikeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Update Station",
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
                controller: idStation,
                cursorColor: Color(0xFF0A0E21),
                decoration: InputDecoration(
                    hintText: "Enter the Station name to Update",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF0A0E21)))),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: usernameController,
                cursorColor: Color(0xFF0A0E21),
                decoration: InputDecoration(
                    hintText: "change username to",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF0A0E21)))),
              ),
              SizedBox(height: 20),
              TextField(
                obscureText: true,
                controller: passwordController,
                cursorColor: Color(0xFF0A0E21),
                decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF0A0E21)))),
              ),
              SizedBox(height: 20),
              TextField(
                controller: bikeController,
                cursorColor: Color(0xFF0A0E21),
                decoration: InputDecoration(
                    hintText: "Update number of bikes",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF0A0E21)))),
              ),
              SizedBox(height: 20),
              MyButton(
                  text: "Update Station",
                  pressed: () async {
                    var result = await Connectivity().checkConnectivity();
                    if (result != ConnectivityResult.wifi &&
                        result != ConnectivityResult.mobile) {
                      print(idStation.value.text);
                      print(usernameController.value.text);
                      print(bikeController.value.text);
                      print(passwordController.value.text);
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
                          'https://bycicle.herokuapp.com/update_stations');
                      var response = await http.put(url, body: {
                        "username": idStation.value.text,
                        "newname": usernameController.value.text,
                        "num_bick": bikeController.value.text
                      });
                      if (passwordController.value.text.isNotEmpty) {
                        url = Uri.parse(
                            'https://bycicle.herokuapp.com/change_password_station');
                        response = await http.put(url, body: {
                          "username": usernameController.value.text.isNotEmpty
                              ? usernameController.value.text
                              : idStation.value.text,
                          "password": passwordController.value.text
                        });
                      }
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Success"),
                                content:
                                    Text("Successfully Updated the Station"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.pop(context);
                                    },
                                    child: Text("Ok"),
                                  )
                                ],
                              ));
                    }
                  }),
            ],
          ),
        )));
  }
}
