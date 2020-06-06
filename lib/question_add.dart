import 'dart:math';

import 'package:math_exercise/question.dart';

class QuestionAdd extends Question {

  int min;
  int max;

  QuestionAdd({this.min, this.max}) {
    this.num1 = Random().nextInt(max - 1) + min;
    this.num2 = Random().nextInt(max - 1) + min;
    this.answer = this.num1 + this.num2;
  }

  @override
  String getQuestion() {
    return '$num1 + $num2 = ?';
  }

  @override
  bool isCorrect(int answer) {
    return this.answer == answer;
  }

}