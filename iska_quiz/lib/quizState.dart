class QuizState {
  static String name;
  static List<String> answers;
  static List<String> questions;
  static int currentQuestion;

  static getUserName() {
    return name;
  }

  static getAnswer(int questionId) {
    return answers[questionId];
  }
}