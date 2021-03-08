import 'dart:math';

import 'question.dart';

class QuestionDivision2 extends Question {
  List<int> primeNumbers = [
    1,
    2,
    3,
    5,
    7,
    11,
    13,
    17,
    19,
    23,
    29,
    31,
    37,
    41,
    43,
    47,
    51,
    53,
    57,
    59,
    61,
    67,
    71,
    73,
    83,
    87,
    89,
    97
  ];

  QuestionDivision2() {
    this.type = QuestionType.division;
    while (true) {
      this.num1 = Random().nextInt(90) + 10; // 10 <= num1 < 100
      if (!primeNumbers.contains(this.num1)) {
        break;
      }
    }
    int temp = this.num1 ~/ 2; // The efficient way of "(this.num1 / 2).toInt()"
    List<int> availableNum2 = List<int>();
    for (int i = 2; i <= temp; i++) {
      int v = this.num1 ~/ i;
      if (this.num1 / i == v) {
        availableNum2.add(v);
      }
    }
    this.num2 = availableNum2[Random().nextInt(availableNum2.length)];
    if (this.num2 >= 10) {
      this.num2 = num1 ~/ num2;
    }
    this.correctAnswer = num1 ~/ num2;
    this.tips = num2;
  }

  @override
  String getQuestion() {
    return '$num1 ÷ $num2 = ?';
  }
}
