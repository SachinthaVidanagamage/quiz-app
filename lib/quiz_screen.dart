/*

import 'package:flutter/material.dart';
import 'api_service.dart';
import 'result_screen.dart'; // Import ResultScreen
import 'question_model.dart'; // Ensure this matches the correct file

class QuizScreen extends StatefulWidget {
  final String subject;

  const QuizScreen({super.key, required this.subject});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<List<Question>> _questionsFuture;
  final List<String> _answers = [];  // Store selected answers
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _questionsFuture = loadQuestions(
      10,
      _getCategoryForSubject(widget.subject),
      'medium',
    );
  }

  int _getCategoryForSubject(String subject) {
    switch (subject) {
      case 'Science':
        return 17;
      case 'History':
        return 23;
      default:
        return 18; // General Knowledge
    }
  }

  Future<List<Question>> loadQuestions(int amount, int category, String difficulty) async {
    return await ApiService().fetchQuestions(amount, category, difficulty);
  }

  void _submitQuiz(List<Question> questions) {
    int score = 0;
    List<Map<String, dynamic>> resultDetails = [];

    for (int i = 0; i < _answers.length; i++) {
      String selectedAnswer = _answers[i];
      String correctAnswer = questions[i].correctAnswer;
      bool isCorrect = selectedAnswer == correctAnswer;
      if (isCorrect) score++;

      resultDetails.add({
        'question': questions[i].question,
        'selected_answer': selectedAnswer,
        'correct_answer': correctAnswer,
        'is_correct': isCorrect,
      });
    }

    setState(() {
      _score = score;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          score: _score,
          resultDetails: resultDetails,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.subject} Quiz")),
      body: FutureBuilder<List<Question>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No questions available.'));
          } else {
            List<Question> questions = snapshot.data!;
            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      Question question = questions[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: ListTile(
                          title: Text(question.question),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              for (var option in [...question.incorrectAnswers, question.correctAnswer]..shuffle())
                                RadioListTile<String>(
                                  title: Text(option),
                                  value: option,
                                  groupValue: _answers.length > index ? _answers[index] : null,
                                  onChanged: (value) {
                                    setState(() {
                                      if (_answers.length > index) {
                                        _answers[index] = value!;
                                      } else {
                                        _answers.add(value!);
                                      }
                                    });
                                  },
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _submitQuiz(questions),
                  child: const Text("Submit Quiz"),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
*/
import 'dart:async';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'result_screen.dart';
import 'question_model.dart';

class QuizScreen extends StatefulWidget {
  final String subject;

  const QuizScreen({super.key, required this.subject});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<List<Question>> _questionsFuture;
  late List<Question> _questions; // ✅ Store questions properly
  final List<String> _answers = [];
  int _currentIndex = 0;
  int _timeLeft = 30; // Timer per question
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _questionsFuture = loadQuestions(
      10,
      _getCategoryForSubject(widget.subject),
      'medium',
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int _getCategoryForSubject(String subject) {
    switch (subject) {
      case 'Science':
        return 17;
      case 'History':
        return 23;
      default:
        return 18;
    }
  }

  Future<List<Question>> loadQuestions(int amount, int category, String difficulty) async {
    return await ApiService().fetchQuestions(amount, category, difficulty);
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer?.cancel();
        _moveToNextQuestion();
      }
    });
  }

  void _moveToNextQuestion() {
    if (_currentIndex < _questions.length - 1) { // ✅ Use _questions.length
      setState(() {
        _answers.add("No Answer"); // Mark unanswered
        _currentIndex++;
      });
      _startTimer();
    } else {
      _submitQuiz();
    }
  }

  void _submitQuiz() {
    _timer?.cancel();
    int score = 0;
    List<Map<String, dynamic>> resultDetails = [];

    for (int i = 0; i < _answers.length; i++) {
      String selectedAnswer = _answers[i];
      String correctAnswer = _questions[i].correctAnswer;
      bool isCorrect = selectedAnswer == correctAnswer;
      if (isCorrect) score++;

      resultDetails.add({
        'question': _questions[i].question,
        'selected_answer': selectedAnswer,
        'correct_answer': correctAnswer,
        'is_correct': isCorrect,
      });
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(score: score, resultDetails: resultDetails),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: Text("${widget.subject} Quiz")),
      body: FutureBuilder<List<Question>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No questions available.'));
          } else {
            _questions = snapshot.data!; // ✅ Store questions in _questions
            return Column(
              children: <Widget>[
                _buildTimerIndicator(),
                Expanded(child: _buildQuestionCard(_questions[_currentIndex])),
                _buildSubmitButton(),
              ],
            );
          }
        },
      ),
    );
  }

  // 🕰 Timer UI (Progress Indicator)
  Widget _buildTimerIndicator() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              value: _timeLeft / 30,
              strokeWidth: 8,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(
                _timeLeft > 10 ? Colors.green : Colors.red,
              ),
            ),
          ),
          Text(
            "$_timeLeft s",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _timeLeft > 10 ? Colors.black : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  // 📌 Question UI
  Widget _buildQuestionCard(Question question) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Q${_currentIndex + 1}: ${question.question}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Column(
                children: [
                  for (var option in [...question.incorrectAnswers, question.correctAnswer]..shuffle())
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: RadioListTile<String>(
                        title: Text(option, style: const TextStyle(fontSize: 16)),
                        value: option,
                        groupValue: _answers.length > _currentIndex ? _answers[_currentIndex] : null,
                        onChanged: (value) {
                          setState(() {
                            if (_answers.length > _currentIndex) {
                              _answers[_currentIndex] = value!;
                            } else {
                              _answers.add(value!);
                            }
                          });
                          _timer?.cancel();
                          Future.delayed(const Duration(milliseconds: 500), _moveToNextQuestion);
                        },
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Submit Button (Final)
  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ElevatedButton(
        onPressed: _submitQuiz,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text(
          "Submit Quiz",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
