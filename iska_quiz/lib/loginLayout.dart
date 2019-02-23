import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iska_quiz/loginPage.dart';

class LoginLayout extends StatelessWidget {
  final LoginPageState loginPageState;
  final TextEditingController userNameController;

  LoginLayout(this.loginPageState)
      : userNameController = new TextEditingController(text: loginPageState.username);

  void _handleStart() {
    if (this.userNameController.text.isNotEmpty) {
      this.loginPageState.startQuiz(this.userNameController.text);
    }
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
              Container(
                child: Image(image: AssetImage("lib/img/is_logo.png")),
                padding: EdgeInsets.all(50.0),
              ),
              Container(
                child: new TextField(
                  controller: this.userNameController,
                  decoration: new InputDecoration(hintText: 'Username'),
                ),
                width: 250,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              ),
              Container(
                  child: Text(this.loginPageState.errorMessage,
                      style: new TextStyle(color: Colors.red)),
                  width: 150,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10)),
              Container(
                child: RaisedButton(
                    onPressed: _handleStart, child: Text('Start Quiz')),
                width: 150,
              )
            ],
          ),
        ));
  }
}
