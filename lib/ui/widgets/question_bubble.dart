import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';

class QuestionBubble extends Bubble {
  // @override
  // final margin = BubbleEdges.only(top: 10);

  // @override
  // final stick = true;

  // @override
  // final alignment = Alignment.bottomLeft;

  // @override
  // final nip = BubbleNip.leftBottom;

  // @override
  // final elevation = 2;

  // @override
  // final color = Color.fromRGBO(225, 255, 199, 1.0);

  QuestionBubble({String text})
      : super(
          margin: BubbleEdges.only(top: 10),
          stick: true,
          nip: BubbleNip.leftBottom,
          elevation: 2,
          color: Color.fromRGBO(225, 255, 199, 1.0),
          child: Text(
            text,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 21.0,
            ),
          ),
        );
}
