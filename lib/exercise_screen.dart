import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'exercise_area.dart';

class ExerciseScreen extends StatelessWidget {
  final int numRange;
  final int numOfExercise;

  ExerciseScreen(
      {Key key, @required this.numRange, @required this.numOfExercise})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('计算练习'),
      ),
      body: ExerciseArea(
        numOfExercise: numOfExercise,
        numRange: numRange,
      ),
    );
  }
}
