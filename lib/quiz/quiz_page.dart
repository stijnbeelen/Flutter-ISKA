import 'package:flutter/material.dart';
import 'package:iska_quiz/lobby/lobby_page.dart';
import 'package:iska_quiz/objects/question.dart';
import 'package:iska_quiz/quiz/quiz_bloc.dart';

class QuizPage extends StatefulWidget {
  static String tag = "quizpage";

  @override
  State<StatefulWidget> createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage>
    with SingleTickerProviderStateMixin {
  final QuizBLoC bloc = QuizBLoC();
  final quizController = TextEditingController();
  AnimationController controller;
  Animation<double> animation;

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

    controller =
        AnimationController(duration: const Duration(seconds: 10), vsync: this)
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) _finalizeAnswer();
          });

    animation = Tween(begin: 1.0, end: 0.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });

    controller.forward();

    // todo: show whether result.answerWasCorrect and set interval before
    // todo: going back to lobby
    bloc.streamAnswerVerificationResult.listen(
        (AnswerVerificationResult result) =>
            Navigator.of(context).pushReplacementNamed(LobbyPage.tag));
  }

  Widget _question(BuildContext context) =>
      Container(child: _currentQuestion(context));

  Widget _currentQuestion(BuildContext context) => StreamBuilder<Question>(
        stream: bloc.streamReceivedQuestions,
        builder: (context, questionSnapshot) {
          return Center(
            child: Text(
              questionSnapshot.data?.question ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          );
        },
      );

  // todo: refactor below code by sending ValidateAnswerEvent to QuizBLoC
  void _finalizeAnswer() async {
    bloc.finalizeAnswerEventSink.add(FinalizeAnswerEvent());

    /*Question currentQuestion = await bloc.streamReceivedQuestions.first;
    String expectedAnswer = currentQuestion.answer;
    String insertedAnswer = quizController.text;

    quizController.clear();

    if (expectedAnswer == insertedAnswer) {
      currentQuestionIndex += 1;
      bloc.newQuestionRequestEventSink
          .add(RequestNewQuestionEvent(currentQuestionIndex.toString()));

      // todo: increment user score
    }*/
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
            LinearProgressIndicator(
              value: animation.value,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
            ),
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
                        final String optionText = question.options[index];
                        return StreamBuilder(
                          stream: bloc.streamSelectAnswerEvent,
                          builder: (context, snapshot) {
                            return Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: snapshot.data?.answer == null ||
                                        snapshot.data?.answer == optionText
                                    ? colors[index]
                                    : colors[index].withOpacity(.4),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => bloc.selectAnswerSink
                                      .add(SelectAnswerEvent(optionText)),
                                  child: Center(
                                    child: Text(
                                      optionText,
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
