import 'package:flash_card/models/book_model.dart';
import 'package:flash_card/models/preference_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flash_card/viewmodels/test_viewmodel.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'dart:math' as math;
import 'package:fluttertoast/fluttertoast.dart';

class TestPageParameters {
  TestPageParameters(
      {required this.book,
      required this.numberOfQuestions,
      required this.testMode});
  BookModel book;
  int numberOfQuestions;
  int testMode;
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
  _TestPage({Key? key, required this.param}) : super(key: key);
  final TestPageParameters param;
  final TextEditingController _textCtr = TextEditingController(text: "");

  static const TextStyle titleTextStyle = TextStyle(
    color: Colors.black54,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
    letterSpacing: 1,
    fontSize: 18.0,
  );
  static const TextStyle contentTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    letterSpacing: 1,
    fontSize: 24.0,
  );
  static const TextStyle buttonTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontFamily: 'Roboto',
    letterSpacing: 1,
    fontSize: 24.0,
  );
  @override
  Widget build(BuildContext context) {
    bool _answerExpanded = false;
    TestViewModel _testViweModel = Provider.of<TestViewModel>(context);
    _textCtr.clear();

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Question',
                      style: titleTextStyle,
                    ),
                    Text(
                      '${_testViweModel.index + 1}/${_testViweModel.items.length}',
                      style: titleTextStyle,
                    ),
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
                  child: Text(
                    _testViweModel.item.front,
                    style: contentTextStyle,
                  ),
                ),
              ),
              _buildAnswerArea(context, _testViweModel, param.testMode),
              ExpansionWidget(
                  initiallyExpanded: false,
                  onSaveState: (value) => _answerExpanded = value,
                  onRestoreState: () => _answerExpanded,
                  duration: const Duration(microseconds: 0),
                  titleBuilder: (double animationValue, _, bool isExpaned,
                      toogleFunction) {
                    return InkWell(
                        onTap: () => toogleFunction(animated: true),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Expanded(
                                  child: Text(
                                'Answer',
                                style: titleTextStyle,
                              )),
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
                    child: Text(
                      _testViweModel.item.back,
                      style: contentTextStyle,
                    ),
                  )),
            ],
          ),
        ));
  }

  Widget _buildAnswerArea(
      BuildContext context, TestViewModel viewmodel, int testMode) {
    return testMode == PreferenceModel.testModeSelfMode
        ? _buildDictaion(context, viewmodel)
        : _buildSelfMode(context, viewmodel);
  }

  Column _buildDictaion(BuildContext context, TestViewModel viewmodel) {
    return Column(children: [
      Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Dictation',
              style: titleTextStyle,
            ),
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
          child: TextField(
            style: contentTextStyle,
            maxLines: 100,
            controller: _textCtr,
            onChanged: (text) {
              if (text.compareTo(viewmodel.item.back) == 0) {
                Fluttertoast.showToast(msg: "Correct!");
                viewmodel.correctAnswer();
                if (!viewmodel.next()) {
                  Navigator.of(context).pushNamed('/testResultPage',
                      arguments: viewmodel.test.id);
                }
              }
            },
          ),
        ),
      ),
      Container(
        alignment: Alignment.center,
        height: 80,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue,
              onPrimary: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Skip',
              style: buttonTextStyle,
            ),
            onPressed: () {
              viewmodel.wrongAnswer();
              if (!viewmodel.next()) {
                Navigator.of(context)
                    .pushNamed('/testResultPage', arguments: viewmodel.test.id);
              }
            },
          )
        ]),
      )
    ]);
  }

  Container _buildSelfMode(BuildContext context, TestViewModel viewmodel) {
    return Container(
      alignment: Alignment.center,
      height: 80,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
            onPrimary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Wrong',
            style: buttonTextStyle,
          ),
          onPressed: () {
            viewmodel.wrongAnswer();
            if (!viewmodel.next()) {
              Navigator.of(context)
                  .pushNamed('/testResultPage', arguments: viewmodel.test.id);
            }
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.lightBlue,
            onPrimary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Correct',
            style: buttonTextStyle,
          ),
          onPressed: () {
            viewmodel.correctAnswer();
            if (!viewmodel.next()) {
              Navigator.of(context)
                  .pushNamed('/testResultPage', arguments: viewmodel.test.id);
            }
          },
        )
      ]),
    );
  }
}
