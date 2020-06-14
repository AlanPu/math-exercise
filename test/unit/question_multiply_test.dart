import 'package:math_exercise/question_multiply.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('QuestionMultiply Test', () {
    test('Number generation', () {
      QuestionMultiply question = QuestionMultiply();
      expect(question.num1, greaterThanOrEqualTo(1));
      expect(question.num1, lessThanOrEqualTo(9));
      expect(question.num2, greaterThanOrEqualTo(1));
      expect(question.num2, lessThanOrEqualTo(9));
    });

    test('Calculation', () {
      QuestionMultiply question = QuestionMultiply();
      expect(question.correctAnswer, question.num1 * question.num2);
    });

    test('Question text', () {
      QuestionMultiply question = QuestionMultiply();
      expect(question.getQuestion(), '${question.num1} x ${question.num2} = ?');
    });
  });
}
