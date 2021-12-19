import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flash_card/views/components/input_title_dialog.dart';
import 'package:flash_card/views/components/file_list_view.dart';
import 'package:flash_card/viewmodels/folder_list_viewmodel.dart';
import 'package:flash_card/views/components/drawer_menu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../globals.dart';

class FolderListPage extends StatelessWidget {
  const FolderListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FolderListViewModel(),
      child: Scaffold(
          body: _FolderListPage(pageTitle: L10n.of(context)!.appTitle)),
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
        backgroundColor: Globals.backgroundColor,
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
              String title = await showInputTitleDialog(
                  context: context, dialogTitle: L10n.of(context)!.folderName);
              if (title != "") {
                _folderListViewModel.add(title, '');
              }
            },
          ),
        ],
      ),
      drawer: const SideDrawer(),
      body: Consumer<FolderListViewModel>(builder: (context, viewModel, _) {
        return FileListView(viewModel: viewModel, nextPage: "/folderPage");
      }),
    );
  }
}
