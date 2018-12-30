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
    var id = loginController.text;
    var userRef = users().document(id);

    userRef.get().then((snapshot) => checkAndCreate(userRef, snapshot),
        onError: (error) => this.showError('Something went wrong'));
  }

  void showError(String text) {
    setState(() {
      errorMessage = text;
    });
  }

  checkAndCreate(DocumentReference reference, DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      showError(snapshot.documentID + ' already exists.');
    } else {
      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(reference, {});
        QuizState.name = snapshot.documentID;
        Navigator.of(context).pushReplacementNamed(QuizPage.tag);
      });
    }
  }

  CollectionReference users() {
    return Firestore.instance.collection('users');
  }

  @override
  void dispose() {
    loginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                textAlign: TextAlign.center,
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
