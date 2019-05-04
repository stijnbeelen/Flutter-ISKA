class Question {
  int id;
  String question;
  String answer;
  int score;

  Question(this.question, this.answer, this.score);

  Question.empty() {
    this.id = 0;
    this.question = "";
    this.answer = "";
    this.score = 0;
  }

  Question.fromJson(Map<String, dynamic> json) {
    this.id = json.values.first;
    this.question = json['question'];
    this.answer = json['answer'];
    this.score = json['score'];
  }

  Map<String, dynamic> toJson() {
    return
      {
        'id': id,
        'question': question,
        'answer' : answer,
        'score' : score
      };
  }

}