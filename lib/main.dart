import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:general_knowledge_app/faq_page.dart';
import 'package:general_knowledge_app/questions.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsManager.init();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MainApp());
}

class SharedPrefsManager {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveQuizResult(
      String quizType, int score, int totalQuestions) async {
    final quizzesTaken = _prefs.getInt('quizzesTaken') ?? 0;
    final highestScore = _prefs.getInt('highestScore') ?? 0;
    final totalScore = _prefs.getInt('totalScore') ?? 0;

    await _prefs.setInt('quizzesTaken', quizzesTaken + 1);
    await _prefs.setInt(
        'highestScore', score > highestScore ? score : highestScore);
    await _prefs.setInt('totalScore', totalScore + score);

    final recentQuizzes = _prefs.getStringList('recentQuizzes') ?? [];
    recentQuizzes.insert(0,
        '$quizType,$score/$totalQuestions,${DateTime.now().toIso8601String()}');
    if (recentQuizzes.length > 5) recentQuizzes.removeLast();
    await _prefs.setStringList('recentQuizzes', recentQuizzes);
  }

  static Map<String, dynamic> getUserStats() {
    return {
      'quizzesTaken': _prefs.getInt('quizzesTaken') ?? 0,
      'highestScore': _prefs.getInt('highestScore') ?? 0,
      'averageScore': (_prefs.getInt('totalScore') ?? 0) /
          (_prefs.getInt('quizzesTaken') ?? 1),
      'recentQuizzes': _prefs.getStringList('recentQuizzes') ?? [],
    };
  }

  static List<Map<String, dynamic>> getLeaderboardData() {
    final leaderboardJson = _prefs.getString('leaderboard') ?? '[]';
    final leaderboardList = json.decode(leaderboardJson) as List;
    return leaderboardList.cast<Map<String, dynamic>>()
      ..sort((a, b) => b['totalScore'].compareTo(a['totalScore']));
  }

  static void updateLeaderboard(
      String username, int totalScore, int quizzesTaken) {
    final leaderboardData = getLeaderboardData();
    final userIndex =
        leaderboardData.indexWhere((user) => user['username'] == username);

    if (userIndex != -1) {
      leaderboardData[userIndex] = {
        'username': username,
        'totalScore': totalScore,
        'quizzesTaken': quizzesTaken,
        'averageScore': totalScore / quizzesTaken,
      };
    } else {
      leaderboardData.add({
        'username': username,
        'totalScore': totalScore,
        'quizzesTaken': quizzesTaken,
        'averageScore': totalScore / quizzesTaken,
      });
    }

    _prefs.setString('leaderboard', json.encode(leaderboardData));
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepOrange,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
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
            colors: [Colors.deepOrange.shade800, Colors.blue.shade600],
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

void _startQuiz(BuildContext context, String quizType) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => QuizScreen(quizType: quizType)),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepOrange.shade800, Colors.blue.shade600],
          ),
        ),
        child: SafeArea(
          child: Column(
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
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(16),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildBentoButton(
                        context, 'General Knowledge', Icons.lightbulb),
                    _buildBentoButton(context, 'Science', Icons.science),
                    _buildBentoButton(context, 'History', Icons.history),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),

      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Colors.black,
      //   selectedItemColor: Colors.deepOrange,
      //   unselectedItemColor: Colors.white70,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.settings),
      //       label: 'More',
      //     ),
      //   ],
      //   onTap: (index) {
      //     switch (index) {
      //       case 0:
      //         // Navigate to Home
      //         break;
      //       case 1:
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => const ProfileScreen()),
      //         );
      //         break;
      //       case 2:
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => const MorePage()),
      //         );
      //         break;
      //     }
      //   },
      // ),
    );
  }

  Widget _buildBentoButton(BuildContext context, String title, IconData icon) {
    final Map<String, Color> colorMap = {
      'General Knowledge': Colors.amber,
      'Science': Colors.green,
      'History': Colors.purple,
      'Leaderboard': Colors.blue,
    };

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (title == 'General Knowledge' ||
              title == 'Science' ||
              title == 'History') {
            _startQuiz(context, title);
          } else if (title == 'Leaderboard') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LeaderboardScreen()));
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: colorMap[title]?.withOpacity(0.8) ??
              Colors.white.withOpacity(0.2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.all(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 600)).scale();
  }

  void _startQuiz(BuildContext context, String quizType) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuizScreen(quizType: quizType)),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final String quizType;

  const QuizScreen({super.key, required this.quizType});

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
    _questions = List.from(quizzes[widget.quizType]!)..shuffle();
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
        SharedPrefsManager.saveQuizResult(
            widget.quizType, _score, _questions.length);
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

class PrivacyPolicyPage extends StatelessWidget {
  PrivacyPolicyPage({super.key});
  String url = 'https://www.google.com';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: WebViewWidget(
          controller: WebViewController()
            ..loadRequest(Uri.parse(url))
            ..setJavaScriptMode(JavaScriptMode.unrestricted)),
    );
  }
}

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(padding: const EdgeInsets.all(16.0), children: [
        ListTile(
          leading: const Icon(Icons.info, color: Colors.blue),
          title: const Text(
            'About ',
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
            MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
          ),
        ),
        const Divider(),
        //Share
        ListTile(
          leading: const Icon(Icons.share, color: Colors.orange),
          title: const Text(
            'Share',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: const Text('Share this app'),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          onTap: () {
            //use this and also add playstore link
            Share.share(
                'Download Expense Distribution app from Playstore: https://play.google.com/store/apps/details?id=com.example.general_knowledge_app');
          },
        ),
        const Divider(),
        //Rate US
        ListTile(
          leading: const Icon(Icons.feedback, color: Colors.red),
          title: const Text(
            'Feedback',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: const Text('Rate and review this app'),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          onTap: () => launchUrlString(
              'https://play.google.com/store/apps/details?id=com.example.general_knowledge_app'),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.question_answer, color: Colors.green),
          subtitle: const Text('Frequently asked questions'),
          title: const Text(
            'FAQs',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FaqPage()),
            );
          },
        )
      ]),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
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
                  Icon(Icons.quiz, size: 40, color: Colors.deepOrange),
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

class UserData {
  static Future<void> saveQuizResult(
      String quizType, int score, int totalQuestions) async {
    final prefs = await SharedPreferences.getInstance();
    final quizzesTaken = prefs.getInt('quizzesTaken') ?? 0;
    final highestScore = prefs.getInt('highestScore') ?? 0;
    final totalScore = prefs.getInt('totalScore') ?? 0;

    await prefs.setInt('quizzesTaken', quizzesTaken + 1);
    await prefs.setInt(
        'highestScore', score > highestScore ? score : highestScore);
    await prefs.setInt('totalScore', totalScore + score);

    // Save recent quiz
    final recentQuizzes = prefs.getStringList('recentQuizzes') ?? [];
    recentQuizzes.insert(0,
        '$quizType,$score/$totalQuestions,${DateTime.now().toIso8601String()}');
    if (recentQuizzes.length > 5) recentQuizzes.removeLast();
    await prefs.setStringList('recentQuizzes', recentQuizzes);
  }

  static Future<Map<String, dynamic>> getUserStats() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'quizzesTaken': prefs.getInt('quizzesTaken') ?? 0,
      'highestScore': prefs.getInt('highestScore') ?? 0,
      'averageScore': (prefs.getInt('totalScore') ?? 0) /
          (prefs.getInt('quizzesTaken') ?? 1),
      'recentQuizzes': prefs.getStringList('recentQuizzes') ?? [],
    };
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget buildStatCard(String title, String value) {
    return Card(
      color: Colors.black.withOpacity(0.7),
      child: ListTile(
        leading: const Icon(Icons.star, color: Colors.deepOrange),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: Text(
          value,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildQuizHistoryItem(String quizType, String score, String date) {
    return Card(
      color: Colors.black.withOpacity(0.7),
      child: ListTile(
        leading: const Icon(Icons.quiz, color: Colors.deepOrange),
        title: Text(
          quizType,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          'Date: $date',
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Text(
          score,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = SharedPrefsManager.getUserStats();

    return Scaffold(
      appBar: AppBar(title: const Text('Me')),
      body: Column(
        children: [
          buildStatCard('Total Quizzes Taken', '${stats['quizzesTaken']}'),
          buildStatCard('Highest Score', '${stats['highestScore']}'),
          buildStatCard(
              'Average Score', '${stats['averageScore'].toStringAsFixed(2)}'),
          Expanded(
            child: ListView.builder(
              itemCount: stats['recentQuizzes'].length,
              itemBuilder: (context, index) {
                final quizData = stats['recentQuizzes'][index].split(',');
                return buildQuizHistoryItem(
                    quizData[0], quizData[1], quizData[2]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
    );
  }
}

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final leaderboardData = SharedPrefsManager.getLeaderboardData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.deepOrange.shade800, Colors.blue.shade600],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepOrange.shade800, Colors.blue.shade600],
          ),
        ),
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: leaderboardData.length,
            itemBuilder: (context, index) {
              final userData = leaderboardData[index];
              return Card(
                color: Colors.black.withOpacity(0.8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepOrange,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    userData['username'],
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Total Score: ${userData['totalScore']}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Quizzes: ${userData['quizzesTaken']}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      Text(
                        'Avg: ${userData['averageScore'].toStringAsFixed(2)}%',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.deepOrange,
      unselectedItemColor: Colors.white70,
      currentIndex: currentIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'More',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
            break;

          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MorePage()),
            );
            break;
        }
      },
    );
  }
}
