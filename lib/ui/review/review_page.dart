import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:math_exercise/model/question.dart';

class ReviewPage extends StatelessWidget {
  final List<Question> wrongAnswers;
  final double _fontSize = 16;

  ReviewPage({this.wrongAnswers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('错题回顾'),
      ),
      body: _showTable(context),
    );
  }

  _showTable(BuildContext context) {
    return Container(
      child: HorizontalDataTable(
        leftHandSideColumnWidth: 50,
        rightHandSideColumnWidth: MediaQuery.of(context).size.width - 50,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: wrongAnswers.length,
        rowSeparatorWidget: const Divider(
          color: Colors.black54,
          height: 1.0,
          thickness: 0.0,
        ),
        leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
        rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
      ),
      height: MediaQuery.of(context).size.height,
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('', 50),
      _getTitleItemWidget('题目', 120),
      _getTitleItemWidget('正确答案', 80),
      _getTitleItemWidget('你的答案', 80),
    ];
  }

  // Header
  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: _fontSize,
        ),
      ),
      width: width,
      height: 46,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  // Index column
  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text(
        (index + 1).toString(),
        style: TextStyle(
          fontSize: _fontSize,
        ),
      ),
      width: 50,
      height: 40,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  // Non-index columns
  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        getCell(
          index: index,
          label: wrongAnswers[index].getQuestion(),
          width: 120,
          height: 40,
        ),
        getCell(
          index: index,
          label: wrongAnswers[index].correctAnswer.toString(),
          width: 80,
          height: 40,
        ),
        getCell(
          index: index,
          label: wrongAnswers[index].wrongAnswer.toString(),
          width: 80,
          height: 40,
        ),
      ],
    );
  }

  getCell({int index, String label, double width, double height}) {
    return Container(
      child: getContentText(label),
      width: width,
      height: height,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  getContentText(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: _fontSize,
      ),
    );
  }
}
