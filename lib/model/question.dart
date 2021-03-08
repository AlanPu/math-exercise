import 'package:math_exercise/model/question_combined.dart';
import 'package:math_exercise/model/question_division2.dart';

import 'question_add.dart';
import 'question_division.dart';
import 'question_multiply.dart';
import 'question_subtraction.dart';

abstract class Question {
  int num1;
  int num2;
  int correctAnswer;
  String wrongAnswer;
  int tips = 0;
  QuestionType type;

  String getQuestion();

  bool isCorrect(String answer) {
    if (answer == '-') {
      return false;
    } else {
      return int.parse(answer) == this.correctAnswer;
    }
  }

  static Question next({int min, int max}) {
    int i = 5; //Random().nextInt(6);
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
      case 4:
        return QuestionCombined(min: min, max: max);
        break;
      case 5:
        return QuestionDivision2();
        break;
      default:
        return null;
    }
  }
}

enum QuestionType { add, subtraction, multiply, division, combined }
