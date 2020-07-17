import 'dart:async';

import 'package:flutter/material.dart';
import 'package:prac/todoui.dart';


void main() => runApp(MaterialApp( debugShowCheckedModeBanner: false,
    home: SplashScreen()));


class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
// WidgetsBinding.instance.addPostFrameCallback(( duration){
// Future.delayed(Duration(seconds: 2),(){
//Navigator.of(context)
// .push(MaterialPageRoute(builder: (context) => MyApp()));
// });
// });
    super.initState();

    loadData();
  }

  Future<void> loadData() async {
    await Timer(Duration(seconds: 1), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MyApp()));
  }

  @override
  Widget build(BuildContext context) {
// TODO: implement build
    return Container(

color: Colors.grey,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 1.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TODO",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
      ).copyWith(

      ),
      home: todoui(),
    );
  }
}
