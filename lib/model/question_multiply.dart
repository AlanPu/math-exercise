import 'dart:math';

import 'question.dart';

class QuestionMultiply extends Question {
  QuestionMultiply() {
    this.type = QuestionType.multiply;
    this.num1 = Random().nextInt(9) + 1;
    this.num2 = Random().nextInt(9) + 1;
    this.correctAnswer = this.num1 * this.num2;
    this.tips = num1 > num2 ? num2 : num1;
  }

  @override
  String getQuestion() {
    return '$num1 x $num2 = ?';
  }

  @override
  bool isCorrect(int answer) {
    return answer == this.correctAnswer;
  }
}
