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

  //todo: retrieve questions from firestore + store questions

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
            print(id);
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

  @override
  void dispose() {
    quizController.dispose();
    super.dispose();
  }

  Widget _question(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 70.0),
      child: _currentQuestion(context)
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
      onPressed: () => print("Quiz is starting"),
      child: Text("Answer"),
    );
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
