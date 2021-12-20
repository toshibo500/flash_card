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
    _folderIcon = Icon(Icons.folder_rounded, color: Colors.orange[200]);
    // ブックアイコン
    _bookIcon = Icon(Icons.auto_stories_rounded, color: Colors.pink[200]);
    // カードアイコン
    _cardIcon = Icon(Icons.style_rounded, color: Colors.blue[200]);
  }

  // 背景色
  static const Color backgroundColor = Color(0xFF6c3524);
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
    color: Colors.black54,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
    letterSpacing: 1,
    fontSize: 18.0,
  );
  static const TextStyle contentTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    letterSpacing: 1,
    fontSize: 24.0,
  );
  static const TextStyle buttonTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontFamily: 'Roboto',
    letterSpacing: 1,
    fontSize: 18.0,
  );
  static const TextStyle dataTableColumnStyle = TextStyle(
      color: Colors.black54, fontStyle: FontStyle.italic, fontSize: 12);
}
