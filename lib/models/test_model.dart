class TestModel {
  static const String tableName = 'tests';
  static const String colId = 'id';
  static const String colBookId = 'bookId';
  static const String colStartedAt = 'startedAt';
  static const String colEndedAt = 'endedAt';
  static const String colNumberOfQuestions = 'numberOfQuestions';
  static const String colNumberOfCorrectAnswers = 'numberOfCorrectAnswers';

  final String id;
  final String bookId;
  DateTime startedAt;
  DateTime endedAt;
  final int numberOfQuestions;
  final int numberOfCorrectAnswers;

  TestModel(this.id, this.bookId, this.startedAt, this.endedAt,
      this.numberOfQuestions, this.numberOfCorrectAnswers);

  factory TestModel.fromJson(dynamic json) {
    return TestModel(
      json[colId] as String,
      json[colBookId] as String,
      DateTime.parse(json[colStartedAt]).toLocal(),
      DateTime.parse(json[colEndedAt]).toLocal(),
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
        colEndedAt: endedAt.toUtc().toIso8601String(),
        colNumberOfQuestions: numberOfQuestions,
        colNumberOfCorrectAnswers: numberOfCorrectAnswers,
      };
}
