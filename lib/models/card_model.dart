class CardModel {
  static const String tableName = 'cards';
  static const String colId = 'id';
  static const String colFolderId = 'folderId';
  static const String colFront = 'front';
  static const String colBack = 'back';
  static const String colSequence = 'sequence';
  static const String colCorrectNum = 'correctNum';
  static const String colWrongNum = 'wrongNum';
  static const String colQuizedAt = 'quizedAt';

  final String id;
  final String folderId;
  String front;
  String back;
  final int sequence;
  late int correctNum;
  late int wrongNum;
  late DateTime? quizedAt;

  String get title => front;

  CardModel(this.id, this.folderId, this.front, this.back, this.sequence,
      [this.correctNum = 0, this.wrongNum = 0, this.quizedAt]);

  factory CardModel.fromJson(dynamic json) {
    return CardModel(
      json[colId] as String,
      json[colFolderId] as String,
      json[colFront] as String,
      json[colBack] as String,
      json[colSequence] as int,
      json[colCorrectNum] as int,
      json[colWrongNum] as int,
      json[colQuizedAt] != null
          ? DateTime.parse(json[colQuizedAt]).toLocal()
          : null,
    );
  }

  @override
  String toString() {
    return '{$id, $folderId, $front, $back, $sequence, $correctNum, $wrongNum, $quizedAt}';
  }

  Map<String, dynamic> toJson() => {
        colId: id,
        colFolderId: folderId,
        colFront: front,
        colBack: back,
        colSequence: sequence,
        colCorrectNum: correctNum,
        colWrongNum: wrongNum,
        colQuizedAt: quizedAt?.toUtc().toIso8601String()
      };
}
