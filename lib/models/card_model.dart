class CardModel {
  static const String tableName = 'cards';
  static const String colId = 'id';
  static const String colBookId = 'bookId';
  static const String colFront = 'front';
  static const String colBack = 'back';
  static const String colSequence = 'sequence';

  final String id;
  final String bookId;
  final String front;
  final String back;
  final int sequence;

  CardModel(this.id, this.bookId, this.front, this.back, this.sequence);

  factory CardModel.fromJson(dynamic json) {
    return CardModel(
        json[colId] as String,
        json[colBookId] as String,
        json[colFront] as String,
        json[colBack] as String,
        json[colSequence] as int);
  }

  @override
  String toString() {
    return '{$id, $bookId, $front, $back, $sequence}';
  }

  Map<String, dynamic> toJson() => {
        colId: id,
        colBookId: bookId,
        colFront: front,
        colBack: back,
        colSequence: sequence,
      };
}
