import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

class ScoreBoard extends StatelessWidget {
  final double _fontSize = 16;
  final columnWidth = [120.0, 70.0, 70.0, 70.0, 70.0];

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
        leftHandSideColumnWidth: columnWidth[0],
        rightHandSideColumnWidth: MediaQuery.of(context).size.width - columnWidth[0],
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: 3,
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
      _getTitleItemWidget('日期', columnWidth[0]),
      _getTitleItemWidget('出题数', columnWidth[1]),
      _getTitleItemWidget('正确数', columnWidth[2]),
      _getTitleItemWidget('分数', columnWidth[3]),
      _getTitleItemWidget('连击数', columnWidth[4]),
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
        '2020-06-01',
        style: TextStyle(
          fontSize: _fontSize,
        ),
      ),
      width: columnWidth[0],
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
          label: '30', // 出题数
          width: columnWidth[1],
          height: 40,
        ),
        getCell(
          index: index,
          label: '30', // 正确数
          width: columnWidth[2],
          height: 40,
        ),
        getCell(
          index: index,
          label: '99.5',  // 分数
          width: columnWidth[3],
          height: 40,
        ),
        getCell(
          index: index,
          label: '30',  // 连击数
          width: columnWidth[3],
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
