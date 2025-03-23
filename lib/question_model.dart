class Question {
  final String question;
  final List<String> incorrectAnswers;
  final String correctAnswer;
  final List<String> options;

  Question({
    required this.question,
    required this.incorrectAnswers,
    required this.correctAnswer,
  }) : options = (List<String>.from(incorrectAnswers)..add(correctAnswer))..shuffle();

  // Factory method to create a Question object from JSON
  factory Question.fromJson(Map<String, dynamic> json) {
    List<String> incorrect = List<String>.from(json['incorrect_answers'] ?? []);
    String correct = json['correct_answer'] ?? '';
    
    return Question(
      question: json['question'] ?? 'Unknown question',
      incorrectAnswers: incorrect,
      correctAnswer: correct,
    );
  }

  // Convert the Question object to a Map (useful for debugging or saving locally)
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'incorrect_answers': incorrectAnswers,
      'correct_answer': correctAnswer,
    };
  }
}
