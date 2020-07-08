import 'dart:math';

import 'package:math_exercise/model/question.dart';
import 'package:sprintf/sprintf.dart';

class QuestionCombined extends Question {
  int min;
  int max;
  int op1;
  int op2;
  int num3;
  String question;

  QuestionCombined({int min, int max}) {
    this.type = QuestionType.combined;
    op1 = Random().nextInt(2);
    op2 = Random().nextInt(2);
    this.num1 = Random().nextInt(max - 1) + min;
    this.num2 = Random().nextInt(max - 1) + min;
    this.num3 = Random().nextInt(max - 1) + min;

    if (op1 == 1)  {// Subtraction
      if (op2 == 0) {
        // Add
        int tmp = num2 + num3;
        if (num1 < tmp) {
          question = sprintf("%d + %d - %d = ?", [num2, num3, num1]);
          correctAnswer = num2 + num3 - num1;
        } else {
          question = sprintf("%d - (%d + %d) = ?", [num1, num2, num3]);
          correctAnswer = num1 - (num2 + num3);
        }
      } else {
        // Subtraction
        if (num2 < num3) {
          int tmp = num2;
          num2 = num3;
          num3 = tmp;
        }
        int tmp = num2 - num3;
        if (num1 < tmp) {
          question = sprintf("%d - %d - %d = ?", [num2, num3, num1]);
          correctAnswer = num2 - num3 - num1;
        } else {
          question = sprintf("%d - (%d - %d) = ?", [num1, num2, num3]);
          correctAnswer = num1 - (num2 - num3);
        }
      }
    } else {
      // Add
      if (op2 == 0) {
        // Add
        question = sprintf("%d + %d + %d = ?", [num1, num2, num3]);
        correctAnswer = num1 + num2 + num3;
      } else {
        // Subtraction
        if (num2 < num3) {
          int tmp = num2;
          num2 = num3;
          num3 = tmp;
        }
        int tmp = Random().nextInt(2);
        if (tmp == 0) {
          question = sprintf("%d + %d - %d = ?", [num1, num2, num3]);
        }
        else {
          question = sprintf("%d + (%d - %d) = ?", [num1, num2, num3]);
        }
        correctAnswer = num1 + num2 - num3;
      }
    }
  }

  @override
  String getQuestion() {
    return question;
  }
}
