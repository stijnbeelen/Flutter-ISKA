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

  final List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.purple
  ];

  @override
  void initState() {
    super.initState();
    bloc.newQuestionRequestEventSink
        .add(RequestNewQuestionEvent(currentQuestionIndex.toString()));
  }

  Widget _question(BuildContext context) =>
      Container(child: _currentQuestion(context));

  Widget _currentQuestion(BuildContext context) => StreamBuilder<Question>(
        stream: bloc.streamReceivedQuestions,
        builder: (context, questionSnapshot) {
          switch (questionSnapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: LinearProgressIndicator());
            default:
              return Center(
                child: Text(
                  questionSnapshot.data.question,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
              );
          }
        },
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
        title: Text('Quiz'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: _question(context)),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: StreamBuilder(
                stream: bloc.streamReceivedQuestions,
                builder: (context, snapshot) {
                  final Question question = snapshot.data;
                  return GridView.count(
                    primary: true,
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    children: List.generate(
                      question?.options?.length ?? 0,
                      (index) {
                        return Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: colors[index],
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {},
                              child: Center(
                                child: Text(
                                  question.options[index],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
