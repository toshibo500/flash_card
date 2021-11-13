class BookModel {
  static const String tableName = 'books';
  static const String colId = 'id';
  static const String colFolderId = 'folderId';
  static const String colTitle = 'title';
  static const String colSummary = 'summary';

  final String id;
  final String folderId;
  final String title;
  final String summary;

  BookModel(this.id, this.folderId, this.title, this.summary);

  factory BookModel.fromJson(dynamic json) {
    return BookModel(json[colId] as String, json[colFolderId] as String,
        json[colTitle] as String, json[colSummary] as String);
  }

  @override
  String toString() {
    return '{$id, $folderId, $title, $summary}';
  }

  Map<String, dynamic> toJson() => {
        colId: id,
        folderId: folderId,
        colTitle: title,
        colSummary: summary,
      };
}
