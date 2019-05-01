import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  /// return document reference to quiz document
  static DocumentReference iskaQuiz() {
    return Firestore.instance.collection('quizzes').document('FlutterIskaQuiz');
  }
}