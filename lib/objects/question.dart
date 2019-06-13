class Question {
  int id;
  String question;
  String answer;
  int score;
  List<String> options;

  Question(this.question, this.options, this.answer, this.score);

  Question.fromJson(Map<String, dynamic> json) {
    this.id = json.values.first;
    this.question = json['question'];
    this.answer = json['answer'];
    this.score = json['score'];
    this.options =
        (json['options'] as List).map((option) => option.toString()).toList();
  }
}
