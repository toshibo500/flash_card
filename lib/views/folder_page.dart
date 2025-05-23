import 'package:flash_card/models/card_model.dart';
import 'package:flash_card/models/folder_model.dart';
import 'package:flash_card/models/repositories/card_repository.dart';
import 'package:flash_card/models/repositories/folder_repository.dart';
import 'package:flash_card/models/repositories/preference_repository.dart';
import 'package:flash_card/models/repositories/quiz_repository.dart';
import 'package:flash_card/views/input_card_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    FolderRepository folderRepository = FolderRepository();
    CardRepository cardRepository = CardRepository();
    PreferenceRepository prefRepository = PreferenceRepository();
    QuizRepository quizRepository = QuizRepository();

    return ChangeNotifierProvider(
      create: (context) => FolderViewModel(
          folderRepository: folderRepository,
          cardRepository: cardRepository,
          prefRepository: prefRepository,
          quizRepository: quizRepository,
          selectedFolder: folder),
      child: Scaffold(
        body: FolderPageBody(pageTitle: folder.title),
      ),
    );
  }
}

enum MenuCommand { folder, card }

class FolderPageBody extends StatelessWidget {
  const FolderPageBody({Key? key, required this.pageTitle}) : super(key: key);
  final String pageTitle;

  @override
  Widget build(BuildContext context) {
    var _folderViweModel = Provider.of<FolderViewModel>(context);

    // テスト開始パネル
    Widget _bottomPanel = Container(
      height: 100,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      color: Theme.of(context).backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 50,
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
                _folderViweModel.getAllCard(_folderViweModel.selectedFolder.id);
              },
            ),
          ),
          Container(
            width: 50,
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
            Visibility(
                visible: _folderViweModel.hasCard,
                child: IconButton(
                  icon: const Icon(
                    Icons.history_rounded,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/quizResultListPage',
                        arguments: _folderViweModel.selectedFolder.id);
                  },
                  tooltip: L10n.of(context)!.resultList,
                )),
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
                  if (title.isNotEmpty) {
                    _folderViweModel.addFolder(title, '').then((value) =>
                        Fluttertoast.showToast(msg: L10n.of(context)!.saved));
                  }
                } else {
                  FolderModel folder = _folderViweModel.selectedFolder;
                  bool next = true;
                  InputCardPageParameters params = InputCardPageParameters(
                    card: CardModel('', folder.id, '', '', 0),
                  );
                  while (next) {
                    params.card = CardModel(
                        '',
                        folder.id,
                        '',
                        '',
                        0,
                        0,
                        0,
                        null,
                        _folderViweModel.preference.frontSideLang,
                        _folderViweModel.preference.backSideLang);
                    next = await Navigator.of(context)
                        .pushNamed('/inputCardPage', arguments: params) as bool;
                    if (params.card.front != '' && params.card.back != '') {
                      _folderViweModel
                          .addCard(params.card.front, params.card.back,
                              params.card.frontLang, params.card.backLang)
                          .then((value) => Fluttertoast.showToast(
                              msg: L10n.of(context)!.saved));
                    }
                    await Future.delayed(const Duration(milliseconds: 500));
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
