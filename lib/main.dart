import 'package:flutter/material.dart';
import 'package:iska_quiz/loginPage.dart';
import 'package:iska_quiz/quizPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    QuizPage.tag: (context) => QuizPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
//      home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: LoginPage(),
      routes: routes,
    );
  }
}