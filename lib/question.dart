import 'dart:math';

import 'package:math_exercise/question_add.dart';
import 'package:math_exercise/question_multiply.dart';
import 'package:math_exercise/question_subtract.dart';

abstract class Question {
  int num1;
  int num2;
  int answer;

  String getQuestion();

  bool isCorrect(int answer);

  static Question next({int min, int max}) {
    int i = Random().nextInt(3);
    switch (i) {
      case 0:
        return QuestionAdd(min: min, max: max);
        break;
      case 1:
        return QuestionSubtract(min: min, max: max);
        break;
      case 2:
        return QuestionMultiply();
        break;
      default:
        return null;
    }
  }
}

