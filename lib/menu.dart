import 'package:flutter/material.dart';
import 'package:quiz_app/quizPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool loading = true;
  int highscore = 0;

  @override
  initState() {
    super.initState();
    fetchData().then(
      (value) => {setState(() => loading = false)},
    );
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    dynamic highscore = prefs.getInt('highscore');
    if (highscore == null) return;
    setState(() => this.highscore = highscore);
  }

  void handleStart() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizPage(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(48),
        margin: const EdgeInsets.only(bottom: 62),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Quiz!",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: handleStart,
              child: const Text('Start'),
            ),
            const SizedBox(height: 32),
            Text(
              'Highscore: $highscore',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
