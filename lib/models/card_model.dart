class CardModel {
  static const String tableName = 'cards';
  static const String colId = 'id';
  static const String colBookId = 'bookId';
  static const String colFront = 'front';
  static const String colBack = 'back';
  static const String colSequence = 'sequence';
  static const String colNumberOfCorrectAnswers = 'numberOfCorrectAnswers';
  static const String colNumberOfWrongAnswers = 'numberOfWrongAnswers';
  static const String colTestedAt = 'testedAt';

  final String id;
  final String bookId;
  String front;
  String back;
  final int sequence;
  late int numberOfCorrectAnswers;
  late int numberOfWrongAnswers;
  late DateTime? testedAt;

  String get title => front;

  CardModel(this.id, this.bookId, this.front, this.back, this.sequence,
      [this.numberOfCorrectAnswers = 0,
      this.numberOfWrongAnswers = 0,
      this.testedAt]);

  factory CardModel.fromJson(dynamic json) {
    return CardModel(
      json[colId] as String,
      json[colBookId] as String,
      json[colFront] as String,
      json[colBack] as String,
      json[colSequence] as int,
      json[colNumberOfCorrectAnswers] as int,
      json[colNumberOfWrongAnswers] as int,
      json[colTestedAt] != null
          ? DateTime.parse(json[colTestedAt]).toLocal()
          : null,
    );
  }

  @override
  String toString() {
    return '{$id, $bookId, $front, $back, $sequence, $numberOfCorrectAnswers, $numberOfWrongAnswers, $testedAt}';
  }

  Map<String, dynamic> toJson() => {
        colId: id,
        colBookId: bookId,
        colFront: front,
        colBack: back,
        colSequence: sequence,
        colNumberOfCorrectAnswers: numberOfCorrectAnswers,
        colNumberOfWrongAnswers: numberOfWrongAnswers,
        colTestedAt: testedAt?.toUtc().toIso8601String()
      };
}
