import 'package:flash_card/models/card_model.dart';
import 'package:flutter/material.dart';
import 'package:flash_card/views/folder_list_page.dart';
import 'package:flash_card/models/folder_model.dart';
import 'package:flash_card/models/book_model.dart';
import 'package:flash_card/views/folder_page.dart';
import 'package:flash_card/views/book_page.dart';
import 'package:flash_card/views/input_card_page.dart';
import 'package:flash_card/views/test_page.dart';
import 'package:flash_card/views/test_result_page.dart';
import 'package:flash_card/views/test_result_list_page.dart';
import 'package:flash_card/views/web_view_page.dart';
import 'package:flash_card/views/settings_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flash_card/globals.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(), // ライト用テーマ
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
        if (settings.name == '/bookPage') {
          return MaterialPageRoute(
            builder: (context) =>
                BookPage(book: settings.arguments as BookModel),
          );
        }
        if (settings.name == '/inputCardPage') {
          return MaterialPageRoute(
            builder: (context) =>
                InputCardPage(card: settings.arguments as CardModel),
          );
        }
        if (settings.name == '/testPage') {
          return MaterialPageRoute(
            builder: (context) =>
                TestPage(param: settings.arguments as TestPageParameters),
          );
        }
        if (settings.name == '/testResultPage') {
          return MaterialPageRoute(
              builder: (context) =>
                  TestResultPage(id: settings.arguments as String));
        }
        if (settings.name == '/testResultListPage') {
          return MaterialPageRoute(
              builder: (context) =>
                  TestResultListPage(bookId: settings.arguments as String));
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
    return const Scaffold(body: FolderListPage());
  }
}
