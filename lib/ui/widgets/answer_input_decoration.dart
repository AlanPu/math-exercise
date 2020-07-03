import 'package:flutter/material.dart';

class AnswerInputDecoration extends InputDecoration {
  @override
  final hintText = '输入答案...';

  @override
  final hintStyle = TextStyle(color: Colors.grey);

  @override
  final filled = true;

  @override
  final fillColor = Colors.white70;

  @override
  final enabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
    borderSide: BorderSide(color: Colors.lightBlue, width: 2),
  );

  @override
  final focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
    borderSide: BorderSide(color: Colors.lightBlue),
  );
}
