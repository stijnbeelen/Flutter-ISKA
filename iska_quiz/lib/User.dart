import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  Map<int, String> answers;
  DocumentReference reference;

  User(this.name, this.answers);

  void addAnswer(int questionId, String answer) {
    answers.putIfAbsent(questionId, () => answer);
  }

}