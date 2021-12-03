class PreferenceModel {
  static const String tableName = 'preferences';
  static const String colFrontSideLang = 'frontSideLang';
  static const String colBackSideLang = 'backSideLang';
  static const String colQAOrder = 'qAOrder';

  String? frontSideLang;
  String? backSideLang;
  int? qAorder;

  PreferenceModel([this.frontSideLang, this.backSideLang, this.qAorder]);

  factory PreferenceModel.fromJson(dynamic json) {
    return PreferenceModel(
      json[colFrontSideLang] ?? 'en-US',
      json[colBackSideLang] ?? 'ja-JP',
      json[colQAOrder] ?? 0,
    );
  }

  @override
  String toString() {
    return '{$frontSideLang, $backSideLang, $qAorder}';
  }

  Map<String, dynamic> toJson() => {
        colFrontSideLang: frontSideLang,
        colBackSideLang: backSideLang,
        colQAOrder: qAorder,
      };
}
