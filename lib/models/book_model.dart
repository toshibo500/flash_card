class BookModel {
  final String id;
  final String folderId;
  final String title;
  final String summary;

  BookModel(this.id, this.folderId, this.title, this.summary);

  factory BookModel.fromJson(dynamic json) {
    return BookModel(json['id'] as String, json['folderId'] as String,
        json['title'] as String, json['summary'] as String);
  }

  @override
  String toString() {
    return '{$id, $folderId, $title, $summary}';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'folderId': folderId,
        'title': title,
        'summary': summary,
      };
}
