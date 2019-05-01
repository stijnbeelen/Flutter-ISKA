import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iska_quiz/components/core/button.dart';
import 'package:iska_quiz/components/logoImage.dart';
import 'package:iska_quiz/components/strings.dart';
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(60.0),
                child: new IskaLogo(),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: Text(Strings.hypeText, textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
              ),
              Container(
                padding: EdgeInsets.all(60.0),
                child: IskaButton(
                    onPressed: _handleStart,
                    text: Strings.startQuiz,
                    width: 250,
                    height: 70),
              )
            ],
          ),
        ));
  }
}
