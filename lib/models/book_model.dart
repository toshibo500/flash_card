class BookModel {
  static const String tableName = 'books';
  static const String colId = 'id';
  static const String colFolderId = 'folderId';
  static const String colTitle = 'title';
  static const String colSummary = 'summary';
  static const String colSequence = 'sequence';

  final String id;
  final String folderId;
  final String title;
  final String summary;
  final int sequence;

  BookModel(this.id, this.folderId, this.title, this.summary, this.sequence);

  factory BookModel.fromJson(dynamic json) {
    return BookModel(
        json[colId] as String,
        json[colFolderId] as String,
        json[colTitle] as String,
        json[colSummary] as String,
        json[colSequence] as int);
  }

  @override
  String toString() {
    return '{$id, $folderId, $title, $summary, $sequence}';
  }

  Map<String, dynamic> toJson() => {
        colId: id,
        colFolderId: folderId,
        colTitle: title,
        colSummary: summary,
        colSequence: sequence,
      };
}
