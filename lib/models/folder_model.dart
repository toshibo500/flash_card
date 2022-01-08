import 'package:flash_card/models/card_model.dart';

class FolderModel {
  static const String tableName = 'folders';
  static const String colId = 'id';
  static const String colParentId = 'parentId';
  static const String colTitle = 'title';
  static const String colSummary = 'summary';
  static const String colSequence = 'sequence';
  static const String colQuizedAt = 'quizedAt';

  final String id;
  final String parentId;
  final String title;
  final String summary;
  final int sequence;
  late DateTime? quizedAt;

  List<CardModel> cards = [];

  FolderModel(this.id, this.parentId, this.title, this.summary, this.sequence,
      [this.quizedAt]);

  factory FolderModel.fromJson(dynamic json) {
    return FolderModel(
      json[colId] as String,
      json[colParentId] as String,
      json[colTitle] as String,
      json[colSummary] as String,
      json[colSequence] as int,
      json[colQuizedAt] != null
          ? DateTime.parse(json[colQuizedAt]).toLocal()
          : null,
    );
  }

  @override
  String toString() {
    return '{$id, $parentId, $title, $summary, $sequence, $quizedAt}';
  }

  Map<String, dynamic> toJson() => {
        colId: id,
        colParentId: parentId,
        colTitle: title,
        colSummary: summary,
        colSequence: sequence,
        colQuizedAt: quizedAt?.toUtc().toIso8601String()
      };
}
