import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iska_quiz/components/style/textstyle.dart';

class IskaButton extends StatelessWidget {
  IskaButton(
      {@required this.onPressed,
      this.text,
      this.width = 100,
      this.height = 80});

  final GestureTapCallback onPressed;
  final double width;
  final double height;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
        child: RaisedButton(
          onPressed: this.onPressed,
          child:
              Text(this.text, style: CustomTextStyle.fromSize(context, 18.0, color: Colors.white)),
        ),
        minWidth: this.width,
        height: this.height);
  }
}
