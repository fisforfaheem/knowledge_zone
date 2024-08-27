import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepPurple.shade800, Colors.blue.shade600],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _animation,
                child: const Icon(Icons.quiz, size: 100, color: Colors.white),
              ),
              const SizedBox(height: 20),
              FadeTransition(
                opacity: _animation,
                child: const Text(
                  'World Knowledge Quiz',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Column(
          children: [
            const Text(
              'World Knowledge',
              style: TextStyle(fontSize: 24, color: Colors.white),
            )
                .animate()
                .fadeIn(duration: const Duration(milliseconds: 800))
                .scale(),
            const SizedBox(height: 4),
            const Text(
              'Expand your horizons',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.deepPurple.shade800, Colors.blue.shade600],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepPurple.shade800, Colors.blue.shade600],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    'World Knowledge',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: const Duration(milliseconds: 800))
                      .scale(),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QuizScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      shadowColor: Colors.deepPurple,
                      elevation: 10,
                    ),
                    icon:
                        const Icon(Icons.play_arrow, color: Colors.deepPurple),
                    label: const Text(
                      'Start Quiz',
                      style: TextStyle(fontSize: 20, color: Colors.deepPurple),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          // Handle navigation based on the selected index
          switch (index) {
            case 0:
              // Navigate to Home
              break;
            case 1:
              // Navigate to Leaderboard
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LeaderboardScreen()),
              );
              break;
            case 2:
              // Navigate to Profile
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
              break;
          }
        },
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  int _score = 0;
  late List<Map<String, dynamic>> _questions;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _questions = List.from(_allQuestions)..shuffle();
    _questions = _questions.take(10).toList();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _answerQuestion(int selectedIndex) {
    setState(() {
      if (selectedIndex == _questions[_currentQuestionIndex]['correctAnswer']) {
        _score++;
      }
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _animationController.reset();
        _animationController.forward();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ResultScreen(score: _score, totalQuestions: _questions.length),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title:
            Text('Question ${_currentQuestionIndex + 1}/${_questions.length}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue.shade700, Colors.green.shade600],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LinearProgressIndicator(
                  value: (_currentQuestionIndex + 1) / _questions.length,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                const SizedBox(height: 30),
                FadeTransition(
                  opacity: _animation,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.white.withOpacity(0.9),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        _questions[_currentQuestionIndex]['question'],
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        _questions[_currentQuestionIndex]['answers'].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: FadeTransition(
                          opacity: _animation,
                          child: ElevatedButton(
                            onPressed: () => _answerQuestion(index),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 5,
                            ),
                            child: Text(
                              _questions[_currentQuestionIndex]['answers']
                                  [index],
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;

  const ResultScreen(
      {super.key, required this.score, required this.totalQuestions});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.purple.shade700, Colors.orange.shade600],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Quiz Completed!',
                      style: TextStyle(
                          fontSize: 36,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Your Score: ${widget.score} / ${widget.totalQuestions}',
                      style: const TextStyle(fontSize: 28, color: Colors.white),
                    )
                        .animate()
                        .slideY(begin: 1, end: 0, duration: 600.milliseconds)
                        .fadeIn(),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text('Play Again',
                          style: TextStyle(fontSize: 20, color: Colors.black)),
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.info, color: Colors.blue),
            title: const Text(
              'About',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Learn more about this app'),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutPage()),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: Colors.green),
            title: const Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Read our privacy policy'),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WebViewPage(
                  title: 'Privacy Policy',
                  url: 'https://example.com/privacy-policy',
                ),
              ),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'World Knowledge Quiz',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.quiz, size: 40, color: Colors.deepPurple),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Test and improve your general knowledge about the world with our engaging quiz app!',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Text(
                'Features',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.blue),
                title: Text('10 random questions per quiz'),
              ),
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.blue),
                title: Text('Wide range of topics'),
              ),
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.blue),
                title: Text('Beautiful UI with animations'),
              ),
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.blue),
                title: Text('Score tracking'),
              ),
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.blue),
                title: Text('Confetti celebration on completion'),
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Text(
                'Question Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.category, color: Colors.orange),
                title: Text('Geography'),
              ),
              ListTile(
                leading: Icon(Icons.category, color: Colors.orange),
                title: Text('Science'),
              ),
              ListTile(
                leading: Icon(Icons.category, color: Colors.orange),
                title: Text('Art and Literature'),
              ),
              ListTile(
                leading: Icon(Icons.category, color: Colors.orange),
                title: Text('History'),
              ),
              ListTile(
                leading: Icon(Icons.category, color: Colors.orange),
                title: Text('And more!'),
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Text(
                'Version: 1.0.0',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String title;
  final String url;

  const WebViewPage({super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: Navigator.of(context).pop,
            child: const Icon(Icons.arrow_back),
          ),
          title: Text(title),
        ),
        body: WebViewWidget(
          controller: WebViewController()
            ..loadRequest(Uri.parse(url))
            ..setJavaScriptMode(JavaScriptMode.unrestricted),
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> _allQuestions = [
  {
    'question': 'What is the capital of France?',
    'answers': ['London', 'Berlin', 'Paris', 'Madrid'],
    'correctAnswer': 2,
  },
  {
    'question': 'Which planet is known as the Red Planet?',
    'answers': ['Venus', 'Mars', 'Jupiter', 'Saturn'],
    'correctAnswer': 1,
  },
  {
    'question': 'Who painted the Mona Lisa?',
    'answers': ['Van Gogh', 'Picasso', 'Da Vinci', 'Michelangelo'],
    'correctAnswer': 2,
  },
  // New questions
  {
    'question': 'What is the largest ocean on Earth?',
    'answers': ['Atlantic', 'Indian', 'Arctic', 'Pacific'],
    'correctAnswer': 3,
  },
  {
    'question': 'Which country is home to the kangaroo?',
    'answers': ['New Zealand', 'South Africa', 'Australia', 'Brazil'],
    'correctAnswer': 2,
  },
  {
    'question': 'What is the chemical symbol for gold?',
    'answers': ['Go', 'Gd', 'Au', 'Ag'],
    'correctAnswer': 2,
  },
  {
    'question': 'Who wrote "Romeo and Juliet"?',
    'answers': [
      'Charles Dickens',
      'William Shakespeare',
      'Jane Austen',
      'Mark Twain'
    ],
    'correctAnswer': 1,
  },
  {
    'question': 'What is the largest planet in our solar system?',
    'answers': ['Earth', 'Mars', 'Jupiter', 'Saturn'],
    'correctAnswer': 2,
  },
  {
    'question': 'Which country is known as the Land of the Rising Sun?',
    'answers': ['China', 'Thailand', 'South Korea', 'Japan'],
    'correctAnswer': 3,
  },
  {
    'question': 'What is the hardest natural substance on Earth?',
    'answers': ['Gold', 'Iron', 'Diamond', 'Platinum'],
    'correctAnswer': 2,
  },
  {
    'question': 'Who invented the telephone?',
    'answers': [
      'Thomas Edison',
      'Alexander Graham Bell',
      'Nikola Tesla',
      'Guglielmo Marconi'
    ],
    'correctAnswer': 1,
  },
  {
    'question': 'What is the largest mammal in the world?',
    'answers': ['African Elephant', 'Blue Whale', 'Giraffe', 'Hippopotamus'],
    'correctAnswer': 1,
  },
  {
    'question':
        'Which planet is known as the "Morning Star" or "Evening Star"?',
    'answers': ['Mars', 'Jupiter', 'Venus', 'Mercury'],
    'correctAnswer': 2,
  },
  {
    'question': 'What is the capital of Japan?',
    'answers': ['Seoul', 'Beijing', 'Tokyo', 'Bangkok'],
    'correctAnswer': 2,
  },
  {
    'question': 'Who wrote "To Kill a Mockingbird"?',
    'answers': [
      'Harper Lee',
      'J.K. Rowling',
      'Stephen King',
      'Ernest Hemingway'
    ],
    'correctAnswer': 0,
  },
  {
    'question': 'What is the largest desert in the world?',
    'answers': ['Gobi', 'Sahara', 'Arabian', 'Antarctic'],
    'correctAnswer': 3,
  },
  {
    'question': 'Which element has the chemical symbol "O"?',
    'answers': ['Gold', 'Silver', 'Oxygen', 'Osmium'],
    'correctAnswer': 2,
  },
  {
    'question': 'Who painted "The Starry Night"?',
    'answers': [
      'Pablo Picasso',
      'Claude Monet',
      'Vincent van Gogh',
      'Leonardo da Vinci'
    ],
    'correctAnswer': 2,
  },
  {
    'question': 'What is the capital of Brazil?',
    'answers': ['Rio de Janeiro', 'São Paulo', 'Brasília', 'Salvador'],
    'correctAnswer': 2,
  },
  {
    'question': 'Which country is home to the Great Barrier Reef?',
    'answers': ['Indonesia', 'Philippines', 'Australia', 'Thailand'],
    'correctAnswer': 2,
  },
  {
    'question': 'What is the capital of France?',
    'answers': ['London', 'Berlin', 'Paris', 'Madrid'],
    'correctAnswer': 2,
  },
  {
    'question': 'Which planet is known as the Red Planet?',
    'answers': ['Venus', 'Mars', 'Jupiter', 'Saturn'],
    'correctAnswer': 1,
  },
  {
    'question': 'Who painted the Mona Lisa?',
    'answers': ['Van Gogh', 'Picasso', 'Da Vinci', 'Michelangelo'],
    'correctAnswer': 2,
  },
];

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        // Current screen, do nothing
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.deepPurple.shade800, Colors.blue.shade600],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepPurple.shade800, Colors.blue.shade600],
          ),
        ),
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: 10, // Example item count
            itemBuilder: (context, index) {
              return Card(
                color: Colors.black.withOpacity(0.8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    'User ${index + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Score: ${100 - index * 10}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.deepPurple.shade800, Colors.blue.shade600],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepPurple.shade800, Colors.blue.shade600],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'User Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                Card(
                  color: Colors.black.withOpacity(0.7),
                  child: const ListTile(
                    leading: Icon(Icons.quiz, color: Colors.deepPurple),
                    title: Text(
                      'Total Quizzes Taken',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Text(
                      '15',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  color: Colors.black.withOpacity(0.7),
                  child: const ListTile(
                    leading: Icon(Icons.score, color: Colors.deepPurple),
                    title: Text(
                      'Highest Score',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Text(
                      '90',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(color: Colors.white54),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
