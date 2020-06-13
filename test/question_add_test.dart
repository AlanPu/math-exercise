import 'package:math_exercise/question_add.dart';
import 'package:test/test.dart';

main() {
  group('QuestionAdd Test', () {
    test('Number generation', () {
      QuestionAdd question = QuestionAdd(min: 1, max: 3);
      expect(question.num1, greaterThanOrEqualTo(1));
      expect(question.num1, lessThan(3));
      expect(question.num2, greaterThanOrEqualTo(1));
      expect(question.num2, lessThan(3));
    });

    test('Calculation', () {
      QuestionAdd question = QuestionAdd(min: 1, max: 3);
      expect(question.correctAnswer, question.num1 + question.num2);
    });

    test('Question text', () {
      QuestionAdd question = QuestionAdd(min: 1, max: 3);
      expect(question.getQuestion(), '${question.num1} + ${question.num2} = ?');
    });
  });
}
