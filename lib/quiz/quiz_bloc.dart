import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iska_quiz/firestore_helper.dart';
import 'package:iska_quiz/objects/question.dart';

import 'package:rxdart/rxdart.dart';

class RequestNewQuestionEvent {
  String _id;

  String get id => _id;

  RequestNewQuestionEvent(this._id);
}

class FinalizeAnswerEvent {}

class SelectAnswerEvent {
  String answer;

  SelectAnswerEvent(this.answer);
}

class AnswerVerificationResult {
  bool answerWasCorrect;

  AnswerVerificationResult(this.answerWasCorrect);
}

class QuizBLoC {
  final _newQuestionRequestEventStreamController = StreamController<RequestNewQuestionEvent>();
  StreamSink<RequestNewQuestionEvent> get newQuestionRequestEventSink => _newQuestionRequestEventStreamController.sink;
  Stream<RequestNewQuestionEvent> get _streamNewQuestionRequestEvent => _newQuestionRequestEventStreamController.stream;

  final _finalizeAnswerEventStreamController = StreamController<FinalizeAnswerEvent>();
  StreamSink<FinalizeAnswerEvent> get finalizeAnswerEventSink => _finalizeAnswerEventStreamController.sink;
  Stream<FinalizeAnswerEvent> get _streamFinalizeAnswer => _finalizeAnswerEventStreamController.stream;

  final _questionReceptionStreamController = BehaviorSubject<Question>();
  StreamSink<Question> get _questionReceptionSink => _questionReceptionStreamController.sink;
  Stream<Question> get streamReceivedQuestions => _questionReceptionStreamController.stream;

  final _selectAnswerEventStreamController = BehaviorSubject<SelectAnswerEvent>();
  StreamSink<SelectAnswerEvent> get selectAnswerSink => _selectAnswerEventStreamController.sink;
  Stream<SelectAnswerEvent> get streamSelectAnswerEvent => _selectAnswerEventStreamController.stream;

  final _answerVerificationResultStreamController = StreamController<AnswerVerificationResult>.broadcast();
  StreamSink<AnswerVerificationResult> get _answerVerificationResultSink =>
      _answerVerificationResultStreamController.sink;
  Stream<AnswerVerificationResult> get streamAnswerVerificationResult => _answerVerificationResultStreamController.stream;

  void fetchQuestion(RequestNewQuestionEvent event) async {
    DocumentSnapshot documentSnapshot = await FirestoreHelper.questions.document("${event._id}").get();
    if (documentSnapshot != null && documentSnapshot.exists)
      _questionReceptionSink.add(Question.fromJson(documentSnapshot.data));
  }

  void pushAnswer(FinalizeAnswerEvent event) async {
    final String chosenAnswer = (await streamSelectAnswerEvent.first).answer;
    final String correctAnswer = (await streamReceivedQuestions.first).answer;
    _answerVerificationResultSink.add(AnswerVerificationResult(chosenAnswer == correctAnswer));
  }

  void listenToAnswerVerifications(AnswerVerificationResult result) async {
    if (result.answerWasCorrect) {
      await Firestore.instance.runTransaction((Transaction transaction) async {
        DocumentSnapshot playerSnapshot = await transaction.get(FirestoreHelper.currentPlayer);
        await transaction.update(FirestoreHelper.currentPlayer, {'score': (playerSnapshot.data['score'] as num) + 1});
      });
    }
  }

  QuizBLoC() {
    _streamNewQuestionRequestEvent.listen(fetchQuestion);
    _streamFinalizeAnswer.listen(pushAnswer);
    streamAnswerVerificationResult.listen(listenToAnswerVerifications);
  }

  dispose() {
    _questionReceptionStreamController.close();
    _finalizeAnswerEventStreamController.close();
    _newQuestionRequestEventStreamController.close();
    _selectAnswerEventStreamController.close();
    _answerVerificationResultStreamController.close();
  }
}
