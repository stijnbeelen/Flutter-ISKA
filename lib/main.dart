import 'package:flutter/material.dart';
import 'package:iska_quiz/lobby/lobby_page.dart';
import 'package:iska_quiz/login/login_page.dart';
import 'package:iska_quiz/quiz/quiz_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = (dynamic arguments) =>
  <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    QuizPage.tag: (context) => QuizPage(arguments['questionIndex']),
    LobbyPage.tag: (context) => LobbyPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IsKahoot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: LoginPage.tag,
      onGenerateRoute: (RouteSettings settings) =>
          MaterialPageRoute(builder: (ctx) => routes(settings.arguments)[settings.name](ctx)),
    );
  }
}
