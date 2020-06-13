import 'package:math_exercise/question_subtraction.dart';
import 'package:test/test.dart';

main() {
  group('QuestionSubtraction Test', () {
    test('Number generation', () {
      QuestionSubtraction question = QuestionSubtraction(min: 1, max: 3);
      expect(question.num1, greaterThanOrEqualTo(1));
      expect(question.num1, lessThan(3));
      expect(question.num2, greaterThanOrEqualTo(1));
      expect(question.num2, lessThan(3));
      expect(question.num1, greaterThanOrEqualTo(question.num2));
    });

    test('Calculation', () {
      QuestionSubtraction question = QuestionSubtraction(min: 1, max: 3);
      expect(question.correctAnswer, question.num1 - question.num2);
    });

    test('Question text', () {
      QuestionSubtraction question = QuestionSubtraction(min: 1, max: 3);
      expect(question.getQuestion(), '${question.num1} - ${question.num2} = ?');
    });
  });
}
