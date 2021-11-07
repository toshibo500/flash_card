import 'package:flash_card/models/folder_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flash_card/components/input_title_dialog.dart';
import 'package:flash_card/models/book_list_model.dart';
import 'package:flash_card/components/file_list_view.dart';
import 'package:flash_card/models/app_status.dart';

class FolderPage extends StatelessWidget {
  const FolderPage({Key? key, required this.folder}) : super(key: key);
  final FolderModel folder;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BookListModel()),
        ChangeNotifierProvider(create: (context) => AppStatusModel()),
      ],
      child: Scaffold(body: _FolderPage(pageTitle: folder.title)),
    );
  }
}

class _FolderPage extends StatelessWidget {
  const _FolderPage({Key? key, required this.pageTitle}) : super(key: key);
  final String pageTitle;

  @override
  Widget build(BuildContext context) {
    var _bookListModel = Provider.of<BookListModel>(context);
    var _appStatus = Provider.of<AppStatusModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => {},
        ),
        actions: [
          IconButton(
              icon: Icon(_appStatus.editMode ? Icons.done : Icons.edit_rounded),
              onPressed: () {
                _appStatus.editMode = !_appStatus.editMode;
              }),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              String title = await showInputTitleDialog(context: context);
              if (title != "") {
                _bookListModel.add('', title, '');
              }
            },
          ),
        ],
      ),
      body: Consumer<BookListModel>(builder: (context, folderList, _) {
        return FileListView(model: _bookListModel, items: folderList.items);
      }),
    );
  }
}
