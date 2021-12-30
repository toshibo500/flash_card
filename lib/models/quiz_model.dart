class QuizModel {
  static const String tableName = 'quizzes';
  static const String colId = 'id';
  static const String colBookId = 'bookId';
  static const String colStartedAt = 'startedAt';
  static const String colEndedAt = 'endedAt';
  static const String colNumberOfQuestions = 'numberOfQuestions';
  static const String colNumberOfCorrectAnswers = 'numberOfCorrectAnswers';

  final String id;
  final String bookId;
  DateTime startedAt;
  DateTime? endedAt;
  late int numberOfQuestions;
  late int numberOfCorrectAnswers;

  QuizModel(this.id, this.bookId, this.startedAt,
      [this.endedAt,
      this.numberOfQuestions = 0,
      this.numberOfCorrectAnswers = 0]);

  factory QuizModel.fromJson(dynamic json) {
    return QuizModel(
      json[colId] as String,
      json[colBookId] as String,
      DateTime.parse(json[colStartedAt]).toLocal(),
      json[colEndedAt] != null
          ? DateTime.parse(json[colEndedAt]).toLocal()
          : null,
      json[colNumberOfQuestions] as int,
      json[colNumberOfCorrectAnswers] as int,
    );
  }

  @override
  String toString() {
    return '{$id, $bookId, $colStartedAt, $colEndedAt, $colNumberOfQuestions, $colNumberOfCorrectAnswers}';
  }

  Map<String, dynamic> toJson() => {
        colId: id,
        colBookId: bookId,
        colStartedAt: startedAt.toUtc().toIso8601String(),
        colEndedAt: endedAt?.toUtc().toIso8601String(),
        colNumberOfQuestions: numberOfQuestions,
        colNumberOfCorrectAnswers: numberOfCorrectAnswers,
      };
}
