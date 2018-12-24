import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iska_quiz/quizPage.dart';
import 'package:iska_quiz/quizState.dart';

class LoginPage extends StatefulWidget {
  static String tag = "login-page";

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final loginController = TextEditingController();
  String errorMessage = "";

  void _startQuiz() {
    QuizState.name = loginController.text;

    DocumentReference ref =
        Firestore.instance.document('users/' + QuizState.name);

    ref.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        print('existing name');
        errorMessage =
            "That username is already taken. Please choose another one.";
      } else {
        Firestore.instance
            .collection('users')
            .document(QuizState.name)
            .setData({});
        Navigator.of(context).pushReplacementNamed(QuizPage.tag);
      }
    });
  }

  @override
  void dispose() {
    loginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Quiz'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 300.0,
                child: (TextField(
                  controller: loginController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.0,
                        style: BorderStyle.solid,
                        color: Colors.blue,
                      ),
                    ),
                    hintText: 'Please enter your name.',
                  ),
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ))),
            RaisedButton(
              onPressed: _startQuiz,
              child: Text("Start Quiz"),
            ),
            Container(
              width: 250.0,
              child: Text(
                errorMessage,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
