import 'package:flutter/material.dart';
import 'package:iska_quiz/lobby/lobby_page.dart';
import 'package:iska_quiz/login/login_page.dart';
import 'package:iska_quiz/quiz/quiz_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    QuizPage.tag: (context) => QuizPage(),
    LobbyPage.tag: (context) => LobbyPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: routes,
    );
  }
}
