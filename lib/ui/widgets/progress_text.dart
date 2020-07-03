import 'package:flutter/material.dart';
import 'package:math_exercise/ui/global/styles.dart' as styles;

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
          fontFamily: styles.fontFamily,
          fontSize: 16.0,
          color: Colors.black,
        ));
  }
}
