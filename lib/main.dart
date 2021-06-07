import 'package:flutter/material.dart';
import 'package:covid_detector/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Covid Detector",
      home: MySplash(),
      debugShowCheckedModeBanner: false,
    );
  }
}
