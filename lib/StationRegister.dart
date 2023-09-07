import 'package:connectivity/connectivity.dart';
import "package:flutter/material.dart";

import 'Registration.dart';
import 'Scanner.dart';
import 'package:http/http.dart' as http;

class StationRegister extends StatefulWidget {
  @override
  _StationRegisterState createState() => _StationRegisterState();
}

class _StationRegisterState extends State<StationRegister> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController bikeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register Station",
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
                    hintText: "Enter Station Name",
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
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF0A0E21)))),
              ),
              SizedBox(height: 30),
              TextField(
                controller: bikeController,
                cursorColor: Color(0xFF0A0E21),
                decoration: InputDecoration(
                    hintText: "Enter Station Bike Number",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF0A0E21)))),
              ),
              SizedBox(height: 30),
              MyButton(
                  text: "Register Station",
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
                      RegExp regExp = RegExp(r"[a-zA-Z]", caseSensitive: false);
                      if (!regExp.hasMatch(bikeController.value.text)) {
                        var url = Uri.parse(
                            'https://bycicle.herokuapp.com/newstation');
                        var response = await http.post(url, body: {
                          "username": usernameController.value.text,
                          "password": passwordController.value.text,
                          "num_bick": bikeController.value.text
                        });
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("Registration Successful"),
                                  content: Text(
                                      "The Station is registered Successfully"),
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
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("Invalid Input"),
                                  content: Text(
                                      "Number of bike should only be number"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Ok"),
                                    )
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
