import 'dart:async';

import 'package:fetan2/DeleteStation.dart';
import 'package:fetan2/Scanner.dart';
import 'package:fetan2/StationRegister.dart';
import 'package:fetan2/StationUpdate.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'AddAdmin.dart';
import 'AdminUpdate.dart';
import 'dart:convert';

class Data {
  final String username;
  final String bike;

  Data({this.username, this.bike});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(username: json['username'], bike: json['num_bick'].toString());
  }
}

Future<List<Data>> getData() async {
  final response = await http.get('https://bycicle.herokuapp.com/bick_dist');
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);

    return jsonResponse.map((data) => new Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class AdminPage extends StatefulWidget {
  final String username;
  final int total;
  AdminPage({this.username, this.total});
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Future<List<Data>> futureData;
  @override
  void initState() {
    super.initState();
    futureData = getData();
  }

  // Future<List<Data>> getData() async {
  //   var url = Uri.parse('https://bycicle.herokuapp.com/bick_dist');
  //   var response = await http.get(url);
  //   List array = jsonDecode(response.body);
  //   return array.map((e) => Data.fromJson(e)).toList();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Welcome back ${widget.username}",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
            backgroundColor: Color(0xFF0A0E21),
            brightness: Brightness.light),
        drawer: Drawer(
            child: ListView(
          children: [
            DrawerHeader(
              child: Image.asset("images/logo2.png"),
              decoration: BoxDecoration(
                color: Color(0xFF0A0E21),
              ),
            ),
            ListTile(
              title: Text("Logout"),
              onTap: () async {
                Navigator.pop(context);
                Navigator.pop(context);
                var url = Uri.parse("https://bycicle.herokuapp.com/logout");
                await http.get(url);
              },
            )
          ],
        )),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 15,
            ),
            Text("Total Revenue: ${widget.total} Birr",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            SizedBox(height: 30),
            Expanded(
              child: FutureBuilder<List<Data>>(
                future: futureData,
                builder: (context, AsyncSnapshot<List<Data>> snapshot) {
                  List<Data> data = snapshot.data;
                  print(futureData);
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                data[index].username,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 15),
                              Text(data[index].bike + " bike",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))
                            ],
                          );
                        });
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
            SizedBox(height: 25),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButton(
                      text: "Add Station",
                      pressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StationRegister()));
                      }),
                  SizedBox(width: 20),
                  MyButton(
                      text: "Add Admin",
                      pressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddAdmin()));
                      })
                ],
              ),
            ),
            SizedBox(height: 25),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButton(
                    text: "Update Station",
                    pressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StationUpdate()));
                    },
                  ),
                  SizedBox(width: 20),
                  MyButton(
                    text: "Update Admin",
                    pressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminUpdate(
                                    username: widget.username,
                                  )));
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: 25),
            Expanded(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              MyButton(
                text: "Delete Station",
                pressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DeleteStation()));
                },
              )
            ])),
          ],
        ));
  }
}
