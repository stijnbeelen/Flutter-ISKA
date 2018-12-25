import 'package:cloud_firestore/cloud_firestore.dart';

class QuizState {
  static String name;
  static DocumentReference userReference;
  static List<String> answers;
  static List<String> questions = [
    "What is Flutter's base class?",
    "What does Flutter compile to?",
  ];
  static int currentQuestion = 1;

  static getUserName() {
    return name;
  }

  static getAnswer(int questionId) {
    return answers[questionId];
  }
}