class FolderModel {
  final String id;
  final String title;
  final String summary;

  FolderModel(this.id, this.title, this.summary);

  factory FolderModel.fromJson(dynamic json) {
    return FolderModel(json['id'] as String, json['title'] as String,
        json['summary'] as String);
  }

  @override
  String toString() {
    return '{$id, $title, $summary}';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'summary': summary,
      };
}
