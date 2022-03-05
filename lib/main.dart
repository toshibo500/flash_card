import 'package:flash_card/models/card_model.dart';
import 'package:flutter/material.dart';
import 'package:flash_card/models/folder_model.dart';
import 'package:flash_card/views/folder_page.dart';
import 'package:flash_card/views/input_card_page.dart';
import 'package:flash_card/views/quiz_page.dart';
import 'package:flash_card/views/quiz_result_page.dart';
import 'package:flash_card/views/quiz_result_list_page.dart';
import 'package:flash_card/views/web_view_page.dart';
import 'package:flash_card/views/settings_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flash_card/globals.dart';

void main() {
  //向き指定
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, //縦固定
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // debugのバナーを消す
//      theme: ThemeData.light(), // ライト用テーマ
      theme: ThemeData.dark(), // ライト用テーマ
      darkTheme: ThemeData.dark(), // ダーク用テーマ
      themeMode: ThemeMode.system, // モードをシステム設定にする
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      routes: {
        "/": (BuildContext context) => const MyHomePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/folderPage') {
          return MaterialPageRoute(
            builder: (context) =>
                FolderPage(folder: settings.arguments as FolderModel),
          );
        }
        if (settings.name == '/inputCardPage') {
          return MaterialPageRoute(
            builder: (context) =>
                InputCardPage(card: settings.arguments as CardModel),
          );
        }
        if (settings.name == '/quizPage') {
          return MaterialPageRoute(
            builder: (context) =>
                QuizPage(param: settings.arguments as QuizPageParameters),
          );
        }
        if (settings.name == '/quizResultPage') {
          return MaterialPageRoute(
              builder: (context) =>
                  QuizResultPage(id: settings.arguments as String));
        }
        if (settings.name == '/quizResultListPage') {
          return MaterialPageRoute(
              builder: (context) =>
                  QuizResultListPage(folderId: settings.arguments as String));
        }
        if (settings.name == '/webViewPage') {
          return MaterialPageRoute(
              builder: (context) => WebViewPage(
                  params: settings.arguments as WevViewPageParameters));
        }
        if (settings.name == '/settingsPage') {
          return MaterialPageRoute(builder: (context) => const SettingsPage());
        }
        return null;
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // Global変数初期化
    Globals().initGlobals(context);
    // return const Scaffold(body: FolderListPage());
    return FolderPage(
        folder: FolderModel(
            '00000000000000000', '', L10n.of(context)!.appTitle, '', 0));
  }
}
