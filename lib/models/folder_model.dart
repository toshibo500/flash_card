class FolderModel {
  static const String tableName = 'folders';
  static const String colId = 'id';
  static const String colTitle = 'title';
  static const String colSummary = 'summary';
  static const String colSequence = 'sequence';

  final String id;
  final String title;
  final String summary;
  final int sequence;

  FolderModel(this.id, this.title, this.summary, this.sequence);

  factory FolderModel.fromJson(dynamic json) {
    return FolderModel(json[colId] as String, json[colTitle] as String,
        json[colSummary] as String, json[colSequence] as int);
  }

  @override
  String toString() {
    return '{$id, $title, $summary, $sequence}';
  }

  Map<String, dynamic> toJson() => {
        colId: id,
        colTitle: title,
        colSummary: summary,
        colSequence: sequence,
      };
}
