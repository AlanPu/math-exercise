import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
  final bool isCountDownMode;

  ExerciseArea(
      {Key key,
      @required this.numRange,
      @required this.numOfExercise,
      @required this.isCountDownMode})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExerciseAreaState(
        numOfExercise: numOfExercise,
        numRange: numRange,
        isCountDownMode: isCountDownMode,
      );
}

class _ExerciseAreaState extends State<ExerciseArea> {
  static const int COUNT_DOWN_SECOND_EASY = 10;
  static const int COUNT_DOWN_SECOND_HARD = 20;
  static const String BLANK_ANSWER = '-';

  bool isCountDownMode;
  int numRange;
  int numOfExercise;

  int _currentNum = 1;
  int _correctCount = 0;
  int _combo = 0;
  int _maxCombo = 0;
  Question _question;
  bool _isLastCorrect = false;
  final _answerTextController = TextEditingController();
  FocusNode _answerFocusNode = FocusNode();
  TextField _answerInputField;
  bool _showActionButton = false;
  bool _isCompleted = false;
  bool _pause = false;
  List<Question> _wrongAnswers = List<Question>();
  int _totalSecond = 0;
  int _countDownSecond = 0;
  Widget _totalTimeText;
  Widget _countDownText;
  Timer _timer;
  bool _gettingReady = true;

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

  _ExerciseAreaState(
      {@required this.numRange,
      @required this.numOfExercise,
      @required this.isCountDownMode})
      : super() {
    _question = Question.next(min: 0, max: numRange);
    _calculateCountDownSecond();
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
      if (_isCompleted) {
        timer.cancel();
        return;
      }
      if (!_pause) {
        _totalSecond++;
      }

      if (isCountDownMode && !_pause) {
        if (_countDownSecond > 0) {
          _countDownSecond--;
        } else {
          _pause = true;
          _submitAnswer(BLANK_ANSWER);
        }
      }
      setState(() {
        _totalTimeText = _getTotalTimeText();
        _countDownText = _getCountDownText();
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

    _showActionButton = (_question.type == QuestionType.multiply ||
        _question.type == QuestionType.division);

    _totalTimeText = _getTotalTimeText();

    _countDownText = _getCountDownText();

    _answerInputField = TextField(
        focusNode: _answerFocusNode,
        controller: _answerTextController,
        autocorrect: false,
        keyboardType: TextInputType.number,
        decoration: AnswerInputDecoration(),
        onSubmitted: (value) => _submitAnswer(value));

    if (!isCountDownMode) {
      _startTimeCounter();
    }
  }

  void _submitAnswer(value) {
    _pause = true;
    if (_question.isCorrect(value)) {
      setState(() {
        img.setChild(getImageAnimation(2, 3));
      });
      _correctCount++;
      _isLastCorrect = true;
      if (_isLastCorrect) {
        _combo++;
        if (_maxCombo < _combo) {
          _maxCombo = _combo;
        }
      }
    } else {
      _question.wrongAnswer = value;
      _wrongAnswers.add(_question);
      setState(() {
        img.setChild(imgSadFace);
      });
      _isLastCorrect = false;
      _combo = 0;
    }
    Timer(Duration(seconds: 2), () {
      if (_currentNum == numOfExercise) {
        _completeExercise();
      } else {
        _nextQuestion();
        _pause = false;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      img.setChild(imgHappyFace);
      _currentNum++;
      _question = Question.next(min: 0, max: numRange);
      _calculateCountDownSecond();
      _showActionButton = (_question.type == QuestionType.multiply ||
          _question.type == QuestionType.division);
      _answerTextController.clear();
      _answerFocusNode.requestFocus();
    });
  }

  void _calculateCountDownSecond() {
    _countDownSecond += _question.type == QuestionType.combined
        ? COUNT_DOWN_SECOND_HARD
        : COUNT_DOWN_SECOND_EASY;
  }

  void _completeExercise() {
    _isCompleted = true;
    _showActionButton = _wrongAnswers.length > 0;
    setState(() {
      _answerFocusNode.unfocus();
      _answerTextController.clear();
      _answerInputField = TextField(enabled: false);
      _question = QuestionResult(
        total: numOfExercise,
        correct: _correctCount,
        score: _calculateScore(),
      );
      img.setChild(imgHappyFace);
    });

    _saveToDb();
  }

  void _saveToDb() {
    LocalDb().insert(Score(
      total: numOfExercise,
      correct: _correctCount,
      combo: _maxCombo,
      score: _calculateScore(),
      time: _formatTime(second: _totalSecond),
    ));
  }

  List<Widget> _getProgressTexts() {
    return [
      ProgressText(
        label: '当前题数',
        value: _currentNum,
      ).build(),
      ProgressText(
        label: '正确题数',
        value: _correctCount,
      ).build(),
      ProgressText(
        label: '连击数',
        value: _combo,
      ).build(),
    ];
  }

  void _showReviewPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReviewPage(wrongAnswers: _wrongAnswers),
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
      child: Icon(_isCompleted ? Icons.rate_review : Icons.info),
      onPressed: () {
        if (!_isCompleted) {
          showDialog(
            context: context,
            builder: (_) => ImageDialog(index: _question.tips),
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
    double score = _correctCount / numOfExercise * 100;
    if (score != score.toInt()) {
      score = score.toInt() + 0.5;
    }
    return score;
  }

  Widget _drawQuestionBubble() {
    return _widgetWithPadding(
      widget: QuestionBubble(text: _question.getQuestion()),
      left: 130.0,
    );
  }

  String _formatTime({int minute = 0, int second = 0}) {
    minute += second ~/ 60;
    second = second % 60;
    var m = minute.toString().padLeft(2, '0');
    var s = second.toString().padLeft(2, '0');
    return '$m:$s';
  }

  List<Widget> _getTimer() {
    return [
      _totalTimeText,
      _countDownText,
    ];
  }

  Widget _getTotalTimeText() {
    return Text(
      '用时：${_formatTime(second: _totalSecond)}',
      style: TextStyle(
        fontFamily: styles.fontFamily,
        fontSize: 16.0,
        color: Colors.black,
      ),
    );
  }

  Widget _getCountDownText() {
    return Visibility(
      visible: isCountDownMode,
      child: Text('倒计时：${_formatTime(second: _countDownSecond)}',
          style: TextStyle(
            fontFamily: styles.fontFamily,
            fontSize: 16.0,
            color: Colors.black,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          floatingActionButton: Visibility(
            visible: _showActionButton,
            child: _widgetWithPadding(widget: _getContextButton(), top: 100.0),
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
        ),
        _getReadyCountDown(),
      ],
    );
  }

  Widget _getReadyCountDown() {
    if (isCountDownMode) {
      return Visibility(
        visible: _gettingReady,
        child: Positioned.fill(
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: ScaleAnimatedTextKit(
              duration: Duration(milliseconds: 1500),
              pause: Duration(microseconds: 200),
              repeatForever: false,
              totalRepeatCount: 1,
              text: ['3', '2', '1', 'Go!'],
              textStyle: TextStyle(
                fontSize: 90.0,
                fontFamily: styles.fontFamily,
                color: Colors.lightBlue,
              ),
              textAlign: TextAlign.start,
              alignment: AlignmentDirectional.topStart,
              onFinished: () {
                setState(() {
                  _gettingReady = false;
                  _startTimeCounter();
                });
              },
            ),
          ),
        ),
      );
    } else {
      return Visibility(
        visible: false,
        child: Container(),
      );
    }
  }

  Widget _drawAnswerInput() {
    return _widgetWithPadding(
      widget: _answerInputField,
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
      visible: _isCompleted,
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
