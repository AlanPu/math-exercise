import 'question.dart';

class QuestionResult extends Question {
  int total;
  int correct;
  String score;

  QuestionResult({this.total, this.correct, double score}) {
    if (score == score.toInt()) {
      this.score = score.toInt().toString();
    }
    else {
      this.score = score.toString();
    }
  }

  @override
  String getQuestion() {
    if (total == correct) {
      return '一共出了$total道题，你全答对了，得分$score，真棒！';
    } else {
      return '一共出了$total道题，你答对了$correct题，得分$score，加油！';
    }
  }

  @override
  bool isCorrect(String answer) {
    return false;
  }
}
