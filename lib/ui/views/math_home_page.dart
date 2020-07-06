import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_exercise/model/score.dart';
import 'package:math_exercise/persistance/local_db.dart';
import 'package:math_exercise/ui/image/image_styles.dart';
import 'package:math_exercise/ui/views/score_board.dart';
import 'package:math_exercise/ui/widgets/num_slider.dart';
import 'package:math_exercise/ui/global/styles.dart' as styles;
import 'package:math_exercise/ui/views/exercise/exercise_page.dart';

class MathHomePage extends StatefulWidget {
  MathHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MathHomePage> {
  int numRange = 100;
  int numOfExercise = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.list),
          tooltip: '历史成绩',
          onPressed: () {
            _showScoreBoard();
          },
        ),
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
                    fontFamily: styles.fontFamily,
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
                      _navigateToNextScreen(context);
                    },
                  ))
            ])));
  }

  void _showScoreBoard() async {
    final List<Score> scores = await LocalDb().getAll();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScoreBoard(
          scores: scores,
        ),
      ),
    );
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ExercisePage(
              numRange: numRange,
              numOfExercise: numOfExercise,
            )));
  }
}
