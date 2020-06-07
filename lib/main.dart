import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_exercise/exercise_screen.dart';
import 'num_slider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '计算练习',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '计算练习'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int numRange = 100;
  int numOfExercise = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage("assets/images/background.png"),
            //     fit: BoxFit.fill,
            //   ),
            // ),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                ),
                margin: EdgeInsets.only(
                  top: 50,
                  bottom: 30,
                ),
                alignment: Alignment.center,
                child: Text(
                  '计算练习',
                  style: TextStyle(
                    fontFamily: 'NotoSerifSC-Medium',
                    fontSize: 40.0,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                // Pico Logo
                child: Image.asset(
                  "assets/images/pico-1.jpg",
                  width: 200,
                  height: 200,
                ),
              ),
              NumSlider(
                label: '出题范围',
                min: 0,
                max: 100,
                value: numRange,
                margin: EdgeInsets.only(
                  top: 50,
                  left: 40,
                  right: 40,
                ),
              ).build(onChanged: (int newValue) {
                setState(() {
                  numRange = newValue;
                });
              }),
              NumSlider(
                  label: '出题数',
                  min: 1,
                  max: 100,
                  value: numOfExercise,
                  margin: EdgeInsets.only(
                    top: 10,
                    left: 40,
                    right: 40,
                  )).build(onChanged: (int newValue) {
                setState(() {
                  numOfExercise = newValue;
                });
              }),
              Container(
                  margin: EdgeInsets.only(
                    top: 50,
                  ),
                  child: FlatButton(
                    child: Icon(
                      Icons.arrow_forward,
                      size: 60,
                      color: Colors.lightBlue,
                    ),
                    onPressed: () {
                      navigateToNextScreen(context);
                    },
                  ))
            ])));
  }

  void navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ExerciseScreen(
              numRange: numRange,
              numOfExercise: numOfExercise,
            )));
  }
}
