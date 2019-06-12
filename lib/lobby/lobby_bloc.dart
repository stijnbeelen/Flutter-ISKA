import 'dart:async';

import '../firestore_helper.dart';

class LobbyBLoC {
  final _gameStateStreamController = StreamController<bool>();
  StreamSink<bool> get _gameStateEventSink => _gameStateStreamController.sink;
  Stream<bool> get streamGameState => _gameStateStreamController.stream.distinct();

  LobbyBLoC() {
    FirestoreHelper.flutterIskaQuiz.snapshots().listen((documentSnapshot) =>
        _gameStateEventSink.add(documentSnapshot.data['started']));
  }

  dispose() {
    _gameStateStreamController.close();
  }
}
