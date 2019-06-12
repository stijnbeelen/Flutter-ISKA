import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  static DocumentReference get flutterIskaQuiz => Firestore.instance.collection('quizzes').document('FlutterIskaQuiz');

  static CollectionReference get players => flutterIskaQuiz.collection('players');

  static CollectionReference get questions => flutterIskaQuiz.collection('questions');

  static DocumentReference currentPlayer;
}
