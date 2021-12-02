class PreferenceModel {
  static const String tableName = 'preferences';
  static const String colFrontSideLang = 'frontSideLang';
  static const String colBackSideLang = 'backSideLang';

  String frontSideLang;
  String backSideLang;

  PreferenceModel([this.frontSideLang = 'en-US', this.backSideLang = 'ja-JP']);

  factory PreferenceModel.fromJson(dynamic json) {
    return PreferenceModel(
      json[colFrontSideLang] as String,
      json[colBackSideLang] as String,
    );
  }

  @override
  String toString() {
    return '{$frontSideLang, $backSideLang}';
  }

  Map<String, dynamic> toJson() => {
        colFrontSideLang: frontSideLang,
        colBackSideLang: backSideLang,
      };
}
