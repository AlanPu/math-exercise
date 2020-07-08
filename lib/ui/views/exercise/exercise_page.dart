import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'exercise_area.dart';

class ExercisePage extends StatelessWidget {
  final int numRange;
  final int numOfExercise;
  final bool isCountDownMode;

  ExercisePage(
      {Key key,
      @required this.numRange,
      @required this.numOfExercise,
      @required this.isCountDownMode})
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
        isCountDownMode: isCountDownMode,
      ),
    );
  }
}
