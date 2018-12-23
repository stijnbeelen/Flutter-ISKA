class QuizState {
  static String name;
  static List<String> answers;

  static getUserName() {
    return name;
  }

  static getAnswer(int questionId) {
    return answers[questionId];
  }
}