class PreferenceModel {
  static const String tableName = 'preferences';
  static const String colFrontSideLang = 'frontSideLang';
  static const String colBackSideLang = 'backSideLang';
  static const String colQuestion = 'question';
  static const String colQuizMode = 'quizMode';
  static const String colQuizNum = 'quizNum';
  static const String colQuizOrder = 'quizOrder';
  static const String colQuizOrderMethod = 'quizOrderMethod';

  String? frontSideLang;
  String? backSideLang;
  int? question;
  int? quizMode;
  int? quizNum;
  int? quizOrder;
  int? quizOrderMethod;

  PreferenceModel(
      [this.frontSideLang,
      this.backSideLang,
      this.question,
      this.quizMode,
      this.quizNum,
      this.quizOrder,
      this.quizOrderMethod]);

/*   static const int frontKey = 0;
  static const int backKey = 1;
  static const Map<int, String> frontAndBackItems = {
    frontKey: 'Front',
    backKey: 'Back'
  };
 */
/*   static const Map<int, String> quizModeItems = {
    0: 'Self mode',
    1: 'Dictation'
  };
  static const int quizModeSelfMode = 1; */

  factory PreferenceModel.fromJson(dynamic json) {
    return PreferenceModel(
      json[colFrontSideLang] ?? 'en-US',
      json[colBackSideLang] ?? 'ja-JP',
      json[colQuestion] ?? 0,
      json[colQuizMode] ?? 1,
      json[colQuizNum] ?? 10,
      json[colQuizOrder] ?? 0,
      json[colQuizOrderMethod] ?? 0,
    );
  }

  @override
  String toString() {
    return '{$frontSideLang, $backSideLang, $question, $quizMode,'
        ' $quizNum, $quizOrder, $quizOrderMethod}';
  }

  Map<String, dynamic> toJson() => {
        colFrontSideLang: frontSideLang,
        colBackSideLang: backSideLang,
        colQuestion: question,
        colQuizMode: quizMode,
        colQuizNum: quizNum,
        colQuizOrder: quizOrder,
        colQuizOrderMethod: quizOrderMethod,
      };
}
