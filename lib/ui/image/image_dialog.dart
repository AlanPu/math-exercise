import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {

  final int index;

  ImageDialog({this.index});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 100,
        height: 60 * (10 - index).toDouble(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage('assets/images/multiply_table_$index.png'),
                fit: BoxFit.fitHeight)),
      ),
    );
  }
}
