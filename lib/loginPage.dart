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

    checkAndCreate(playerId, userRef);
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

  checkAndCreate(String playerId, DocumentReference playerReference) async {
    await Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snap = await transaction.get(playerReference);
      if (snap.exists) {
        showError("${snap.documentID} already exists.");
      } else {
        QuizState.currentPlayer = new Player(snap.documentID, playerReference);
        await transaction.set(
            playerReference, QuizState.currentPlayer.toJson());
        Navigator.of(context).pushReplacementNamed(QuizPage.tag);
      }
    });
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
