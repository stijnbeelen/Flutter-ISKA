import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iska_quiz/player.dart';

class QuizState {
  static Player currentPlayer;
  static String name;
  static DocumentReference userReference;
  static List<String> answers;
  static List<String> questions = [];
  static int currentQuestion = 1;

  static getUserName() {
    return name;
  }

  static getAnswer(int questionId) {
    return answers[questionId];
  }
}