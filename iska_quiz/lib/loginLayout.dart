import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iska_quiz/loginPage.dart';

class LoginLayout extends StatelessWidget {
  final LoginPageState loginPageState;

  LoginLayout(this.loginPageState);

  void _handleStart() {
    this.loginPageState.startQuiz();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Quiz'),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(child: Image(image: AssetImage("lib/img/is_logo.png")), padding: EdgeInsets.all(50.0),),
              Container(child: RaisedButton(onPressed: _handleStart, child: Text('Start Quiz')), width: 150,)
            ],
          ),
        ));
  }
}
