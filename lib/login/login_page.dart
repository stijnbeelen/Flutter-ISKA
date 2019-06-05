import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iska_quiz/login/login_bloc.dart';
import 'package:iska_quiz/quiz/quiz_page.dart';
import 'package:iska_quiz/widgets/core/iska_button.dart';
import 'package:iska_quiz/widgets/iska_logo.dart';
import 'package:iska_quiz/widgets/strings.dart';

class LoginPage extends StatefulWidget {
  static String tag = "loginpage";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginBLoC loginBLoC = LoginBLoC();
  final TextEditingController usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loginBLoC.streamLoginSuccess.listen((loginSucceeded) {
      if (loginSucceeded)
        Navigator.of(context).pushReplacementNamed(QuizPage.tag);
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    loginBLoC.dispose();
    super.dispose();
  }

  void _attemptLogin() {
    final username = usernameController.text;
    if (username.isNotEmpty) loginBLoC.loginEventSink.add(LoginEvent(username));
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
            children: [
              Padding(
                padding: EdgeInsets.all(60),
                child: IskaLogo(),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  Strings.hypeText,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Container(
                width: 250,
                margin: EdgeInsets.only(bottom: 10),
                child: TextField(
                  controller: this.usernameController,
                  decoration: InputDecoration(hintText: 'Username'),
                ),
              ),
              Container(
                width: 250,
                margin: EdgeInsets.all(10),
                child: StreamBuilder(
                  stream: loginBLoC.streamLoginError,
                  initialData: null,
                  builder: (context, snapshot) => snapshot.data != null
                      ? Text(
                          snapshot.data,
                          style: TextStyle(color: Colors.red),
                        )
                      : Container(),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(60, 50, 60, 60),
                child: IskaButton(
                  onPressed: _attemptLogin,
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
