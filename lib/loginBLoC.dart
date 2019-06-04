import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iska_quiz/firestoreHelper.dart';
import 'package:iska_quiz/objects/player.dart';
import 'package:iska_quiz/quizState.dart';

class LoginEvent {
  String _playerId;

  String get playerId => _playerId;

  LoginEvent(this._playerId);
}

class LoginBLoC {
  final _loginEventStreamController = StreamController<LoginEvent>();
  StreamSink<LoginEvent> get loginEventSink => _loginEventStreamController.sink;
  Stream<LoginEvent> get _streamLoginEvent => _loginEventStreamController.stream;

  final _loginErrorStreamController = StreamController<String>();
  StreamSink<String> get _loginErrorStreamSink => _loginErrorStreamController.sink;
  Stream<String> get streamLoginError => _loginErrorStreamController.stream;

  final _loginSuccessStreamController = StreamController<bool>();
  StreamSink<bool> get _loginSuccessStreamSink => _loginSuccessStreamController.sink;
  Stream<bool> get streamLoginSuccess => _loginSuccessStreamController.stream;

  void loginRequestReceived(LoginEvent event) async {
    clearError();
    var userRef = FirestoreHelper.players.document(event.playerId);
    checkAndCreate(event.playerId, userRef);
  }

  void clearError() {
    _loginErrorStreamSink.add(null);
  }

  void showError(String errorString) {
    _loginErrorStreamSink.add(errorString);
  }

  checkAndCreate(String playerId, DocumentReference playerReference) async {
    await Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snap = await transaction.get(playerReference);
      if (snap.exists) {
        showError("${snap.documentID} already exists.");
        _loginSuccessStreamSink.add(false);
      } else {
        QuizState.currentPlayer = new Player(snap.documentID, playerReference);
        await transaction.set(playerReference, QuizState.currentPlayer.toJson());
        _loginSuccessStreamSink.add(true);
      }
    });
  }

  LoginBLoC() {
    _streamLoginEvent.listen(loginRequestReceived);
  }

  dispose() {
    _loginErrorStreamController.close();
    _loginEventStreamController.close();
    _loginSuccessStreamController.close();
  }
}
