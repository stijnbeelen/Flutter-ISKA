import 'package:flutter/material.dart' as loginPage;
import 'package:flutter/widgets.dart';
import 'package:iska_quiz/loginBLoC.dart';
import 'package:iska_quiz/quizPage.dart';
import 'package:iska_quiz/widgets/core/button.dart';
import 'package:iska_quiz/widgets/logoImage.dart';
import 'package:iska_quiz/widgets/strings.dart';

class LoginPage extends loginPage.StatefulWidget {
  static String tag = "loginpage";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends loginPage.State<LoginPage> {
  final LoginBLoC loginBLoC = LoginBLoC();
  final loginPage.TextEditingController usernameController =
      loginPage.TextEditingController();

  @override
  void initState() {
    loginBLoC.streamLoginSuccess.listen((loginSucceeded) {
      if (loginSucceeded)
        loginPage.Navigator.of(context).pushReplacementNamed(QuizPage.tag);
    });
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    loginBLoC.dispose();
    super.dispose();
  }

  void _handleStart() {
    final username = usernameController.text;
    if (username.isNotEmpty) loginBLoC.loginEventSink.add(LoginEvent(username));
  }

  @override
  loginPage.Widget build(loginPage.BuildContext context) {
    return loginPage.Scaffold(
      appBar: loginPage.AppBar(
        title: loginPage.Text(Strings.title),
        centerTitle: true,
      ),
      body: loginPage.Container(
        child: loginPage.SingleChildScrollView(
          child: loginPage.Column(
            mainAxisAlignment: loginPage.MainAxisAlignment.spaceEvenly,
            children: <loginPage.Widget>[
              loginPage.Container(
                padding: loginPage.EdgeInsets.all(60.0),
                child: new IskaLogo(),
              ),
              loginPage.Container(
                padding: loginPage.EdgeInsets.all(20.0),
                child: loginPage.Text(Strings.hypeText,
                    textAlign: loginPage.TextAlign.center,
                    style: loginPage.TextStyle(fontSize: 16)),
              ),
              loginPage.Container(
                child: new loginPage.TextField(
                  controller: this.usernameController,
                  decoration:
                      new loginPage.InputDecoration(hintText: 'Username'),
                ),
                width: 250,
                margin: loginPage.EdgeInsets.fromLTRB(0, 0, 0, 10),
              ),
              loginPage.Container(
                  child: loginPage.StreamBuilder(
                    stream: loginBLoC.streamLoginError,
                    initialData: null,
                    builder: (context, snapshot) => snapshot.data != null
                        ? Text(
                            snapshot.data,
                            style: new loginPage.TextStyle(
                              color: loginPage.Colors.red,
                            ),
                          )
                        : Container(),
                  ),
                  width: 200,
                  margin: loginPage.EdgeInsets.fromLTRB(10, 10, 10, 10)),
              loginPage.Container(
                padding: loginPage.EdgeInsets.only(
                  left: 60.0,
                  top: 50.0,
                  right: 60.0,
                  bottom: 60.0,
                ),
                child: IskaButton(
                  onPressed: _handleStart,
                  text: Strings.startQuiz,
                  width: 250,
                  height: 70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
