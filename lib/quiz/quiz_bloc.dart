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

class ValidateAnswerEvent {
  String _answer;

  String get answer => _answer;

  ValidateAnswerEvent(this._answer);
}

class QuizBLoC {
  final _newQuestionRequestEventStreamController = StreamController<RequestNewQuestionEvent>();
  StreamSink<RequestNewQuestionEvent> get newQuestionRequestEventSink => _newQuestionRequestEventStreamController.sink;
  Stream<RequestNewQuestionEvent> get _streamNewQuestionRequestEvent => _newQuestionRequestEventStreamController.stream;

  final _validateAnswerEventStreamController = StreamController<ValidateAnswerEvent>();
  StreamSink<ValidateAnswerEvent> get validateAnswerEventSink => _validateAnswerEventStreamController.sink;
  Stream<ValidateAnswerEvent> get _streamValidateAnswerEvent => _validateAnswerEventStreamController.stream;

  final _questionReceptionStreamController = BehaviorSubject<Question>();
  StreamSink<Question> get _questionReceptionSink => _questionReceptionStreamController.sink;
  Stream<Question> get streamReceivedQuestions => _questionReceptionStreamController.stream;

  void fetchQuestion(RequestNewQuestionEvent event) async {
    DocumentSnapshot documentSnapshot =
        await FirestoreHelper.questions.document("${event._id}").get();
    if (documentSnapshot != null && documentSnapshot.exists) {
      _questionReceptionSink.add(Question.fromJson(documentSnapshot.data));
    }
  }

  void pushAnswer(ValidateAnswerEvent event) {
    print('answer received');
  }

  QuizBLoC() {
    _streamNewQuestionRequestEvent.listen(fetchQuestion);
    _streamValidateAnswerEvent.listen(pushAnswer);
  }

  dispose() {
    _questionReceptionStreamController.close();
    _validateAnswerEventStreamController.close();
    _newQuestionRequestEventStreamController.close();
  }
}
