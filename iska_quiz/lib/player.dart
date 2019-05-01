import 'package:iska_quiz/firestoreHelper.dart';

/// player class to store all info on players.
class Player {
  // _ makes field private in library
  int _id;
  String _name;
  int _score;

  /// getter for _id
  int get id {
    return _id;
  }

  /// getter for _score
  int get score {
    return _score;
  }

  /// getter for _name field
  String get name {
    return _name;
  }

  /// setter for _name field
  set name(String name) {
    this._name = name;
  }

  /// default constructor
  Player(String name) {
    this._id = 4;
    this._name = name;
    this._score = 0;
  }

  /// constructor overloading
  Player.allArgs(int id, String name, int score) {
    this._id = 0;
    this._name = name;
    this._score = score;
  }

  /// method to increment score
  void incrementScore(int increment) {
    _score += increment;
  }
}