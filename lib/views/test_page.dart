import 'package:flash_card/models/book_model.dart';
import 'package:flash_card/models/preference_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flash_card/viewmodels/test_viewmodel.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'dart:math' as math;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flash_card/views/components/stt_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    fontSize: 18.0,
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
                    Text(
                      L10n.of(context)!.question,
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
                    _testViweModel.question,
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
                              Expanded(
                                  child: Text(
                                L10n.of(context)!.answer,
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
                      _testViweModel.answer,
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
            autofocus: true,
            onChanged: (text) {
              mark(context, viewmodel, text);
            },
          ),
        ),
      ),
      Container(
          height: 40,
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () async {
              int p = _textCtr.selection.start;
              String txt = await showSttDialog(
                  context: context, localeId: viewmodel.localeId);
              if (p >= 0) {
                _textCtr.text = _textCtr.text.substring(0, p) +
                    txt +
                    _textCtr.text.substring(p);
              } else {
                _textCtr.text += txt;
              }
              mark(context, viewmodel, _textCtr.text);
            },
            icon: const Icon(Icons.mic_rounded),
            color: Colors.blue,
          )),
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
            child: Text(
              L10n.of(context)!.skip,
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

  void mark(BuildContext context, TestViewModel viewmodel, String text) {
    if (text.compareTo(viewmodel.answer.trim()) == 0) {
      Fluttertoast.showToast(msg: L10n.of(context)!.correct);
      viewmodel.correctAnswer();
      if (!viewmodel.next()) {
        Navigator.of(context)
            .pushNamed('/testResultPage', arguments: viewmodel.test.id);
      }
    }
  }

  Container _buildSelfMode(BuildContext context, TestViewModel viewmodel) {
    return Container(
      alignment: Alignment.center,
      height: 80,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        SizedBox(
            width: 130,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                L10n.of(context)!.incorrect,
                style: buttonTextStyle,
              ),
              onPressed: () {
                viewmodel.wrongAnswer();
                if (!viewmodel.next()) {
                  Navigator.of(context).pushNamed('/testResultPage',
                      arguments: viewmodel.test.id);
                }
              },
            )),
        SizedBox(
            width: 130,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.lightBlue,
                onPrimary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                L10n.of(context)!.correct,
                style: buttonTextStyle,
              ),
              onPressed: () {
                viewmodel.correctAnswer();
                if (!viewmodel.next()) {
                  Navigator.of(context).pushNamed('/testResultPage',
                      arguments: viewmodel.test.id);
                }
              },
            ))
      ]),
    );
  }
}
