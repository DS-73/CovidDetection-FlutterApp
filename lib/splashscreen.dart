import 'package:covid_detector/home.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplash extends StatefulWidget {
    @override
    _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
    @override
    Widget build(BuildContext context) {
        return SplashScreen(
            seconds: 2,
            navigateAfterSeconds: Home(),
            title: Text('Covid Detector',
                style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 40, 
                    color: Color(0xFFE99600),
                    ),
                ),
            backgroundColor: Colors.black,
            photoSize: 150,
            loaderColor: Color(0xFFEEDA32),
        );
    }
}