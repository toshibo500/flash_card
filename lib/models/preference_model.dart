class PreferenceModel {
  static const String tableName = 'preferences';
  static const String colFrontSideLang = 'frontSideLang';
  static const String colBackSideLang = 'backSideLang';
  static const String colQuestion = 'question';
  static const String colTestMode = 'testMode';
  static const String colNumOfTest = 'numOfTest';

  String? frontSideLang;
  String? backSideLang;
  int? question;
  int? testMode;
  int? numOfTest;

  PreferenceModel(
      [this.frontSideLang,
      this.backSideLang,
      this.question,
      this.testMode,
      this.numOfTest]);

/*   static const int frontKey = 0;
  static const int backKey = 1;
  static const Map<int, String> frontAndBackItems = {
    frontKey: 'Front',
    backKey: 'Back'
  };
 */
/*   static const Map<int, String> testModeItems = {
    0: 'Self mode',
    1: 'Dictation'
  };
  static const int testModeSelfMode = 1; */

  factory PreferenceModel.fromJson(dynamic json) {
    return PreferenceModel(
      json[colFrontSideLang] ?? 'en-US',
      json[colBackSideLang] ?? 'ja-JP',
      json[colQuestion] ?? 0,
      json[colTestMode] ?? 1,
      json[colNumOfTest] ?? 10,
    );
  }

  @override
  String toString() {
    return '{$frontSideLang, $backSideLang, $question, $testMode, $numOfTest}';
  }

  Map<String, dynamic> toJson() => {
        colFrontSideLang: frontSideLang,
        colBackSideLang: backSideLang,
        colQuestion: question,
        colTestMode: testMode,
        colNumOfTest: numOfTest,
      };
}
