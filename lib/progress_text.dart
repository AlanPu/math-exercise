import 'package:flutter/material.dart';

class ProgressText {
  String label;
  int value;

  ProgressText({String label, int value = 0}) {
    this.label = label;
    this.value = value;
  }

  setValue(int value) => this.value = value;

  build() {
    return Text('$label: $value',
        style: TextStyle(
          fontFamily: 'NotoSerifSC-Medium',
          fontSize: 16.0,
          color: Colors.black,
        ));
  }
}
