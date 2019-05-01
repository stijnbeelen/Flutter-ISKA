import 'package:flutter/material.dart';
import 'package:iska_quiz/quizState.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizPage extends StatefulWidget {
  static String tag = "quizpage";

  @override
  State<StatefulWidget> createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  final quizController = TextEditingController();


  @override
  void initState() {
    super.initState();

    Firestore.instance.collection("questions").snapshots().forEach((snapshot) {
      snapshot.documents.forEach((docSnapshot) {
        if (docSnapshot.documentID != "current") {
          if (!QuizState.questions.contains(docSnapshot['question'])) {
            QuizState.questions.add(docSnapshot['question']);
          }
        }
      });
    });

    print(QuizState.questions);
  }

  //todo: retrieve questions from firestore + store questions

  Widget _question(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 70.0),
      child: _currentQuestion(context)
    );
  }

  Widget _currentQuestion(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection('questions')
          .document('current')
          .snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(child: LinearProgressIndicator());
          default:
            var id = snapshot.data.data.values.first;
            QuizState.currentQuestion = id;
            return Text(
                QuizState.questions[id],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ));
        }
      },
    );
  }

  Widget _answer(BuildContext context) {
    return TextField(
      controller: quizController,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            style: BorderStyle.solid,
            color: Colors.blue,
          ),
        ),
        hintText: 'Answer here.',
      ),
    );
  }

  Widget _button(BuildContext context) {
    return RaisedButton(
      onPressed: () => _uploadAnswer(),
      child: Text("Answer"),
    );
  }

  void _uploadAnswer() {
    Firestore.instance.runTransaction((transaction) {
      transaction.update(QuizState.userReference, {"${QuizState.currentQuestion}" : quizController.text });
    });
  }

  @override
  void dispose() {
    quizController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz - ${QuizState.name}'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 300.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _question(context),
              _answer(context),
              _button(context),
            ],
          ),
        ),
      ),
    );
  }
}
