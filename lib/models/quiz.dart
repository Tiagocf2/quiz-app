import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:quiz_app/models/question.dart';

class Quiz {
  List<Question>? questions;
  int _length = 12;
  int current = 0;
  bool loading = true;
  bool finished = false;

  Function? onFinish;

  Quiz({int? length, this.onFinish}) {
    if (length != null) this._length = length;
  }

  Future<void> populate() async {
    finished = false;
    final data = await rootBundle.loadString('assets/data.json');
    final lines = List.castFrom<dynamic, String>(json.decode(data));
    final rand = Random();
    List<int> chosenLines = [];
    this.questions = <Question>[];
    final len = min(_length, lines.length);
    for (int i = 0; i < len; i++) {
      final line = rand.nextInt(lines.length);
      if (chosenLines.contains(line)) {
        i--;
        continue;
      }
      chosenLines.add(line);
      final metadata = lines[line].split(' \$');
      this.questions!.add(Question(metadata[0], metadata[1] == '1'));
    }
    loading = false;
  }

  bool awnser(bool awnser) {
    question.awnser = awnser;
    final valid = question.valid;
    next();
    return valid;
  }

  void next() {
    if (loading || questions == null || finished) return;
    if (current + 1 >= length) {
      finish();
      return;
    }
    current = (current + 1) % length;
  }

  int finish() {
    finished = true;
    dynamic score = 0;
    for (Question q in questions!) {
      if (q.valid)
        score++;
      else
        score -= 0.5;
    }
    score = score.round();
    if (onFinish != null) {
      onFinish!(score as int);
    }
    return score;
  }

  int get length {
    if (questions == null) return 0;
    return questions!.length;
  }

  Question get question {
    if (loading || questions == null) throw Exception('Not yet loaded');
    return questions![current];
  }
}
