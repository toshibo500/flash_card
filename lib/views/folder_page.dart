import 'package:flash_card/models/card_model.dart';
import 'package:flash_card/models/folder_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flash_card/views/components/input_title_dialog.dart';
import 'package:flash_card/views/components/file_list_view.dart';
import 'package:flash_card/viewmodels/folder_viewmodel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flash_card/views/components/drawer_menu.dart';
import 'package:flash_card/globals.dart';
import 'package:flash_card/views/quiz_page.dart';

class FolderPage extends StatelessWidget {
  const FolderPage({Key? key, required this.folder}) : super(key: key);
  final FolderModel folder;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FolderViewModel(folder),
      child: Scaffold(
        body: _FolderPage(pageTitle: folder.title),
      ),
    );
  }
}

enum MenuCommand { folder, card }

class _FolderPage extends StatelessWidget {
  const _FolderPage({Key? key, required this.pageTitle}) : super(key: key);
  final String pageTitle;

  @override
  Widget build(BuildContext context) {
    var _folderViweModel = Provider.of<FolderViewModel>(context);

    // テスト開始パネル
    Widget _bottomPanel = Container(
      height: 100,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
      color: Theme.of(context).backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 100,
            alignment: Alignment.centerLeft,
            child: IconButton(
              color: Globals.panelBtnForeColor1,
              icon: const Icon(Icons.settings_rounded),
              onPressed: () async {
                await Navigator.of(context).pushNamed('/settingsPage');
                _folderViweModel.getPreference();
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              style: Globals.panelbtnStyle,
              child: Text(L10n.of(context)!.quizStart),
              onPressed: () async {
                await Navigator.of(context).pushNamed('/quizPage',
                    arguments: QuizPageParameters(
                        folder: _folderViweModel.selectedFolder,
                        quizNum: _folderViweModel.preference.quizNum!,
                        quizMode: _folderViweModel.preference.quizMode!));
              },
            ),
          ),
          Container(
            width: 120,
            alignment: Alignment.centerRight,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(
                color: Globals.panelBtnForeColor3,
                icon: const Icon(
                  Icons.list_rounded,
                  size: 45,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/quizResultListPage',
                      arguments: _folderViweModel.selectedFolder.id);
                },
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  L10n.of(context)!.resultList,
                  style: const TextStyle(
                      color: Globals.panelBtnForeColor3, fontSize: 10),
                ),
              )
            ]),
          ),
        ],
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text(pageTitle),
          backgroundColor: Globals.backgroundColor,
          leading: Navigator.of(context).canPop()
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_outlined),
                  onPressed: () => {Navigator.of(context).pop()},
                )
              : null,
          actions: [
            IconButton(
                icon: Icon(_folderViweModel.editMode
                    ? Icons.done
                    : Icons.edit_rounded),
                onPressed: () {
                  _folderViweModel.editMode = !_folderViweModel.editMode;
                }),
            PopupMenuButton<MenuCommand>(
              onSelected: (MenuCommand value) async {
                if (value == MenuCommand.folder) {
                  String title = await showInputTitleDialog(
                      context: context,
                      dialogTitle: L10n.of(context)!.folderName);
                  if (title != "") {
                    _folderViweModel.addFolder(title, '');
                  }
                } else {
                  FolderModel folder = _folderViweModel.selectedFolder;
                  bool next = true;
                  while (next) {
                    CardModel card = CardModel('', folder.id, '', '', 0);
                    next = await Navigator.of(context)
                        .pushNamed('/inputCardPage', arguments: card) as bool;
                    if (card.front != '') {
                      _folderViweModel.addCard(card.front, card.back);
                    }
                  }
                }
              },
              icon: const Icon(Icons.add),
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<MenuCommand>>[
                PopupMenuItem<MenuCommand>(
                  value: MenuCommand.folder,
                  enabled: _folderViweModel.hasSubFolders ||
                      _folderViweModel.isEmptyFolder,
                  child: Text(L10n.of(context)!.createFolderMemuTitle),
                ),
                PopupMenuItem<MenuCommand>(
                  value: MenuCommand.card,
                  enabled: !_folderViweModel.hasSubFolders ||
                      _folderViweModel.isEmptyFolder,
                  child: Text(L10n.of(context)!.createCardMemuTitle),
                ),
              ],
            ),
          ],
        ),
        drawer: Navigator.of(context).canPop() ? null : const SideDrawer(),
        body: Column(children: [
          Expanded(
            child: Consumer<FolderViewModel>(builder: (context, viewModel, _) {
              return FileListView(
                  viewModel: viewModel,
                  nextPage: viewModel.hasSubFolders ? "/folderPage" : '');
            }),
          ),
        ]),
        floatingActionButton: Visibility(
          visible: _folderViweModel.hasCard,
          child: FloatingActionButton(
            onPressed: () async {
              await showModalBottomSheet<int>(
                context: context,
                builder: (BuildContext context) {
                  return _bottomPanel;
                },
              );
            },
            tooltip: 'Quiz',
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.text_snippet_rounded),
              Text(
                L10n.of(context)!.quiz,
                style: const TextStyle(fontSize: 12),
              )
            ]),
          ), // This trailing comma ma
        ));
  }
}
