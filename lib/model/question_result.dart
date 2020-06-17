import 'question.dart';

class QuestionResult extends Question {
  int total;
  int correct;

  QuestionResult({this.total, this.correct});

  @override
  String getQuestion() {
    if (total == correct) {
      return '一共出了$total道题，你全答对了，真棒！';
    } else {
      return '一共出了$total道题，你答对了$correct题，加油！';
    }
  }

  @override
  bool isCorrect(int answer) {
    return false;
  }
}
