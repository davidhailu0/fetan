import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Registration.dart';
import 'Scanner.dart';

class DeleteStation extends StatefulWidget {
  @override
  _DeleteStationState createState() => _DeleteStationState();
}

class _DeleteStationState extends State<DeleteStation> {
  TextEditingController usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Delete Station",
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
              MyButton(
                  text: "Delete Station",
                  pressed: () async {
                    var result = await Connectivity().checkConnectivity();
                    if (result != ConnectivityResult.mobile &&
                        result != ConnectivityResult.wifi) {
                      print("username" + usernameController.value.text);
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
                            'https://bycicle.herokuapp.com/delete_station');
                        await http.delete(url, headers: {
                          "username": usernameController.value.text
                        });
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text("Successfully Deleted"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          "The Station has successfully deleted")
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
