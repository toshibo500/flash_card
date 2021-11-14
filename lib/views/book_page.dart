import 'package:flash_card/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flash_card/views/components/input_title_dialog.dart';
import 'package:flash_card/viewmodels/book_viewmodel.dart';

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
              String title = await showInputTitleDialog(context: context);
              if (title != "") {}
            },
          ),
        ],
      ),
      body: Consumer<BookViewModel>(builder: (context, viewModel, _) {
        return const Text("test", style: TextStyle(fontSize: 80));
      }),
    );
  }
}
