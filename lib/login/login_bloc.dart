import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iska_quiz/firestore_helper.dart';
import 'package:iska_quiz/objects/player.dart';

class LoginEvent {
  String playerId;
  String iconName;

  LoginEvent(this.playerId, this.iconName);
}

class LoginBLoC {
  final _loginEventStreamController = StreamController<LoginEvent>.broadcast();
  StreamSink<LoginEvent> get loginEventSink => _loginEventStreamController.sink;
  Stream<LoginEvent> get streamLoginEvent => _loginEventStreamController.stream;

  final _loginErrorStreamController = StreamController<String>.broadcast();
  StreamSink<String> get loginErrorStreamSink => _loginErrorStreamController.sink;
  Stream<String> get streamLoginError => _loginErrorStreamController.stream;

  final _loginSuccessStreamController = StreamController<bool>.broadcast();
  StreamSink<bool> get _loginSuccessStreamSink => _loginSuccessStreamController.sink;
  Stream<bool> get streamLoginSuccess => _loginSuccessStreamController.stream;

  void loginRequestReceived(LoginEvent event) async {
    // clearError();
    var userRef = FirestoreHelper.players.document(event.playerId);
    FirestoreHelper.currentPlayer = userRef;
    await connectToLobby(event.playerId, event.iconName, userRef);
  }

  void clearError() {
    loginErrorStreamSink.add(null);
  }

  void showError(String errorString) {
    loginErrorStreamSink.add(errorString);
  }

  connectToLobby(String playerId, String iconName, DocumentReference playerReference) async {
    await Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot quizSnapshot = await transaction.get(FirestoreHelper.flutterIskaQuiz);
      if (quizSnapshot.data['currentQuestion'] != 0) {
        showError("The quiz has already started");
        return;
      }

      DocumentSnapshot playerSnapshot = await transaction.get(playerReference);
      if (playerSnapshot.exists) {
        showError("This name is already in use");
      } else {
        await transaction.update(FirestoreHelper.flutterIskaQuiz, {});
        await transaction.set(playerReference, Player(playerSnapshot.documentID, playerReference, iconName).toJson());
        _loginSuccessStreamSink.add(true);
      }
    });
  }

  LoginBLoC() {
    streamLoginEvent.listen(loginRequestReceived);
  }

  dispose() {
    _loginErrorStreamController.close();
    _loginEventStreamController.close();
    _loginSuccessStreamController.close();
  }
}
