import 'package:flutter/material.dart';
import 'package:quiz_app/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Result extends StatefulWidget {
  int score;
  Result({required this.score});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  int? highscore;
  late int score;
  bool isHighscore = false;

  @override
  void initState() {
    super.initState();
    score = widget.score;
    SharedPreferences.getInstance().then((prefs) {
      int? highscore = prefs.getInt('highscore');
      setState(() {
        if (highscore == null || highscore < score) {
          isHighscore = true;
          prefs.setInt('highscore', score);
        }
        this.highscore = highscore;
      });
    });
  }

  handleMenu() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Menu()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (highscore == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 48.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isHighscore ? 'NEW HIGHSCORE!' : 'Your score was',
                      style: isHighscore
                          ? TextStyle(
                              color: Theme.of(context).colorScheme.secondary)
                          : null,
                    ),
                    SizedBox(height: 32),
                    Text(
                      '$score',
                      style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: handleMenu,
                child: Text('Menu'),
              ),
              ...?(isHighscore
                  ? null
                  : [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          'Highscore: $highscore',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      )
                    ]),
            ],
          ),
        ),
      ),
    );
  }
}
