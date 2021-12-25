import 'package:flash_card/models/card_model.dart';

class BookModel {
  static const String tableName = 'books';
  static const String colId = 'id';
  static const String colFolderId = 'folderId';
  static const String colTitle = 'title';
  static const String colSummary = 'summary';
  static const String colSequence = 'sequence';
  static const String colTestedAt = 'testedAt';

  final String id;
  final String folderId;
  final String title;
  final String summary;
  final int sequence;
  late DateTime? testedAt;

  List<CardModel> cards = [];

  BookModel(this.id, this.folderId, this.title, this.summary, this.sequence,
      [this.testedAt]);

  factory BookModel.fromJson(dynamic json) {
    return BookModel(
      json[colId] as String,
      json[colFolderId] as String,
      json[colTitle] as String,
      json[colSummary] as String,
      json[colSequence] as int,
      json[colTestedAt] != null
          ? DateTime.parse(json[colTestedAt]).toLocal()
          : null,
    );
  }

  @override
  String toString() {
    return '{$id, $folderId, $title, $summary, $sequence, $testedAt}';
  }

  Map<String, dynamic> toJson() => {
        colId: id,
        colFolderId: folderId,
        colTitle: title,
        colSummary: summary,
        colSequence: sequence,
        colTestedAt: testedAt?.toUtc().toIso8601String()
      };
}
