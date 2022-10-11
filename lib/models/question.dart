class Question {
  String text;
  bool solution;
  bool? awnser;
  Question(this.text, this.solution);

  get valid => awnser != null && (awnser! == solution);

  @override
  String toString() {
    return '{Q: $text. A: $solution}';
  }
}
