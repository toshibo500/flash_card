import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flash_card/components/input_title_dialog.dart';
import 'package:flash_card/models/folder_model.dart';
import 'package:flash_card/models/folder_list_model.dart';
import 'package:flash_card/components/file_list_view.dart';
import 'package:flash_card/models/app_status.dart';

class FolderListPage extends StatelessWidget {
  const FolderListPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FolderListModel()),
        ChangeNotifierProvider(create: (context) => AppStatusModel()),
      ],
      child: Scaffold(body: FolderListScreen(title: title)),
    );
  }
}

class FolderListScreen extends StatefulWidget {
  const FolderListScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _FolderListScreen createState() => _FolderListScreen();
}

class _FolderListScreen extends State<FolderListScreen> {
  List<FolderModel> _folderItems = [];

  @override
  Widget build(BuildContext context) {
    final _folderListModel = Provider.of<FolderListModel>(context);
    final _appStatus = Provider.of<AppStatusModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                _folderListModel.add(title, '');
              }
            },
          ),
        ],
      ),
      body: Consumer<FolderListModel>(builder: (context, folderList, _) {
        _folderItems = folderList.items;
        return FileListView(model: _folderListModel, items: _folderItems);
      }),
    );
  }
}
