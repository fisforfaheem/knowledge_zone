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
            'To start a quiz, go to the main screen and select a quiz category. Then, click on the "Start Quiz" button to begin. Make sure you have selected the correct category that interests you. Once you start the quiz, you will be presented with a series of questions. Answer each question to the best of your ability and submit your answers at the end to see your score.',
            Icons.help_outline,
            Colors.blue,
          ),
          const Divider(),
          _buildFaqTile(
            context,
            'FAQ 2: How to create a new quiz?',
            'To create a new quiz, navigate to the "Create Quiz" section from the menu. Fill in the quiz details, add questions, and save the quiz. You can add multiple choice questions, true/false questions, or even short answer questions. Once you have added all the questions, review them to ensure accuracy and completeness. Finally, save the quiz and it will be available for others to take.',
            Icons.add_circle_outline,
            Colors.green,
          ),
          const Divider(),
          _buildFaqTile(
            context,
            'FAQ 3: How to view quiz results?',
            'After completing a quiz, you can view your results immediately. You can also access past quiz results from the "Results" section in the menu. The results page will show your score, the correct answers, and explanations for each question. This can help you understand where you went wrong and improve your knowledge for future quizzes. You can also compare your results with others who have taken the same quiz.',
            Icons.bar_chart,
            Colors.orange,
          ),
          // const Divider(),
          // _buildFaqTile(
          //   context,
          //   'FAQ 5: How to share quiz results?',
          //   'To share your quiz results, go to the results page and click on the "Share" button. You can share your results via social media, email, or messaging apps. Sharing your results can be a great way to challenge your friends and family to take the quiz and see how they score. It can also be a fun way to show off your knowledge and achievements. Make sure to add a personal message when sharing to make it more engaging.',
          //   Icons.share,
          //   Colors.purple,
          // ),
          const Divider(),
          _buildFaqTile(
            context,
            'FAQ 6: How to customize quiz settings?',
            'To customize quiz settings, go to the settings page from the menu. Here, you can adjust the difficulty level, time limits, and other preferences. You can choose to make the quiz easier or harder depending on your skill level. You can also set a time limit for each question to make the quiz more challenging. Additionally, you can enable or disable hints and explanations for each question. Customizing the settings can help you tailor the quiz experience to your liking.',
            Icons.settings,
            Colors.teal,
          ),
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
