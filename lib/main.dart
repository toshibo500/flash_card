import 'package:flash_card/models/card_model.dart';
import 'package:flutter/material.dart';
import 'package:flash_card/views/folder_list_page.dart';
import 'package:flash_card/models/folder_model.dart';
import 'package:flash_card/models/book_model.dart';
import 'package:flash_card/views/folder_page.dart';
import 'package:flash_card/views/book_page.dart';
import 'package:flash_card/views/input_card_page.dart';
import 'package:flash_card/views/test_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/": (BuildContext context) => const FolderListPage(
              title: 'Folder List',
            ),
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
        if (settings.name == '/TestPage') {
          return MaterialPageRoute(
            builder: (context) =>
                TestPage(book: settings.arguments as BookModel),
          );
        }
        return null;
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: FolderListPage(title: widget.title));
  }
}
