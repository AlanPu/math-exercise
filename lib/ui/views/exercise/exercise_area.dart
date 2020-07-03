import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_exercise/model/question.dart';
import 'package:math_exercise/model/question_result.dart';
import 'package:math_exercise/ui/widgets/answer_input_decoration.dart';
import 'package:math_exercise/ui/widgets/question_bubble.dart';
import 'package:math_exercise/ui/image/image_animation.dart';
import 'package:math_exercise/ui/image/image_animation_entry.dart';
import 'package:math_exercise/ui/image/image_dialog.dart';
import 'package:math_exercise/ui/image/image_styles.dart';
import 'package:math_exercise/ui/image/img.dart';
import 'package:math_exercise/ui/views/review_page.dart';
import 'package:math_exercise/ui/widgets/progress_text.dart';
import 'package:math_exercise/ui/global/styles.dart' as styles;
import 'package:math_exercise/ui/views/score_board.dart';

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

  @override
  void initState() {
    super.initState();

    showActionButton = (question.type == QuestionType.multiply ||
        question.type == QuestionType.division);

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

  void _showScoreBoard() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScoreBoard(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Visibility(
        visible: showActionButton,
        child: _widgetWithPadding(widget: _getContextButton(), top: 250.0),
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
            Container(
              margin: EdgeInsets.only(
                top: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _widgetWithPadding(
                    widget: QuestionBubble(text: question.getQuestion()),
                    left: 160.0,
                  ),
                  _widgetWithPadding(
                    widget: img.child,
                    left: 50.0,
                  ),
                  _widgetWithPadding(
                      widget: answerInputField, left: 8.0, right: 8.0),
                ],
              ),
            ),
            Visibility(
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
            ),
          ],
        ),
      ),
    );
  }
}
