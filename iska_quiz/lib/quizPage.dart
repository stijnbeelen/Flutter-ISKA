import 'package:flutter/material.dart';
import 'package:iska_quiz/quizState.dart';

class QuizPage extends StatefulWidget {
  static String tag = "quizpage";

  @override
  State<StatefulWidget> createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  final quizController = TextEditingController();

  @override
  void dispose() {
    quizController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz - ${QuizState.name}'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('First question: '),
            TextField(
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
            ),
            RaisedButton(
              onPressed: () => print("Quiz is starting")
              ,
              child: Text("Start Quiz"),
            )
          ],
        ),
      ),
    );
  }
}