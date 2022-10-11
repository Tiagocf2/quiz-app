import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiz_app/models/quiz.dart';
import 'package:quiz_app/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizPage extends StatefulWidget {
  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late Quiz quiz;
  final int timeout = 60000;
  bool loading = true;
  int time = 0; //1 minuto
  Timer? timer;

  _QuizPageState() {
    quiz = Quiz(onFinish: handleFinish);
  }

  @override
  initState() {
    super.initState();
    quiz.populate().then((_) {
      fireTimer();
      setState(() {
        loading = false;
      });
    });
  }

  fireTimer() {
    timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() => this.time += 100);
      if (this.time >= this.timeout) {
        quiz.finish();
        timer.cancel();
      }
    });
  }

  handleAwnser(awnser) {
    setState(() {
      quiz.awnser(awnser);
    });
  }

  handleFinish(int score) {
    final finalScore =
        (score / quiz.length * (1.5 + (timeout - time) / 1000)).round();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Result(score: finalScore)));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading)
      return Center(
        child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary),
      );

    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LinearProgressIndicator(
              value: time / timeout,
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    quiz.question.text,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary),
                  onPressed: () => handleAwnser(true),
                  child: Text('True'),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error),
                  onPressed: () => handleAwnser(false),
                  child: Text('False'),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: quiz.questions!
                    .map((question) => Icon(
                          question.awnser == null
                              ? null
                              : question.valid
                                  ? Icons.check
                                  : Icons.close,
                          color: question.valid
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.error,
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
