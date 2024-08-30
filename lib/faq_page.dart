import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: <Widget>[
          _buildFaqTile(
            context,
            'FAQ 1: How to start a quiz?',
            'To start a quiz, go to the main screen and select a quiz category. Then, click on the "Start Quiz" button to begin.',
            Icons.help_outline,
            Colors.blue,
          ),
          const Divider(),
          _buildFaqTile(
            context,
            'FAQ 2: How to create a new quiz?',
            'To create a new quiz, navigate to the "Create Quiz" section from the menu. Fill in the quiz details, add questions, and save the quiz.',
            Icons.add_circle_outline,
            Colors.green,
          ),
          const Divider(),
          _buildFaqTile(
            context,
            'FAQ 3: How to view quiz results?',
            'After completing a quiz, you can view your results immediately. You can also access past quiz results from the "Results" section in the menu.',
            Icons.bar_chart,
            Colors.orange,
          ),
          const Divider(),

          // Add more FAQs here
        ],
      ),
    );
  }

  Widget _buildFaqTile(BuildContext context, String question, String answer,
      IconData icon, Color iconColor) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        question,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                FaqDetailPage(question: question, answer: answer),
          ),
        );
      },
    );
  }
}

class FaqDetailPage extends StatelessWidget {
  final String question;
  final String answer;

  const FaqDetailPage(
      {super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              question,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              answer,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
