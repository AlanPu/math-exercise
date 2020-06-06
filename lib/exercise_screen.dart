import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_exercise/progress_text.dart';
import 'package:math_exercise/question.dart';
import 'package:math_exercise/question_add.dart';

class ExerciseScreen extends StatelessWidget {
  final int numRange;
  final int numOfExercise;

  ExerciseScreen(
      {Key key, @required this.numRange, @required this.numOfExercise})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('计算练习'),
      ),
      body: ExerciseArea(
        numOfExercise: numOfExercise,
        numRange: numRange,
      ),
    );
  }
}

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
  final answerFocusNode = FocusNode();

  _ExerciseAreaState({@required this.numRange, @required this.numOfExercise})
      : super() {
    question = Question.next(min: 0, max: numRange);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
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
            ],
          ),
          Container(
            margin: EdgeInsets.only(
              top: 70,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 160,
                  ),
                  child: Bubble(
                    margin: BubbleEdges.only(top: 10),
                    stick: true,
                    alignment: Alignment.bottomLeft,
                    nip: BubbleNip.leftBottom,
                    elevation: 2,
                    color: Color.fromRGBO(225, 255, 199, 1.0),
                    child: Text(
                      question.getQuestion(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 50,
                  ),
                  child: Image.asset(
                    'assets/images/pico-a.jpg',
                    width: 150,
                    height: 150,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                  ),
                  child: TextField(
                    focusNode: answerFocusNode,
                    controller: answerTextController,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '输入答案...',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white70,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide:
                            BorderSide(color: Colors.lightBlue, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.lightBlue),
                      ),
                    ),
                    onSubmitted: (String value) {
                      setState(() {
                        answer = int.parse(value);
                        if (question.isCorrect(answer)) {
                          if (isLastCorrect) {
                            combo++;
                          }
                          correctCount++;
                          isLastCorrect = true;
                        } else {
                          isLastCorrect = false;
                          combo = 0;
                        }
                        if (currentNum == numOfExercise) {
                        } else {
                          currentNum++;
                          question = Question.next(min: 0, max: numRange);
                          answerTextController.clear();
                          answerFocusNode.requestFocus();
                        }
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
