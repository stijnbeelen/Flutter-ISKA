import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iska_quiz/loginLayout.dart';
import 'package:iska_quiz/quizPage.dart';
import 'package:iska_quiz/quizState.dart';

class LoginPage extends StatefulWidget {
  static String tag = "login-page";

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String username = "";
  String errorMessage = "";

  void startQuiz(String id) {
    clearError();
    var userRef = users().document(id);

    userRef.get()
        .then((snapshot) => checkAndCreate(userRef, snapshot),
        onError: (error) => this.showError('Something went wrong'));
  }

  void clearError() {
    print(username);
    setState(() {
      errorMessage = "";
    });
    print(username);
  }

  void showError(String text) {
    setState(() {
      errorMessage = text;
    });
  }

  checkAndCreate(DocumentReference reference, DocumentSnapshot snapshot) {
    print("User " + snapshot.documentID + (snapshot.exists ? " already exists." : " was created."));
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoginLayout(this);
  }
}
