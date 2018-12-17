import 'package:flutter/material.dart';
import 'package:startup_namer/RandomWords.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      theme: new ThemeData(
        primaryColor: Colors.white
      ),
      home: RandomWords(),
    );
  }
}

