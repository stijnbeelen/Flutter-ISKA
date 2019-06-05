import 'package:flutter/material.dart';
import 'package:iska_quiz/objects/question.dart';
import 'package:iska_quiz/quiz/quiz_bloc.dart';

class QuizPage extends StatefulWidget {
  static String tag = "quizpage";

  @override
  State<StatefulWidget> createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  final QuizBLoC bloc = QuizBLoC();
  final quizController = TextEditingController();

  num currentQuestionIndex = 1;

  @override
  void initState() {
    super.initState();
    bloc.newQuestionRequestEventSink
        .add(RequestNewQuestionEvent(currentQuestionIndex.toString()));
  }

  Widget _question(BuildContext context) => Container(
        margin: EdgeInsets.only(bottom: 70.0),
        child: _currentQuestion(context),
      );

  Widget _currentQuestion(BuildContext context) => StreamBuilder<Question>(
        stream: bloc.streamReceivedQuestions,
        builder: (context, questionSnapshot) {
          switch (questionSnapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: LinearProgressIndicator());
            default:
              return Text(
                questionSnapshot.data.question,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              );
          }
        },
      );

  Widget _answer(BuildContext context) => TextField(
        controller: quizController,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: 'Answer here.',
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 2.0,
              style: BorderStyle.solid,
              color: Colors.blue,
            ),
          ),
        ),
      );

  Widget _button(BuildContext context) => RaisedButton(
        onPressed: () => _uploadAnswer(),
        child: Text("Answer"),
      );

  // todo: refactor below code by sending ValidateAnswerEvent to QuizBLoC
  void _uploadAnswer() async {
    Question currentQuestion = await bloc.streamReceivedQuestions.first;
    String expectedAnswer = currentQuestion.answer;
    String insertedAnswer = quizController.text;

    quizController.clear();

    if (expectedAnswer == insertedAnswer) {
      currentQuestionIndex += 1;
      bloc.newQuestionRequestEventSink
          .add(RequestNewQuestionEvent(currentQuestionIndex.toString()));

      // todo: increment user score
    }
  }

  @override
  void dispose() {
    quizController.dispose();
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //todo: retrieve user's name from login_bloc somehow
        //todo: perhaps use a behavior subject in login_bloc?
        /*title: Text('Quiz - ${QuizState.name}'),*/
        title: Text('Quiz'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 300,
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
