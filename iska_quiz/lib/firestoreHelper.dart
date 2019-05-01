import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  static DocumentReference iskaQuiz() {
    return Firestore.instance.collection('quizzes').document('FlutterIskaQuiz');
  }
}