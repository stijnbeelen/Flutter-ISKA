import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  /// return document reference to quiz document
  static Future<DocumentReference> iskaQuiz() async {
    return Firestore.instance.collection('quizzes').document('FlutterIskaQuiz');
  }

  static CollectionReference get players => Firestore.instance.collection('quizzes').document('FlutterIskaQuiz').collection('players');

  static CollectionReference get questions => Firestore.instance.collection('quizzes').document('FlutterIskaQuiz').collection('questions');

}