import 'package:flash_card/models/folder_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flash_card/viewmodels/quiz_viewmodel.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'dart:math' as math;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flash_card/views/components/stt_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flash_card/globals.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class QuizPageParameters {
  QuizPageParameters(
      {required this.folder, required this.quizNum, required this.quizMode});
  FolderModel folder;
  int quizNum;
  int quizMode;
}

class QuizPage extends StatelessWidget {
  const QuizPage({Key? key, required this.param}) : super(key: key);
  final QuizPageParameters param;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QuizViewModel(param.folder, param.quizNum),
      child: Scaffold(body: _QuizPage(param: param)),
    );
  }
}

class _QuizPage extends StatelessWidget {
  _QuizPage({Key? key, required this.param}) : super(key: key);
  final QuizPageParameters param;
  final TextEditingController _textCtr = TextEditingController(text: "");
  final FocusNode _textNode1 = FocusNode();

  @override
  Widget build(BuildContext context) {
    bool _answerExpanded = false;
    QuizViewModel _quizViweModel = Provider.of<QuizViewModel>(context);
    _textCtr.clear();

    // キーボードに done アクション追加
    KeyboardActionsConfig _keyboardActionConfig = KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Theme.of(context).disabledColor,
      nextFocus: false,
      actions: [
        KeyboardActionsItem(focusNode: _textNode1),
      ],
    );

    return Scaffold(
        appBar: AppBar(
          title: Text(param.folder.title),
          backgroundColor: Globals.backgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () => {Navigator.of(context).pop()},
          ),
          actions: const [],
        ),
        body: KeyboardActions(
            config: _keyboardActionConfig,
            child: SingleChildScrollView(
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
                          style: Globals.titleTextStyle,
                        ),
                        Text(
                          '${_quizViweModel.index + 1}/${_quizViweModel.items.length}',
                          style: Globals.titleTextStyle,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                    ),
                    padding: const EdgeInsets.all(10),
                    height: 180,
                    child: SingleChildScrollView(
                      child: Text(
                        _quizViweModel.question,
                        style: Globals.contentTextStyle,
                      ),
                    ),
                  ),
                  _buildAnswerArea(context, _quizViweModel, param.quizMode),
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
                                    style: Globals.titleTextStyle,
                                  )),
                                  Transform.rotate(
                                    angle: math.pi * animationValue / 2,
                                    child:
                                        const Icon(Icons.arrow_right, size: 40),
                                    alignment: Alignment.center,
                                  )
                                ],
                              ),
                            ));
                      },
                      content: Container(
                        width: double.infinity,
                        color: Theme.of(context).backgroundColor,
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          _quizViweModel.answer,
                          style: Globals.contentTextStyle,
                        ),
                      )),
                ],
              ),
            )));
  }

  Widget _buildAnswerArea(
      BuildContext context, QuizViewModel viewmodel, int quizMode) {
    return quizMode == Globals.quizModeSelfMode
        ? _buildSelfMode(context, viewmodel)
        : _buildDictaion(context, viewmodel);
  }

  Column _buildDictaion(BuildContext context, QuizViewModel viewmodel) {
    return Column(children: [
      Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              L10n.of(context)!.quizModeDictation,
              style: Globals.titleTextStyle,
            ),
          ],
        ),
      ),
      Container(
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        height: 180,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: TextField(
                focusNode: _textNode1,
                style: Globals.contentTextStyle,
                decoration: InputDecoration(
                  hintText: L10n.of(context)!.answerHintText,
                ),
                maxLines: 100,
                controller: _textCtr,
                autofocus: false,
                onChanged: (text) {
                  mark(context, viewmodel, text);
                },
              ),
            )),
            Visibility(
                visible: true,
                child: Container(
                    width: 25,
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.zero,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              color: Theme.of(context).disabledColor,
                              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                              onPressed: () {
                                _textCtr.text = '';
                              },
                              icon: const Icon(Icons.close_rounded)),
                        ])))
          ],
        ),
      ),
      Container(
          height: 40,
          alignment: Alignment.centerRight,
          child: IconButton(
            iconSize: 32,
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
              primary: Globals.buttonColor2,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              L10n.of(context)!.skip,
              style: Globals.buttonTextStyle,
            ),
            onPressed: () {
              viewmodel.wrongAnswer();
              if (!viewmodel.next()) {
                Navigator.of(context)
                    .pushNamed('/quizResultPage', arguments: viewmodel.quiz.id);
              }
            },
          )
        ]),
      )
    ]);
  }

  void mark(BuildContext context, QuizViewModel viewmodel, String text) {
    text = text.toLowerCase().trim();
    if (text.compareTo(viewmodel.answer.toLowerCase().trim()) == 0) {
      Fluttertoast.showToast(msg: L10n.of(context)!.correct);
      viewmodel.correctAnswer();
      if (!viewmodel.next()) {
        Navigator.of(context)
            .pushNamed('/quizResultPage', arguments: viewmodel.quiz.id);
      }
    }
  }

  Container _buildSelfMode(BuildContext context, QuizViewModel viewmodel) {
    return Container(
      alignment: Alignment.center,
      height: 80,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        SizedBox(
            width: 130,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Globals.buttonColor2,
                onPrimary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                L10n.of(context)!.incorrect,
                style: Globals.buttonTextStyle,
              ),
              onPressed: () {
                viewmodel.wrongAnswer();
                if (!viewmodel.next()) {
                  Navigator.of(context).pushNamed('/quizResultPage',
                      arguments: viewmodel.quiz.id);
                }
              },
            )),
        SizedBox(
            width: 130,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Globals.buttonColor1,
                onPrimary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                L10n.of(context)!.correct,
                style: Globals.buttonTextStyle,
              ),
              onPressed: () {
                viewmodel.correctAnswer();
                if (!viewmodel.next()) {
                  Navigator.of(context).pushNamed('/quizResultPage',
                      arguments: viewmodel.quiz.id);
                }
              },
            ))
      ]),
    );
  }
}
