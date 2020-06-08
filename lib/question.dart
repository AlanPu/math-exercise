import 'dart:math';

import 'package:math_exercise/question_add.dart';
import 'package:math_exercise/question_division.dart';
import 'package:math_exercise/question_multiply.dart';
import 'package:math_exercise/question_subtraction.dart';

abstract class Question {
  int num1;
  int num2;
  int answer;
  QuestionType type;

  String getQuestion();

  bool isCorrect(int answer);

  static Question next({int min, int max}) {
    int i = Random().nextInt(4);
    switch (i) {
      case 0:
        return QuestionAdd(min: min, max: max);
        break;
      case 1:
        return QuestionSubtraction(min: min, max: max);
        break;
      case 2:
        return QuestionMultiply();
        break;
      case 3:
        return QuestionDivision();
        break;
      default:
        return null;
    }
  }
}

enum QuestionType { add, subtraction, multiply, division }
