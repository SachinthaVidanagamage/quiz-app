/*
import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50], // Light background color
      appBar: AppBar(
        title: const Text("Quiz App"),
        backgroundColor: Colors.deepPurple, // AppBar color
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Welcome to the Quiz App!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 30),
              _buildSubjectButton(context, "General Knowledge", Colors.blue, 'General Knowledge'),
              const SizedBox(height: 20),
              _buildSubjectButton(context, "Science", Colors.green, 'Science'),
              const SizedBox(height: 20),
              _buildSubjectButton(context, "History", Colors.orange, 'History'),
              const SizedBox(height: 20),
              // Add more subjects here with different colors
            ],
          ),
        ),
      ),
    );
  }

  // Custom button widget to reduce code duplication and add style
  Widget _buildSubjectButton(BuildContext context, String subjectName, Color buttonColor, String subject) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QuizScreen(subject: subject)),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor, // Button color
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      child: Text(subjectName),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light background
      appBar: AppBar(
        title: const Text(
          "Quiz App",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 5,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Welcome to the Quiz App! 🎯",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Test your knowledge in different subjects.\nChoose a topic to begin!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const SizedBox(height: 40),

              // Custom Gradient Buttons
              _buildSubjectButton(context, "General Knowledge", Colors.blue, Icons.public, 'General Knowledge'),
              const SizedBox(height: 20),
              _buildSubjectButton(context, "Science", Colors.green, Icons.science, 'Science'),
              const SizedBox(height: 20),
              _buildSubjectButton(context, "History", Colors.orange, Icons.history_edu, 'History'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Custom Gradient Button
  Widget _buildSubjectButton(BuildContext context, String subjectName, Color color, IconData icon, String subject) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => QuizScreen(subject: subject),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: color.withOpacity(0.8),
          shadowColor: Colors.black54,
          elevation: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              subjectName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
