import 'package:flutter_test/flutter_test.dart';
import 'package:math_exercise/model/question_division.dart';

main() {
  group('QuestionDivision Test', () {
    test('Number generation', () {
      QuestionDivision question = QuestionDivision();
      expect(question.correctAnswer, greaterThanOrEqualTo(1));
      expect(question.correctAnswer, lessThanOrEqualTo(9));
      expect(question.num2, greaterThanOrEqualTo(1));
      expect(question.num2, lessThanOrEqualTo(9));
    });

    test('Calculation', () {
      QuestionDivision question = QuestionDivision();
      expect(question.correctAnswer, question.num1 / question.num2);
    });

    test('Question text', () {
      QuestionDivision question = QuestionDivision();
      expect(question.getQuestion(), '${question.num1} ÷ ${question.num2} = ?');
    });
  });
}
