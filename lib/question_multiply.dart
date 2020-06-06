import 'dart:math';

import 'package:math_exercise/question.dart';

class QuestionMultiply extends Question {

  QuestionMultiply() {
    this.num1 = Random().nextInt(9) + 1;
    this.num2 = Random().nextInt(9) + 1;
    this.answer = this.num1 * this.num2;
  }

  @override
  String getQuestion() {
    return '$num1 x $num2 = ?';
  }

  @override
  bool isCorrect(int answer) {
    return this.answer == answer;
  }

}