import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_exercise/ui/image/image_styles.dart';
import 'package:math_exercise/ui/widgets/num_slider.dart';

import '../exercise/exercise_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int numRange = 100;
  int numOfExercise = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
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
                  "assets/images/pico-1.png",
                  width: ImageStyles.WIDTH_LARGE,
                  height: ImageStyles.HEIGHT_LARGE,
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
        builder: (context) => ExercisePage(
              numRange: numRange,
              numOfExercise: numOfExercise,
            )));
  }
}
