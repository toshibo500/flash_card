import 'package:flash_card/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flash_card/viewmodels/test_viewmodel.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'dart:math' as math;

class TestPageParameters {
  TestPageParameters(
      {required this.book,
      required this.numberOfQuestions,
      required this.isDictationMode});
  BookModel book;
  int numberOfQuestions;
  bool isDictationMode;
}

class TestPage extends StatelessWidget {
  const TestPage({Key? key, required this.param}) : super(key: key);
  final TestPageParameters param;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TestViewModel(param.book, param.numberOfQuestions),
      child: Scaffold(body: _TestPage(param: param)),
    );
  }
}

class _TestPage extends StatelessWidget {
  const _TestPage({Key? key, required this.param}) : super(key: key);
  final TestPageParameters param;
  @override
  Widget build(BuildContext context) {
    bool _answerExpanded = false;
    var _testViweModel = Provider.of<TestViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(param.book.title),
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
              children: [
                const Text('Question'),
                Text(
                    '${_testViweModel.index + 1}/${_testViweModel.items.length}'),
              ],
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            height: 200,
            child: SingleChildScrollView(
              child: Text(_testViweModel.item.front),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Dictation'),
              ],
            ),
          ),
          _buildDictaion(),
          _buildButtons(context, _testViweModel, param.isDictationMode),
          ExpansionWidget(
              initiallyExpanded: false,
              onSaveState: (value) => _answerExpanded = value,
              onRestoreState: () => _answerExpanded,
              duration: const Duration(microseconds: 0),
              titleBuilder:
                  (double animationValue, _, bool isExpaned, toogleFunction) {
                return InkWell(
                    onTap: () => toogleFunction(animated: true),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(child: Text('Answer')),
                          Transform.rotate(
                            angle: math.pi * animationValue / 2,
                            child: const Icon(Icons.arrow_right, size: 40),
                            alignment: Alignment.center,
                          )
                        ],
                      ),
                    ));
              },
              content: Container(
                width: double.infinity,
                color: Colors.grey.shade100,
                padding: const EdgeInsets.all(20),
                child: Text(_testViweModel.item.back),
              )),
        ],
      ),
    );
  }

  Container _buildDictaion() {
    return Container(
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      height: 200,
      child: const SingleChildScrollView(
        child: Expanded(
            child: TextField(
          maxLines: 100,
        )),
      ),
    );
  }

  Container _buildButtons(
      BuildContext context, TestViewModel viewmodel, bool isDictationMode) {
    List<ElevatedButton> selfMode = [];
    selfMode.add(ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.red,
        shape: const StadiumBorder(),
      ),
      child: const Text('Wrong'),
      onPressed: () {
        viewmodel.wrongAnswer();
        if (!viewmodel.next()) {
          Navigator.of(context)
              .pushNamed('/testResultPage', arguments: viewmodel.test.id);
        }
      },
    ));
    selfMode.add(ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
      ),
      child: const Text('Correct'),
      onPressed: () {
        viewmodel.correctAnswer();
        if (!viewmodel.next()) {
          Navigator.of(context)
              .pushNamed('/testResultPage', arguments: viewmodel.test.id);
        }
      },
    ));
    List<ElevatedButton> dictationMode = [];
    dictationMode.add(ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
      ),
      child: const Text('Next'),
      onPressed: () {
        viewmodel.correctAnswer();
        if (!viewmodel.next()) {
          Navigator.of(context)
              .pushNamed('/testResultPage', arguments: viewmodel.test.id);
        }
      },
    ));

    return Container(
      alignment: Alignment.center,
      height: 80,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: isDictationMode ? dictationMode : selfMode),
    );
  }
}
