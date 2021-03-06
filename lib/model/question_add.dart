import 'dart:math';

import 'question.dart';

class QuestionAdd extends Question {
  int min;
  int max;

  QuestionAdd({this.min, this.max}) {
    this.type = QuestionType.add;
    this.num1 = Random().nextInt(max - 1) + min;
    this.num2 = Random().nextInt(max - 1) + min;
    this.correctAnswer = this.num1 + this.num2;
  }

  @override
  String getQuestion() {
    return '$num1 + $num2 = ?';
  }
}
