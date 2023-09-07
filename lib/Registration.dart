import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:fetan2/Scanner.dart';
import "package:flutter/material.dart";
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  File photo;
  String barcode;
  final picker = new ImagePicker();
  _firstPage() {
    return SafeArea(
        child: Container(
      alignment: Alignment.center,
      height: 530,
      width: 320,
      margin: EdgeInsets.only(top: 80, left: 20, right: 20),
      padding: EdgeInsets.only(top: 50, left: 60, right: 60, bottom: 20),
      child: ListView(
        children: [
          TextField(
            controller: nameController,
            cursorColor: Color(0xFF0A0E21),
            decoration: InputDecoration(
                hintText: "Enter Student Name",
                hintStyle: TextStyle(color: Colors.grey),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0A0E21)))),
          ),
          SizedBox(height: 30),
          TextField(
            controller: idController,
            cursorColor: Color(0xFF0A0E21),
            decoration: InputDecoration(
                hintText: "Enter Student Id",
                hintStyle: TextStyle(color: Colors.grey),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0A0E21)))),
          ),
          SizedBox(height: 30),
          TextField(
            controller: phoneController,
            cursorColor: Color(0xFF0A0E21),
            decoration: InputDecoration(
                hintText: "Enter Student Phone",
                hintStyle: TextStyle(color: Colors.grey),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0A0E21)))),
          ),
          SizedBox(
            height: 30,
          ),
          TextButton(
              onPressed: () async {
                try {
                  barcode = await FlutterBarcodeScanner.scanBarcode(
                      "#7600ec", "Cancel", true, ScanMode.BARCODE);
                } on Exception {}
              },
              child: Text("Scan BarCode")),
          SizedBox(height: 30),
          TextButton(
            child: Icon(Icons.camera_alt),
            onPressed: () async {
              var image = await picker.getImage(source: ImageSource.camera);
              photo = File(image.path);
            },
          ),
          SizedBox(height: 30),
          MyButton(
              text: "Sign Up",
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
                                Text("Please check your internet connection")
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
                } else if (photo == null ||
                    nameController.value.text.isEmpty ||
                    idController.value.text.isEmpty ||
                    barcode.isEmpty ||
                    phoneController.value.text.isEmpty) {
                  print(phoneController.value.text);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text("Some fields are empty"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Please check you have all field entered")
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
                  var postUri = Uri.parse(
                      "https://bycicle.herokuapp.com/station/registore_customer");
                  var request = new http.MultipartRequest("POST", postUri);
                  request.fields['name'] = nameController.value.text;
                  request.fields['barcode'] = barcode;
                  request.fields['id'] = idController.value.text;
                  var multipartFile =
                      await http.MultipartFile.fromPath('file', photo.path);
                  request.files.add(multipartFile);
                  await request.send();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text("Success"),
                            content: Text("Customer Registered Successfully"),
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
    ));
  }

  // _secondPage() {
  //   return SafeArea(
  //       child: Container(
  //     alignment: Alignment.center,
  //     height: 530,
  //     width: 320,
  //     margin: EdgeInsets.only(top: 80, left: 20, right: 20),
  //     padding: EdgeInsets.only(top: 50, left: 60, right: 60, bottom: 20),
  //     child: ListView(
  //       children: [
  //         MyTextField(
  //           text: "Enter Customer Name",
  //           controller: nameController1,
  //         ),
  //         SizedBox(height: 30),
  //         MyTextField(
  //           text: "Enter Customer Phone Number",
  //           controller: phoneController1,
  //         ),
  //         SizedBox(height: 30),
  //         TextButton(
  //           child: Icon(Icons.camera_alt),
  //           onPressed: () async {
  //             var image = await picker.getImage(source: ImageSource.camera);
  //             photo1 = File(image.path);
  //           },
  //         ),
  //         SizedBox(height: 30),
  //         MyButton(
  //             text: "Sign Up",
  //             pressed: () async {
  //               if (result != ConnectivityResult.mobile &&
  //                   result != ConnectivityResult.wifi) {
  //                 showDialog(
  //                     context: context,
  //                     builder: (BuildContext context) => AlertDialog(
  //                       title: Text("Something went wrong"),
  //                       content: Column(
  //                         mainAxisSize: MainAxisSize.min,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text("Please check your internet connection")
  //                         ],
  //                       ),
  //                       actions: [
  //                         TextButton(
  //                             onPressed: () {
  //                               Navigator.of(context).pop();
  //                             },
  //                             child: Text("Ok"))
  //                       ],
  //                     ));
  //               }
  //              else if (photo1 == null ||
  //                   nameController1.value.text.isEmpty ||
  //                   idController1.value.text.isEmpty ||
  //                   phoneController1.isEmpty||) {
  //                 showDialog(
  //                     context: context,
  //                     builder: (BuildContext context) => AlertDialog(
  //                           title: Text("Some fields are not field"),
  //                           content: Column(
  //                             mainAxisSize: MainAxisSize.min,
  //                             crossAxisAlignment: CrossAxisAlignment.center,
  //                             children: [
  //                               Text("Please check you have all field entered")
  //                             ],
  //                           ),
  //                           actions: [
  //                             TextButton(
  //                                 onPressed: () {
  //                                   Navigator.of(context).pop();
  //                                 },
  //                                 child: Text("Ok"))
  //                           ],
  //                         ));
  //               } else {
  //                 var postUri = Uri.parse(
  //                     "https://bycicle.herokuapp.com/station/registore_customer1");
  //                 var request = new http.MultipartRequest("POST", postUri);
  //                 request.fields['name'] = nameController.value.text;
  //                 request.fields['phone'] = phoneController.value.text;
  //                 var multipartFile =
  //                     await http.MultipartFile.fromPath('file', photo.path);
  //                 request.files.add(multipartFile);
  //                 await request.send();
  //               }
  //             }),
  //       ],
  //     ),
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
          appBar: AppBar(
              title: Text("Register User",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic)),
              backgroundColor: Color(0xFF0A0E21),
              bottom: TabBar(
                tabs: [
                  Tab(text: "For Student"),
                ],
              ),
              brightness: Brightness.light),
          body: TabBarView(
            children: [
              _firstPage(),
            ],
          )),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  MyTextField({this.text, this.controller});
  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Color(0xFF0A0E21),
      decoration: InputDecoration(
          hintText: this.text,
          hintStyle: TextStyle(color: Colors.grey),
          border:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF0A0E21)))),
    );
  }
}
