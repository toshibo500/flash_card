import 'package:flash_card/models/book_model.dart';
import 'package:flash_card/models/card_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flash_card/viewmodels/book_viewmodel.dart';
import 'package:flash_card/views/components/file_list_view.dart';

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
    return Scaffold(
        appBar: AppBar(
          title: Text(pageTitle),
          backgroundColor: Colors.green,
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
                CardModel card = CardModel('', book.id, '', '', 0);
                await Navigator.of(context)
                    .pushNamed('/inputCardPage', arguments: card) as CardModel;
                if (card.front != '') {
                  _bookViweModel.add(card.front, card.back);
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
            Container(
              height: 80,
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
              color: Theme.of(context).backgroundColor,
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Start TEST'),
                  onPressed: () async {
                    await Navigator.of(context).pushNamed('/TestPage',
                        arguments: _bookViweModel.selectedBook);
                  },
                ),
              ),
            )
          ],
        ));
  }
}
