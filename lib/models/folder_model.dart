import 'package:flash_card/models/card_model.dart';
import 'package:flash_card/models/model.dart';

class FolderModel implements Model {
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
  late bool? hasChild; // フォルダー選択画面のみで利用

  List<CardModel> cards = [];

  FolderModel(this.id, this.parentId, this.title, this.summary, this.sequence,
      [this.quizedAt, this.hasChild]);

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

  @override
  List<dynamic> toList() {
    return [
      id,
      parentId,
      title,
      summary,
      sequence,
      quizedAt?.toUtc().toIso8601String() ?? ''
    ];
  }

  @override
  factory FolderModel.fromList(List<dynamic> list) {
    return FolderModel(
      list[0] as String,
      (list[1] ?? '') as String,
      list[2] as String,
      list[3] as String,
      list[4] != '' ? int.parse(list[4]) : 0,
      list[5] != '' ? DateTime.parse(list[5]).toLocal() : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        colId: id,
        colParentId: parentId,
        colTitle: title,
        colSummary: summary,
        colSequence: sequence,
        colQuizedAt: quizedAt?.toUtc().toIso8601String()
      };
}
