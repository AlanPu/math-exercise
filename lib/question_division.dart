import 'dart:math';

import 'package:math_exercise/question.dart';

class QuestionDivision extends Question {

  QuestionDivision() {
    this.type = QuestionType.division;
    this.num1 = Random().nextInt(9) + 1;
    this.num2 = Random().nextInt(9) + 1;
    int result = num1 * num2;    
    this.correctAnswer = num2;
    num2 = num1;
    num1 = result;
    this.tips = num2 > correctAnswer ? correctAnswer : num2;
  }

  @override
  String getQuestion() {
    return '$num1 ÷ $num2 = ?';
  }

  @override
  bool isCorrect(int answer) {
    return answer == this.correctAnswer;
  }

}