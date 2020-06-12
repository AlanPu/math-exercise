import 'package:math_exercise/question_add.dart';
import 'package:test/test.dart';

main() {
  group('QuestionAdd Test', () {
    test('Number generation', () {
      QuestionAdd add = QuestionAdd(min: 1, max: 3);
      expect(add.num1, greaterThanOrEqualTo(1));
      expect(add.num1, lessThan(3));
      expect(add.num2, greaterThanOrEqualTo(1));
      expect(add.num2, lessThan(3));
    });

    test('Calculation', () {
      QuestionAdd add = QuestionAdd(min: 1, max: 2);
      expect(add.correctAnswer, 2);
    });

    test('Question text', () {
      QuestionAdd add = QuestionAdd(min: 1, max: 2);
      expect(add.getQuestion(), '1 + 1 = ?');
    });
  });
}
