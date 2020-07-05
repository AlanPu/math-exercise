import 'package:intl/intl.dart';

class Score {
  String date;
  String total;
  String correct;
  String combo;
  String score;

  Score(
      {this.date = '',
      int total = 0,
      int correct = 0,
      int combo = 0,
      double score = 0}) {
    if (this.date == '') {
      this.date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
    this.total = total.toString();
    this.combo = combo.toString();
    this.correct = correct.toString();
    this.score = _toString(score);
  }

  String _toString(double val) {
    if (val.toInt() == val) {
      return val.toInt().toString();
    } else {
      return val.toString();
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'total': total,
      'correct': correct,
      'combo': combo,
      'score': score,
    };
  }
}
