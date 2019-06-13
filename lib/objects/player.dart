import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  String _name;
  int _score;
  String _iconName;

  DocumentReference firestoreReference;

  int get score => _score;

  String get name => _name;

  Player(this._name, this.firestoreReference, this._iconName) {
    this._score = 0;
  }

  void incrementScore(int increment) => _score += increment;

  Player.fromJson(Map<String, dynamic> json)
      : _name = json['name'],
        _score = json['score'],
        _iconName = json['icon'];

  Map<String, dynamic> toJson() =>
      {
        "name": _name,
        "score": _score,
        "created": FieldValue.serverTimestamp(),
        "icon": _iconName
      };
}
