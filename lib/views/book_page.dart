import 'package:flash_card/globals.dart';
import 'package:flash_card/models/book_model.dart';
import 'package:flash_card/models/card_model.dart';
import 'package:flash_card/views/quiz_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flash_card/viewmodels/book_viewmodel.dart';
import 'package:flash_card/views/components/file_list_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookPage extends StatelessWidget {
  const BookPage({Key? key, required this.book}) : super(key: key);
  final BookModel book;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookViewModel(book),
      child: Scaffold(body: _BookPage(pageTitle: book.title)),
    );
  }
}

class _BookPage extends StatelessWidget {
  const _BookPage({Key? key, required this.pageTitle}) : super(key: key);
  final String pageTitle;

  @override
  Widget build(BuildContext context) {
    var _bookViweModel = Provider.of<BookViewModel>(context);

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
                _bookViweModel.getPreference();
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
                        book: _bookViweModel.selectedBook,
                        numberOfQuestions: _bookViweModel.preference.numOfQuiz!,
                        quizMode: _bookViweModel.preference.quizMode!));
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
                      arguments: _bookViweModel.selectedBook.id);
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () => {Navigator.of(context).pop()},
          ),
          actions: [
            IconButton(
                icon: Icon(
                    _bookViweModel.editMode ? Icons.done : Icons.edit_rounded),
                onPressed: () {
                  _bookViweModel.editMode = !_bookViweModel.editMode;
                }),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                // List<String> values = await showInputCardDialog(context: context);
                BookModel book = _bookViweModel.selectedBook;
                bool next = true;
                while (next) {
                  CardModel card = CardModel('', book.id, '', '', 0);
                  next = await Navigator.of(context)
                      .pushNamed('/inputCardPage', arguments: card) as bool;
                  if (card.front != '') {
                    _bookViweModel.add(card.front, card.back);
                  }
                }
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(child:
                Consumer<BookViewModel>(builder: (context, viewModel, _) {
              return FileListView(viewModel: viewModel, nextPage: "");
            })),
          ],
        ),
        floatingActionButton: Visibility(
          visible: _bookViweModel.items.isNotEmpty,
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
