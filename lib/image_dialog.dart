import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        height: 100,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage('assets/images/multiply_table.png'),
                fit: BoxFit.fitWidth)),
      ),
    );
  }
}
