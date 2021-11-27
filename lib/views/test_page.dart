import 'package:flash_card/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flash_card/views/components/input_title_dialog.dart';
import 'package:flash_card/views/components/file_list_view.dart';
import 'package:flash_card/viewmodels/test_viewmodel.dart';

class TestPage extends StatelessWidget {
  const TestPage({Key? key, required this.book}) : super(key: key);
  final BookModel book;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TestViewModel(book),
      child: Scaffold(body: _TestPage(pageTitle: book.title)),
    );
  }
}

class _TestPage extends StatelessWidget {
  const _TestPage({Key? key, required this.pageTitle}) : super(key: key);
  final String pageTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => {Navigator.of(context).pop()},
        ),
        actions: const [],
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Question'),
                Text('11/50'),
              ],
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            height: 250,
            child: const SingleChildScrollView(
              child: Text('texttexttexttexttexttexttexttexttexttexttexttext'),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 80,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Wrong'),
                    onPressed: () {},
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Correct'),
                    onPressed: () {},
                  ),
                ]),
          ),
          ExpansionTile(
            onExpansionChanged: (bool changed) {},
            title: const Text('Answer'),
            children: [
              Container(
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                height: 100,
                child: const SingleChildScrollView(
                  child:
                      Text('texttexttexttexttexttexttexttexttexttexttexttext'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
