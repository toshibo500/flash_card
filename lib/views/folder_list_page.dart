import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flash_card/views/components/input_title_dialog.dart';
import 'package:flash_card/views/components/file_list_view.dart';
import 'package:flash_card/viewmodels/folder_list_viewmodel.dart';

class FolderListPage extends StatelessWidget {
  const FolderListPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FolderListViewModel(),
      child: Scaffold(body: _FolderListPage(pageTitle: title)),
    );
  }
}

class _FolderListPage extends StatelessWidget {
  const _FolderListPage({Key? key, required this.pageTitle}) : super(key: key);
  final String pageTitle;

  @override
  Widget build(BuildContext context) {
    var _folderListViewModel = Provider.of<FolderListViewModel>(context);
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
              icon: Icon(_folderListViewModel.editMode
                  ? Icons.done
                  : Icons.edit_rounded),
              onPressed: () {
                _folderListViewModel.editMode = !_folderListViewModel.editMode;
              }),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              String title = await showInputTitleDialog(context: context);
              if (title != "") {
                _folderListViewModel.addFolder(title, '');
              }
            },
          ),
        ],
      ),
      body: Consumer<FolderListViewModel>(builder: (context, viewModel, _) {
        return FileListView(viewModel: viewModel, nextPage: "/folderPage");
      }),
    );
  }
}
