import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_exercise/model/question.dart';
import 'package:math_exercise/model/question_result.dart';
import 'package:math_exercise/model/score.dart';
import 'package:math_exercise/persistance/local_db.dart';
import 'package:math_exercise/ui/global/styles.dart' as styles;
import 'package:math_exercise/ui/image/image_animation.dart';
import 'package:math_exercise/ui/image/image_animation_entry.dart';
import 'package:math_exercise/ui/image/image_dialog.dart';
import 'package:math_exercise/ui/image/image_styles.dart';
import 'package:math_exercise/ui/image/img.dart';
import 'package:math_exercise/ui/views/review_page.dart';
import 'package:math_exercise/ui/views/score_board.dart';
import 'package:math_exercise/ui/widgets/answer_input_decoration.dart';
import 'package:math_exercise/ui/widgets/progress_text.dart';
import 'package:math_exercise/ui/widgets/question_bubble.dart';

class ExerciseArea extends StatefulWidget {
  final int numRange;
  final int numOfExercise;

  ExerciseArea({Key key, @required this.numRange, @required this.numOfExercise})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExerciseAreaState(
        numOfExercise: numOfExercise,
        numRange: numRange,
      );
}

class _ExerciseAreaState extends State<ExerciseArea> {
  int currentNum = 1;
  int correctCount = 0;
  int combo = 0;
  int maxCombo = 0;
  int numRange;
  Question question;
  int answer;
  int numOfExercise;
  bool isLastCorrect = false;
  final answerTextController = TextEditingController();
  FocusNode answerFocusNode = FocusNode();
  int imageStartIndex = 1;
  int imageEndIndex = 1;
  TextField answerInputField;
  bool showActionButton = false;
  bool isCompleted = false;
  List<Question> wrongAnswers = List<Question>();
  int totalSecond = 0;
  int totalMinute = 0;
  int totalHour = 0;
  int countDownSecond = 10;
  int remainingSecond = 0;
  Text totalTimeText;
  Text countDownText;
  Timer _timer;

  static final Image imgHappyFace = Image.asset(
    'assets/images/pico-1.png',
    width: ImageStyles.WIDTH_SMALL,
    height: ImageStyles.HEIGHT_SMALL,
  );
  static final Image imgSadFace = Image.asset(
    'assets/images/pico-4.png',
    width: ImageStyles.WIDTH_SMALL,
    height: ImageStyles.HEIGHT_SMALL,
  );
  Img img = Img(child: imgHappyFace);

  _ExerciseAreaState({@required this.numRange, @required this.numOfExercise})
      : super() {
    question = Question.next(min: 0, max: numRange);
  }

  static getImageAnimation(int imgLowIndex, int imgHighIndex) {
    return ImagesAnimation(
      w: ImageStyles.WIDTH_SMALL,
      h: ImageStyles.HEIGHT_SMALL,
      entry: ImagesAnimationEntry(
          imgLowIndex, imgHighIndex, "assets/images/pico-%s.png"),
    );
  }

  void _startTimeCounter() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (isCompleted) {
        timer.cancel();
        return;
      }
      totalSecond++;
      if (totalSecond == 60) {
        totalSecond = 0;
        totalMinute++;
      }
      if (totalMinute == 60) {
        totalHour++;
      }
      if (totalHour == 24) {
        totalHour = 0;
      }
      setState(() {
        totalTimeText = _getTotalTimeText();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    showActionButton = (question.type == QuestionType.multiply ||
        question.type == QuestionType.division);

    totalTimeText = _getTotalTimeText();

    countDownText = _getCountDownText();

    answerInputField = TextField(
      focusNode: answerFocusNode,
      controller: answerTextController,
      autocorrect: false,
      keyboardType: TextInputType.number,
      decoration: AnswerInputDecoration(),
      onSubmitted: (String value) {
        answer = int.parse(value);
        if (question.isCorrect(answer)) {
          setState(() {
            img.setChild(getImageAnimation(2, 3));
          });
          correctCount++;
          isLastCorrect = true;
          if (isLastCorrect) {
            combo++;
            if (maxCombo < combo) {
              maxCombo = combo;
            }
          }
        } else {
          question.wrongAnswer = int.parse(value);
          wrongAnswers.add(question);
          setState(() {
            img.setChild(imgSadFace);
          });
          isLastCorrect = false;
          combo = 0;
        }
        Timer(Duration(seconds: 2), () {
          if (currentNum == numOfExercise) {
            _completeExercise();
          } else {
            _nextQuestion();
          }
        });
      },
    );

    _startTimeCounter();
  }

  void _nextQuestion() {
    setState(() {
      img.setChild(imgHappyFace);
      currentNum++;
      question = Question.next(min: 0, max: numRange);
      showActionButton = (question.type == QuestionType.multiply ||
          question.type == QuestionType.division);
      answerTextController.clear();
      answerFocusNode.requestFocus();
    });
  }

  void _completeExercise() {
    isCompleted = true;
    showActionButton = wrongAnswers.length > 0;
    setState(() {
      answerFocusNode.unfocus();
      answerTextController.clear();
      answerInputField = TextField(enabled: false);
      question = QuestionResult(
        total: numOfExercise,
        correct: correctCount,
        score: _calculateScore(),
      );
      img.setChild(imgHappyFace);
    });

    LocalDb().insert(Score(
      total: numOfExercise,
      correct: correctCount,
      combo: maxCombo,
      score: _calculateScore(),
    ));
  }

  List<Widget> _getProgressTexts() {
    return [
      ProgressText(
        label: '当前题数',
        value: currentNum,
      ).build(),
      ProgressText(
        label: '正确题数',
        value: correctCount,
      ).build(),
      ProgressText(
        label: '连击数',
        value: combo,
      ).build(),
    ];
  }

  void _showReviewPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReviewPage(wrongAnswers: wrongAnswers),
      ),
    );
  }

  Widget _widgetWithPadding(
      {Widget widget,
      double left = 0.0,
      double right = 0.0,
      double top = 0.0,
      double bottom = 0.0}) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        right: right,
        top: top,
        bottom: bottom,
      ),
      child: widget,
    );
  }

  Widget _getContextButton() {
    return FloatingActionButton(
      child: Icon(isCompleted ? Icons.rate_review : Icons.info),
      onPressed: () {
        if (!isCompleted) {
          showDialog(
            context: context,
            builder: (_) => ImageDialog(index: question.tips),
          );
        } else {
          _showReviewPage();
        }
      },
    );
  }

  void _showScoreBoard() async {
    final List<Score> scores = await LocalDb().getAll();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScoreBoard(
          scores: scores,
        ),
      ),
    );
  }

  double _calculateScore() {
    double score = correctCount / numOfExercise * 100;
    if (score != score.toInt()) {
      score = score.toInt() + 0.5;
    }
    return score;
  }

  Widget _drawQuestionBubble() {
    return _widgetWithPadding(
      widget: QuestionBubble(text: question.getQuestion()),
      left: 130.0,
    );
  }

  String _formatTime(int hour, int minute, int second) {
    var h = hour.toString().padLeft(2, '0');
    var m = minute.toString().padLeft(2, '0');
    var s = second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  List<Widget> _getTimer() {
    return [
      totalTimeText,
      countDownText,
    ];
  }

  Widget _getTotalTimeText() {
    return Text(
      '用时：${_formatTime(totalHour, totalMinute, totalSecond)}',
      style: TextStyle(
        fontFamily: styles.fontFamily,
        fontSize: 16.0,
        color: Colors.black,
      ),
    );
  }

  Widget _getCountDownText() {
    return Text('倒计时：${_formatTime(0, 0, countDownSecond)}',
        style: TextStyle(
          fontFamily: styles.fontFamily,
          fontSize: 16.0,
          color: Colors.black,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Visibility(
        visible: showActionButton,
        child: _widgetWithPadding(widget: _getContextButton(), top: 200.0),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _getProgressTexts(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _getTimer(),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _drawQuestionBubble(),
                  _drawImage(),
                  _drawAnswerInput(),
                ],
              ),
            ),
            _drawScoreBoardButton(),
          ],
        ),
      ),
    );
  }

  Widget _drawAnswerInput() {
    return _widgetWithPadding(
      widget: answerInputField,
      left: 8.0,
      right: 8.0,
    );
  }

  Widget _drawImage() {
    return _widgetWithPadding(
      widget: img.child,
      left: 30.0,
    );
  }

  Widget _drawScoreBoardButton() {
    return Visibility(
      visible: isCompleted,
      child: Center(
        child: RaisedButton(
          color: Colors.lightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
          ),
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '历史成绩',
            style: TextStyle(
              fontFamily: styles.fontFamily,
              fontSize: 22.0,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            _showScoreBoard();
          },
        ),
      ),
    );
  }
}
