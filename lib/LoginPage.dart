import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:fetan2/AdminPage.dart';
import 'package:fetan2/Scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool scroll = false;
  FocusNode focusText = FocusNode();
  FocusNode focusPassword = FocusNode();
  bool loginClicked = false;
  TextEditingController controllerText = TextEditingController();
  TextEditingController controllerPass = TextEditingController();
  @override
  void initState() {
    super.initState();
    focusText.addListener(() {
      setState(() {
        scroll = true;
      });
    });
    focusPassword.addListener(() {
      setState(() {
        scroll = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF0A0E21),
        body: ModalProgressHUD(
          inAsyncCall: loginClicked,
          child: SafeArea(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                  alignment: Alignment.center,
                  height: 530,
                  width: 320,
                  margin: EdgeInsets.only(top: 80, left: 20, right: 20),
                  padding:
                      EdgeInsets.only(top: 50, left: 60, right: 60, bottom: 20),
                  child: ListView(
                    physics: scroll ? null : NeverScrollableScrollPhysics(),
                    children: [
                      Image.asset("images/logo2.png"),
                      SizedBox(height: 30),
                      TextField(
                        cursorColor: Color(0xFF0A0E21),
                        controller: controllerText,
                        focusNode: focusText,
                        decoration: InputDecoration(
                            hintText: "Please enter your username",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF0A0E21)))),
                      ),
                      SizedBox(height: 30),
                      TextField(
                        obscureText: true,
                        focusNode: focusPassword,
                        controller: controllerPass,
                        cursorColor: Color(0xFF0A0E21),
                        decoration: InputDecoration(
                            hintText: "Please enter your password",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF0A0E21)))),
                      ),
                      SizedBox(height: 40),
                      MyButton(
                        text: "Login",
                        pressed: () async {
                          setState(() {
                            loginClicked = true;
                          });
                          var result = await Connectivity().checkConnectivity();
                          if (controllerText.value.text.isNotEmpty &&
                              controllerPass.value.text.isNotEmpty &&
                              (result == ConnectivityResult.mobile ||
                                  result == ConnectivityResult.wifi)) {
                            var url = Uri.parse(
                                'https://bycicle.herokuapp.com/login_Admin');
                            var response = await http.post(url, body: {
                              "username": controllerText.value.text,
                              "password": controllerPass.value.text
                            });
                            var responseStatus = jsonDecode(response.body);
                            if (responseStatus["status"] == 'true') {
                              var url = Uri.parse(
                                  "https://bycicle.herokuapp.com/total");
                              var response = await http.get(url);
                              var totalJson = jsonDecode(response.body);
                              var total = totalJson['Total'];
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AdminPage(
                                            username: controllerText.value.text,
                                            total: total,
                                          )));
                              setState(() {
                                loginClicked = false;
                              });
                            } else {
                              var url = Uri.parse(
                                  'https://bycicle.herokuapp.com/station/login_stations');
                              response = await http.post(url, body: {
                                "username": controllerText.value.text,
                                "password": controllerPass.value.text
                              });
                              var responseStatus = jsonDecode(response.body);
                              if (responseStatus['status'] == 'true') {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Scanner(
                                              username:
                                                  controllerText.value.text,
                                            )));
                                setState(() {
                                  loginClicked = false;
                                });
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: Text(
                                              "Invalid Username or password"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                  "Please verify your credentials")
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  setState(() {
                                                    loginClicked = false;
                                                  });
                                                },
                                                child: Text("Ok"))
                                          ],
                                        ));
                              }
                            }
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: Text("Something went wrong"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          result == ConnectivityResult.mobile ||
                                                  result ==
                                                      ConnectivityResult.wifi
                                              ? Text(
                                                  "Please enter both of the username field and password field")
                                              : Text(
                                                  "Please check your internet connection")
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              setState(() {
                                                loginClicked = false;
                                              });
                                            },
                                            child: Text("Ok"))
                                      ],
                                    ));
                          }
                        },
                      )
                    ],
                  ))),
        ));
  }
}
