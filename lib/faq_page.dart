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
        children: const <Widget>[
          ExpansionTile(
            leading: Icon(Icons.help_outline, color: Colors.blue),
            title: Text(
              'FAQ 1: How to start a quiz?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            children: <Widget>[
              ListTile(
                title: Text(
                  'Answer: To start a quiz, go to the main screen and select a quiz category. Then, click on the "Start Quiz" button to begin.',
                ),
              ),
            ],
          ),
          Divider(),
          ExpansionTile(
            leading: Icon(Icons.add_circle_outline, color: Colors.green),
            title: Text(
              'FAQ 2: How to create a new quiz?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            children: <Widget>[
              ListTile(
                title: Text(
                  'Answer: To create a new quiz, navigate to the "Create Quiz" section from the menu. Fill in the quiz details, add questions, and save the quiz.',
                ),
              ),
            ],
          ),
          Divider(),
          ExpansionTile(
            leading: Icon(Icons.bar_chart, color: Colors.orange),
            title: Text(
              'FAQ 3: How to view quiz results?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            children: <Widget>[
              ListTile(
                title: Text(
                  'Answer: After completing a quiz, you can view your results immediately. You can also access past quiz results from the "Results" section in the menu.',
                ),
              ),
            ],
          ),
          Divider(),
          //
        ],
      ),
    );
  }
}
