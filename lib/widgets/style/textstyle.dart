import 'dart:ui';

import 'package:flutter/material.dart';

class CustomTextStyle {
  static TextStyle fromSize(BuildContext context, double size, {Color color = Colors.white}) {
    return Theme.of(context).primaryTextTheme.display1.copyWith(fontSize: size, color: color);
  }
}