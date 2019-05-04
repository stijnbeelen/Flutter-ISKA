import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iska_quiz/firestoreHelper.dart';
import 'package:iska_quiz/loginLayout.dart';
import 'package:iska_quiz/objects/player.dart';
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

  void startQuiz(String playerId) async {
    clearError();
    var userRef = FirestoreHelper.players.document(playerId);

    userRef.get()
        .then((snapshot) => checkAndCreate(userRef, snapshot),
        onError: (error) => this.showError("Something went wrong while creating user $playerId"));
  }

  void clearError() {
    setState(() {
      errorMessage = "";
    });
  }

  void showError(String text) {
    setState(() {
      errorMessage = text;
    });
  }

  checkAndCreate(DocumentReference playerReference, DocumentSnapshot snapshot) {
    print("Player ${snapshot.documentID} ${snapshot.exists ? " already exists" : " was created"}.");

    if (snapshot.exists) {
      showError("${snapshot.documentID} already exists.");
    } else {
      Firestore.instance.runTransaction((transaction) async {
        QuizState.currentPlayer = new Player(snapshot.documentID, playerReference);
        await transaction.set(playerReference, QuizState.currentPlayer.toJson());

        Navigator.of(context).pushReplacementNamed(QuizPage.tag);
      });
    }
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
