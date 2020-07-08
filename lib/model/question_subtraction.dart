import 'dart:math';

import 'question.dart';

class QuestionSubtraction extends Question {
  int min;
  int max;

  QuestionSubtraction({this.min, this.max}) {
    this.type = QuestionType.subtraction;
    this.num1 = Random().nextInt(max - 1) + min;
    this.num2 = Random().nextInt(max - 1) + min;
    if (num1 < num2) {
      int tmp = num1;
      num1 = num2;
      num2 = tmp;
    }
    this.correctAnswer = this.num1 - this.num2;
  }

  @override
  String getQuestion() {
    return '$num1 - $num2 = ?';
  }
}
