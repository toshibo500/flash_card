import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  final Map<int, String> _testModeItems = {0: 'Self mode', 1: 'Dictation'};
  Map<int, String> get testModeItems => _testModeItems;
  static const int testModeSelfMode = 1;

  void initGlobals(BuildContext context) {
    _frontAndBackItems[cardFrontKey] = L10n.of(context)!.cardFront;
    _frontAndBackItems[cardBackKey] = L10n.of(context)!.cardBack;
    _testModeItems[0] = L10n.of(context)!.testModeSelf;
    _testModeItems[1] = L10n.of(context)!.testModeDictation;
    // フォルダアイコン
    _folderIcon = const Icon(Icons.folder_rounded, color: iconColor1);
    // ブックアイコン
    _bookIcon = const Icon(Icons.style_rounded, color: iconColor3);
    // カードアイコン
    _cardIcon = const Icon(Icons.description_rounded, color: iconColor2);
  }

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
  static const Color panelBtnForeColor1 = Colors.white;
  static const Color panelBtnForeColor2 = Colors.lightBlue;
  static const Color panelBtnForeColor3 = Colors.white;

  // panelボタンスタイル
  static ButtonStyle panelbtnStyle = ElevatedButton.styleFrom(
      primary: panelBtnForeColor2,
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
      // onPrimary: panelBtnForeColor2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
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

  // テキストスタイル
  static const TextStyle titleTextStyle = TextStyle(
    //color: Colors.black54,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
    letterSpacing: 1,
    fontSize: 18.0,
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
    fontWeight: FontWeight.w200,
    fontFamily: 'Roboto',
    letterSpacing: 1,
    fontSize: 18.0,
  );
  static ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      primary: buttonColor1,
      onPrimary: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ));

  static const TextStyle dataTableColumnStyle =
      TextStyle(fontStyle: FontStyle.italic, fontSize: 12);
}
