import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_exercise/model/question.dart';
import 'package:math_exercise/model/question_result.dart';
import 'package:math_exercise/ui/components/answer_input_decoration.dart';
import 'package:math_exercise/ui/components/question_bubble.dart';
import 'package:math_exercise/ui/image/image_animation.dart';
import 'package:math_exercise/ui/image/image_animation_entry.dart';
import 'package:math_exercise/ui/image/image_dialog.dart';
import 'package:math_exercise/ui/image/image_styles.dart';
import 'package:math_exercise/ui/image/img.dart';
import 'package:math_exercise/ui/review/review_page.dart';
import 'package:math_exercise/ui/widgets/progress_text.dart';

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
          if (isLastCorrect) {
            combo++;
          }
          correctCount++;
          isLastCorrect = true;
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
      question = QuestionResult(total: numOfExercise, correct: correctCount);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Visibility(
        visible: showActionButton,
        child: Padding(
          padding: const EdgeInsets.only(top: 250),
          child: FloatingActionButton(
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
          ),
        ),
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
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 160,
                    ),
                    child: QuestionBubble(text: question.getQuestion()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 50,
                    ),
                    child: img.child,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: answerInputField,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
