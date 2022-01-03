class QuizModel {
  static const String tableName = 'quizzes';
  static const String colId = 'id';
  static const String colBookId = 'bookId';
  static const String colStartedAt = 'startedAt';
  static const String colEndedAt = 'endedAt';
  static const String colQuizNum = 'numberOfQuestions';
  static const String colCorrectNum = 'numberOfCorrectAnswers';

  final String id;
  final String bookId;
  DateTime startedAt;
  DateTime? endedAt;
  late int quizNum;
  late int correctNum;

  QuizModel(this.id, this.bookId, this.startedAt,
      [this.endedAt, this.quizNum = 0, this.correctNum = 0]);

  factory QuizModel.fromJson(dynamic json) {
    return QuizModel(
      json[colId] as String,
      json[colBookId] as String,
      DateTime.parse(json[colStartedAt]).toLocal(),
      json[colEndedAt] != null
          ? DateTime.parse(json[colEndedAt]).toLocal()
          : null,
      json[colQuizNum] as int,
      json[colCorrectNum] as int,
    );
  }

  @override
  String toString() {
    return '{$id, $bookId, $colStartedAt, $colEndedAt, $colQuizNum, $colCorrectNum}';
  }

  Map<String, dynamic> toJson() => {
        colId: id,
        colBookId: bookId,
        colStartedAt: startedAt.toUtc().toIso8601String(),
        colEndedAt: endedAt?.toUtc().toIso8601String(),
        colQuizNum: quizNum,
        colCorrectNum: correctNum,
      };
}
