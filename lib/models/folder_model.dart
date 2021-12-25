import 'package:flash_card/models/book_model.dart';

class FolderModel {
  static const String tableName = 'folders';
  static const String colId = 'id';
  static const String colTitle = 'title';
  static const String colSummary = 'summary';
  static const String colSequence = 'sequence';
  static const String colTestedAt = 'testedAt';

  final String id;
  final String title;
  final String summary;
  final int sequence;
  late DateTime? testedAt;

  List<BookModel>? books = [];

  FolderModel(this.id, this.title, this.summary, this.sequence,
      [this.testedAt]);

  factory FolderModel.fromJson(dynamic json) {
    return FolderModel(
      json[colId] as String,
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
    return '{$id, $title, $summary, $sequence, $testedAt}';
  }

  Map<String, dynamic> toJson() => {
        colId: id,
        colTitle: title,
        colSummary: summary,
        colSequence: sequence,
        colTestedAt: testedAt?.toUtc().toIso8601String()
      };
}
