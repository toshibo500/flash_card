import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flash_card/models/book_list_model.dart';

class FolderPage extends StatelessWidget {
  const FolderPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      child: Scaffold(body: FolderScreen(title: title)),
      create: (context) => BookListModel(),
    );
  }
}

class FolderScreen extends StatefulWidget {
  const FolderScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _FolderScreen createState() => _FolderScreen();
}

class _FolderScreen extends State<FolderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => {},
        ),
      ),
    );
  }
}
