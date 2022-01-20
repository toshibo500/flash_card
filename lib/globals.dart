import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flash_card/models/card_model.dart';
import 'package:flash_card/utilities/stt.dart';

class Globals {
  Globals._();
  static final Globals _instance = Globals._();

  factory Globals() => _instance;

  // カードの表裏マスタ
  static const int cardFrontKey = 0;
  static const int cardBackKey = 1;
  final Map<int, String> _frontAndBackItems = {
    cardFrontKey: 'Front',
    cardBackKey: 'Back'
  };
  Map<int, String> get frontAndBackItems => _frontAndBackItems;

  // テストモードマスタ
  final Map<int, String> _quizModeItems = {0: 'Self mode', 1: 'Dictation'};
  Map<int, String> get quizModeItems => _quizModeItems;
  static const int quizModeSelfMode = 0;

  // テスト並び順マスタ
  final Map<int, String> _quizOrderItems = {
    0: 'RANDOM()',
    1: CardModel.colSequence,
    2: CardModel.colQuizedAt,
    3: CardModel.colCorrectNum,
  };
  Map<int, String> get quizOrderItems => _quizOrderItems;
  static const int quizOrderRandom = 0;

  // テスト並び替え方法マスタ
  final Map<int, String> _quizOrderMethodItems = {
    0: 'ASC',
    1: 'DESC',
  };
  Map<int, String> get quizOrderMethodItems => _quizOrderMethodItems;

  // 言語リストを取得
  final Map<String, String> _langItems = {};
  Map<String, String> get langItems => _langItems;

  void initGlobals(BuildContext context) {
    var l10n = L10n.of(context)!;
    _frontAndBackItems[cardFrontKey] = l10n.cardFront;
    _frontAndBackItems[cardBackKey] = l10n.cardBack;
    _quizModeItems[0] = l10n.quizModeSelf;
    _quizModeItems[1] = l10n.quizModeDictation;
    // フォルダアイコン
    _folderIcon = const Icon(Icons.folder_rounded, color: iconColor1);
    // カードアイコン
    _cardIcon = const Icon(Icons.style_rounded, color: iconColor2);
    // 正解アイコン
    _correctPopupIcon = const Icon(
      Icons.check_circle_rounded,
      color: correctColor,
      size: 38,
    );
    // 解アイコン
    _correctButtonIcon = const Icon(
      Icons.check_rounded,
      color: Colors.white,
      size: 22,
    ); // 不正解アイコン
    _incorrectButtonIcon = const Icon(
      Icons.clear_rounded,
      color: Colors.white,
      size: 22,
    );
    // カード裏面色
    cardBackSideColor = Theme.of(context).highlightColor;

    // カードテキストスタイル
    cardTextStye = Theme.of(context).textTheme.headline5!;

    // 言語リストを取得
    Stt _stt = Stt();
    _stt.initSpeechState().then((value) {
      for (var e in _stt.localeNames) {
        _langItems[e.localeId] = e.name;
      }
    });
  }

  // カードテキストスタイル
  late TextStyle cardTextStye;

  // チョコ色
  static const Color chocoColor = Color(0xFF6c3524);
  // バナナ色
  static const Color bananaColor = Color(0xFFffdb2b);

  // 背景色
  static const Color backgroundColor = chocoColor;
  // アイコン色 1
  static const Color iconColor1 = Colors.lightGreen;
  // アイコン色 2
  static const Color iconColor2 = Colors.lightBlue;
  // アイコン色 3
  static const Color iconColor3 = Color(0xFFBCAAA4);
  // ボタン色 1
  static const Color buttonColor1 = Colors.lightBlue;
  // ボタン色 2
  static const Color buttonColor2 = Color(0xFFBCAAA4);
  // FloatingActionButton色
  static const Color floatingBtnBackColor = chocoColor;
  static const Color floatingBtnForeColor = bananaColor;
  // panelボタン色
  static const Color panelBtnForeColor1 = Colors.lightBlue;
  static const Color panelBtnForeColor2 = Colors.lightBlue;
  static const Color panelBtnForeColor3 = Colors.white;

  // カード裏色
  late Color cardBackSideColor;

  // 正解色
  static const Color correctColor = Colors.green;
  // 不正解色
  static const Color incorrectColor = Colors.red;

  // panelボタンスタイル
  static ButtonStyle panelbtnStyle = ElevatedButton.styleFrom(
      primary: panelBtnForeColor2,
      fixedSize: const Size(230, 40),
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
      // onPrimary: panelBtnForeColor2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ));

  // フォルダアイコン
  late Icon _folderIcon;
  Icon get folderIcon => _folderIcon;
  // ブックアイコン
  late Icon _bookIcon;
  Icon get bookIcon => _bookIcon;
  // カードアイコン
  late Icon _cardIcon;
  Icon get cardIcon => _cardIcon;
  // 正解アイコン
  late Icon _correctPopupIcon;
  Icon get correctPopupIcon => _correctPopupIcon;
  // 正解ボタンアイコン
  late Icon _correctButtonIcon;
  Icon get correctButtonIcon => _correctButtonIcon;
  // 不正解ボタンアイコン
  late Icon _incorrectButtonIcon;
  Icon get incorrectButtonIcon => _incorrectButtonIcon;

  // テキストスタイル
  static const TextStyle titleTextStyle = TextStyle(
    //color: Colors.black54,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
    letterSpacing: 1,
    fontSize: 18.0,
  );
  // テキストスタイル
  static const TextStyle subtitleTextStyle = TextStyle(
    //color: Colors.black54,
    fontWeight: FontWeight.w500,
    color: Colors.black54,
    fontFamily: 'Roboto',
    letterSpacing: 1,
    fontSize: 16.0,
  );
  static const TextStyle contentTextStyle = TextStyle(
//    color: Colors.black,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    letterSpacing: 1,
    fontSize: 24.0,
  );
  static const TextStyle buttonTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
    letterSpacing: 1,
    fontSize: 15.0,
  );
  static ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      primary: buttonColor1,
      onPrimary: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ));

  static const TextStyle dataTableColumnStyle =
      TextStyle(fontStyle: FontStyle.italic, fontSize: 12);

  static const TextStyle correctPpopUpStyle =
      TextStyle(fontSize: 38, color: correctColor);
}
