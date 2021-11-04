class FolderModel {
  final String title;
  final String summary;

  FolderModel(this.title, this.summary);

  factory FolderModel.fromJson(dynamic json) {
    return FolderModel(json['title'] as String, json['summary'] as String);
  }

  @override
  String toString() {
    return '{ $title, $summary}';
  }

  // 使わないかも
  Map<String, String> toJson() => {
        'title': title,
        'summary': summary,
      };
}
