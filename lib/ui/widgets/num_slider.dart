import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NumSlider {
  String label;
  int min;
  int max;
  int value;
  EdgeInsets margin;

  NumSlider({String label, int min, int max, int value, EdgeInsets margin}) {
    this.label = label;
    this.min = min;
    this.max = max;
    this.value = value;
    this.margin = margin;
  }

  void setValue(int newValue) {
    this.value = newValue;
  }

  build({void onChanged(int newValue)}) {
    return Container(
      // Number range
      decoration: BoxDecoration(
        color: Colors.lightBlue,
      ),
      padding: EdgeInsets.only(
        left: 10,
      ),
      margin: this.margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Text(
                  '$label:',
                  style: TextStyle(
                    fontFamily: 'NotoSerifSC-Medium',
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                '$value',
                style: TextStyle(
                  fontFamily: 'NotoSerifSC-Medium',
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 5,
                ),
                width: 145,
                child: CupertinoSlider(
                  value: this.value.toDouble(),
                  min: this.min.toDouble(),
                  max: this.max.toDouble(),
                  divisions: 100,
                  activeColor: Colors.white,
                  thumbColor: Colors.white,
                  onChanged: (double newValue) {
                    this.value = newValue.round();
                    onChanged(this.value);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
