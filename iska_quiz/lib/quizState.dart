import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iska_quiz/objects/player.dart';
import 'package:iska_quiz/objects/question.dart';

class QuizState {
  static Player currentPlayer;
  static List<String> _answers;

  static List<String> questions = [];
  static Question currentQuestion = Question.empty();

  static String get name => currentPlayer.name;

  static DocumentReference get userReference => currentPlayer.firestoreReference;

  static int get nextQuestion => currentQuestion.id + 1;

  static void incrementScore(int increment) {
    currentPlayer.incrementScore(increment);
  }

  static dynamic getAnswer(int questionId) {
    return _answers[questionId];
  }

  //downside: you can insert all types
  /*static void incrementScore([int increment = 1]) {
    currentPlayer.incrementScore(increment);
  }*/
  /*static void incrementScore({increment:1}) {
    _currentPlayer.incrementScore(increment);
  }*/
}