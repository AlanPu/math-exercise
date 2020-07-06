import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:math_exercise/model/score.dart';

class ScoreBoard extends StatelessWidget {
  final double _fontSize = 16;
  final _columnWidth = [100.0, 65.0, 65.0, 65.0, 65.0, 100.0];
  final _rightHandSideColumnWidth = 360.0;
  final List<Score> scores;

  ScoreBoard({this.scores});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('历史成绩'),
      ),
      body: _showTable(context),
    );
  }

  _showTable(BuildContext context) {
    return Container(
      child: HorizontalDataTable(
        leftHandSideColumnWidth: _columnWidth[0],
        rightHandSideColumnWidth: _rightHandSideColumnWidth,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: scores?.length,
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
      _getTitleItemWidget('日期', _columnWidth[0]),
      _getTitleItemWidget('出题数', _columnWidth[1]),
      _getTitleItemWidget('正确数', _columnWidth[2]),
      _getTitleItemWidget('分数', _columnWidth[3]),
      _getTitleItemWidget('连击数', _columnWidth[4]),
      _getTitleItemWidget('时间', _columnWidth[5]),
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
        scores[index].date,
        style: TextStyle(
          fontSize: _fontSize,
        ),
      ),
      width: _columnWidth[0],
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
          label: scores[index].total, // 出题数
          width: _columnWidth[1],
          height: 40,
        ),
        getCell(
          index: index,
          label: scores[index].correct, // 正确数
          width: _columnWidth[2],
          height: 40,
        ),
        getCell(
          index: index,
          label: scores[index].score, // 分数
          width: _columnWidth[3],
          height: 40,
        ),
        getCell(
          index: index,
          label: scores[index].combo, // 连击数
          width: _columnWidth[4],
          height: 40,
        ),
        getCell(
          index: index,
          label: scores[index].time, // 时间
          width: _columnWidth[5],
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
