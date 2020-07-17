import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prac/main.dart';


class Privacy extends StatefulWidget {
  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Privacy Policy",
            style: TextStyle(
                fontSize: 22,  color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black26),
        ),
        body: ListView(

          padding: EdgeInsets.only(right: 19.0, left: 19.0),
          children: <Widget>[
            Text("Yogita Bhargava built this beautiful app . ",style: TextStyle(color: Colors.black,fontSize: 16),),

          ],
        )


    );
  }}



