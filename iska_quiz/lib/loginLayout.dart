import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iska_quiz/components/core/button.dart';
import 'package:iska_quiz/components/logoImage.dart';
import 'package:iska_quiz/components/strings.dart';
import 'package:iska_quiz/loginPage.dart';

class LoginLayout extends StatelessWidget {
  final LoginPageState loginPageState;
  final TextEditingController userNameController;

  LoginLayout(this.loginPageState)
      : userNameController =
            new TextEditingController(text: loginPageState.username);

  void _handleStart() {
    if (this.userNameController.text.isNotEmpty) {
      this.loginPageState.startQuiz(this.userNameController.text);
    }
  }

  void _clearError(String newValue) {
    //this.loginPageState.showError("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Strings.title),
          centerTitle: true,
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(60.0),
                  child: new IskaLogo(),
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text(Strings.hypeText,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16)),
                ),
                Container(
                  child: new TextField(
                    controller: this.userNameController,
                    decoration: new InputDecoration(hintText: 'Username'), onChanged: _clearError,
                  ),
                  width: 250,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                ),
                Container(
                    child: Text(this.loginPageState.errorMessage,
                        style: new TextStyle(color: Colors.red)),
                    width: 200,
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                Container(
                  padding: EdgeInsets.only(
                      left: 60.0, top: 50.0, right: 60.0, bottom: 60.0),
                  child: IskaButton(
                      onPressed: _handleStart,
                      text: Strings.startQuiz,
                      width: 250,
                      height: 70),
                ),
              ],
            ),
          ),
        ));
  }
}
