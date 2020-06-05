import 'package:flutter/material.dart';
import 'package:math_exercise/progress_text.dart';

class ExerciseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('计算练习'),
      ),
      body: ExerciseArea(),
    );
  }
}

class ExerciseArea extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ExerciseAreaState();
}

class _ExerciseAreaState extends State<ExerciseArea> {
  int currentNum = 0;
  int correctCount = 0;
  int combo = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ProgressText(
                label: '当前题数',
                value: currentNum,
              ).build(),
              ProgressText(
                label: '正确题数',
                value: correctCount,
              ).build(),
              ProgressText(
                label: '连击数',
                value: combo,
              ).build(),
            ],
          ),
        ],
      ),
    );
  }
}
