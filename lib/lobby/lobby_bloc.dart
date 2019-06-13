import 'dart:async';

import '../firestore_helper.dart';

class LobbyBLoC {
  final _gameStateStreamController = StreamController<int>();
  StreamSink<int> get _gameStateEventSink => _gameStateStreamController.sink;
  Stream<int> get streamGameState => _gameStateStreamController.stream.distinct();

  LobbyBLoC() {
    FirestoreHelper.flutterIskaQuiz.snapshots().listen((documentSnapshot) =>
        _gameStateEventSink.add(documentSnapshot.data['currentQuestion']));
  }

  dispose() {
    _gameStateStreamController.close();
  }
}
