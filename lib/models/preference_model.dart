class PreferenceModel {
  static const String tableName = 'preferences';
  static const String colFrontSideLang = 'frontSideLang';
  static const String colBackSideLang = 'backSideLang';
  static const String colQuestion = 'question';
  static const String colQuizMode = 'quizMode';
  static const String colNumOfQuiz = 'numOfQuiz';
  static const String colOrderOfQuiz = 'orderOfQuiz';

  String? frontSideLang;
  String? backSideLang;
  int? question;
  int? quizMode;
  int? numOfQuiz;
  int? orderOfQuiz;

  PreferenceModel(
      [this.frontSideLang,
      this.backSideLang,
      this.question,
      this.quizMode,
      this.numOfQuiz,
      this.orderOfQuiz]);

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
      json[colNumOfQuiz] ?? 10,
      json[colOrderOfQuiz] ?? 0,
    );
  }

  @override
  String toString() {
    return '{$frontSideLang, $backSideLang, $question, $quizMode, $numOfQuiz, $orderOfQuiz}';
  }

  Map<String, dynamic> toJson() => {
        colFrontSideLang: frontSideLang,
        colBackSideLang: backSideLang,
        colQuestion: question,
        colQuizMode: quizMode,
        colNumOfQuiz: numOfQuiz,
        colOrderOfQuiz: orderOfQuiz,
      };
}
