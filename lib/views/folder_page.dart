import 'package:flash_card/models/folder_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flash_card/views/components/input_title_dialog.dart';
import 'package:flash_card/views/components/file_list_view.dart';
import 'package:flash_card/viewmodels/folder_viewmodel.dart';

class FolderPage extends StatelessWidget {
  const FolderPage({Key? key, required this.folder}) : super(key: key);
  final FolderModel folder;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FolderViewModel(),
      child: Scaffold(body: _FolderPage(pageTitle: folder.title)),
    );
  }
}

class _FolderPage extends StatelessWidget {
  const _FolderPage({Key? key, required this.pageTitle}) : super(key: key);
  final String pageTitle;

  @override
  Widget build(BuildContext context) {
    var _folderViweModel = Provider.of<FolderViewModel>(context);
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
              icon: Icon(
                  _folderViweModel.editMode ? Icons.done : Icons.edit_rounded),
              onPressed: () {
                _folderViweModel.editMode = !_folderViweModel.editMode;
              }),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              String title = await showInputTitleDialog(context: context);
              if (title != "") {
                _folderViweModel.add('', title, '');
              }
            },
          ),
        ],
      ),
      body: Consumer<FolderViewModel>(builder: (context, viewModel, _) {
        return FileListView(viewModel: viewModel, nextPage: "/");
      }),
    );
  }
}
