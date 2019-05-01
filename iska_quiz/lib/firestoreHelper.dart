import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  /// return document reference to quiz document
  static Future<DocumentReference> iskaQuiz() async {
    return Firestore.instance.collection('quizzes').document('FlutterIskaQuiz');
  }

  static dynamic players() async {
    var quiz = await iskaQuiz();
    var quizDoc = await quiz.get();
    return quizDoc['players'];
  }
}