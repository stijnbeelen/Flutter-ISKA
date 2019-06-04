
import 'package:cloud_firestore/cloud_firestore.dart';

/// player class to store all info on players.
class Player {
  // _ makes field private in library
  String _name;
  int _score;
  DocumentReference firestoreReference;

  /// getter for _score
  int get score {
    return _score;
  }

  /// getter for _name field
  String get name {
    return _name;
  }

  /// default constructor
  Player(this._name, this.firestoreReference) {
    this._score = 0;
  }

  /// constructor overloading
  Player.allArgs(String name, DocumentReference firestoreReference, int score) {
    this._name = name;
    this.firestoreReference = firestoreReference;
    this._score = score;
  }

  /// method to increment score
  void incrementScore(int increment) {
    _score += increment;
  }

  Player.fromJson(Map<String, dynamic> json)
      : _name = json['name'],
        _score = json['score'];

  Map<String, dynamic> toJson() => {"name": _name, "score": _score};

}