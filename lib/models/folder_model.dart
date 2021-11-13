class FolderModel {
  static const String tableName = 'folders';
  static const String colId = 'id';
  static const String colTitle = 'title';
  static const String colSummary = 'summary';

  final String id;
  final String title;
  final String summary;

  FolderModel(this.id, this.title, this.summary);

  factory FolderModel.fromJson(dynamic json) {
    return FolderModel(json[colId] as String, json[colTitle] as String,
        json[colSummary] as String);
  }

  @override
  String toString() {
    return '{$id, $title, $summary}';
  }

  Map<String, dynamic> toJson() => {
        colId: id,
        colTitle: title,
        colSummary: summary,
      };
}
