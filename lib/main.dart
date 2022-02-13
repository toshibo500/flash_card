import 'package:flash_card/models/user_model.dart';
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
import 'package:flash_card/views/account/account_page.dart';
import 'package:flash_card/views/account/sign_in_page.dart';
import 'package:flash_card/views/account/sign_up_page.dart';
import 'package:flash_card/views/account/sign_in_method.dart';
import 'package:flash_card/views/account/password_page.dart';
import 'package:flash_card/views/account/rest_password_page.dart';
import 'package:flash_card/views/account/single_sign_on_page.dart';
import 'package:flash_card/models/repositories/user_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flash_card/views/backup_page.dart';

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
      theme: ThemeData.light(), // ライト用テーマ
//      theme: ThemeData.dark(), // ライト用テーマ
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
        if (settings.name == '/accountPage') {
          return MaterialPageRoute(builder: (context) => const AccountPage());
        }
        if (settings.name == '/signInPage') {
          return MaterialPageRoute(builder: (context) => const SignInPage());
        }
        if (settings.name == '/signUpPage') {
          return MaterialPageRoute(builder: (context) => const SignUpPage());
        }
        if (settings.name == '/signInMethodPage') {
          return MaterialPageRoute(
              builder: (context) => const SignInMethodPage());
        }
        if (settings.name == '/passwordPage') {
          return MaterialPageRoute(builder: (context) => const PasswordPage());
        }
        if (settings.name == '/restPasswordPage') {
          return MaterialPageRoute(
              builder: (context) => const RestPasswordPage());
        }
        if (settings.name == '/singleSignOnPage') {
          return MaterialPageRoute(
              builder: (context) => SingleSignOnPage(
                    loginMethod: settings.arguments as LoginMethod,
                  ));
        }
        if (settings.name == '/backupPage') {
          return MaterialPageRoute(builder: (context) => const BackupPage());
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

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    initFireBase();

    WidgetsBinding.instance!.addObserver(this);
  }

  void initFireBase() async {
    await Firebase.initializeApp();
  }

  @override
  void dispose() {
    // print("dispose");
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // print("stete = $state");
    switch (state) {
      case AppLifecycleState.inactive:
        // print('非アクティブになったときの処理');
        break;
      case AppLifecycleState.paused:
        // print('停止されたときの処理');
        break;
      case AppLifecycleState.resumed:
        // print('再開されたときの処理');
        break;
      case AppLifecycleState.detached:
        // print('破棄されたときの処理');
        break;
    }
  }

  // ログイン状態取得
  void _getUserInfo() async {
    Globals().userInfo = await UserRepository.get();
  }

  @override
  Widget build(BuildContext context) {
    // Global変数初期化
    Globals().initGlobals(context);
    // ログイン状態取得
    _getUserInfo();
    // return const Scaffold(body: FolderListPage());
    return FolderPage(
        folder: FolderModel(
            '00000000000000000', '', L10n.of(context)!.appTitle, '', 0));
  }
}
