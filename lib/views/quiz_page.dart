import 'package:flash_card/models/folder_model.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flash_card/viewmodels/quiz_viewmodel.dart';
import 'package:flash_card/views/components/stt_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flash_card/globals.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:flash_card/views/components/correct_popup_dialog.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flash_card/utilities/tts.dart';

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
  final FlipCardController _controller = FlipCardController();
  final _tts = Tts();
  final double _cardHeight = 180;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    QuizViewModel _quizViweModel = Provider.of<QuizViewModel>(context);
    _textCtr.clear();
    _tts.initTts();

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
                        Row(
                          children: [
                            Text(
                              L10n.of(context)!.question,
                              style: Globals.titleTextStyle,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
/*                             Text(
                              '${_quizViweModel.index + 1}/${_quizViweModel.items.length}',
                              style: Globals.titleTextStyle,
                            ), */
                          ],
                        ),
                        Text(
                          '${_quizViweModel.index + 1}/${_quizViweModel.items.length}',
                          style: Globals.subtitleTextStyle,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: _cardHeight,
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: _quizViweModel.items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _buildFlipCard(
                              _quizViweModel.getQuestionByIndex(index),
                              _quizViweModel.getQuestionLangByIndex(index),
                              _quizViweModel.getAnswerByIndex(index),
                              _quizViweModel.getAnswerLangByIndex(index),
                              _quizViweModel.index);
                        },
                      )),
                  _buildAnswerArea(context, _quizViweModel, param.quizMode),
                ],
              ),
            )));
  }

  Widget _buildFlipCard(String front, String frontLocale, String back,
      String backLocal, int index) {
    return SizedBox(
        width: Globals().screenSizeWidth,
        child: Card(
          key: Key('$index'),
          shadowColor: Colors.transparent,
          child: FlipCard(
            controller: _controller,
            direction: FlipDirection.VERTICAL,
            speed: 300,
            onFlipDone: (status) {
              // print(status);
            },
            front: _buildFlipCardContent(
              front,
              frontLocale,
            ),
            back: _buildFlipCardContent(
                back, backLocal, Globals().cardBackSideColor),
          ),
        ));
  }

  Container _buildFlipCardContent(String text, String locale, [Color? color]) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 5, 0, 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.5),
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: color,
      ),
      height: _cardHeight,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
              child: Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  height: 168,
                  child: SingleChildScrollView(
                      child: Text(text,
                          style: Globals().cardTextStye,
                          overflow: TextOverflow.clip)))),
          Container(
              width: 35,
              alignment: Alignment.topLeft,
              margin: EdgeInsets.zero,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                IconButton(
                    iconSize: 32,
                    onPressed: () async {
                      await _tts.setLanguage(locale);
                      await _tts.speak(text);
                    },
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    color: Globals.buttonColor1, // Globals.iconColor2,
                    icon: const Icon(Icons.volume_up_rounded)),
              ]))
        ],
      ),
    );
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
        padding: const EdgeInsets.fromLTRB(15, 30, 15, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              L10n.of(context)!.quizModeDictation,
              style: Globals.titleTextStyle,
            ),
            Text(
              viewmodel.answerLocaleName
                  // ignore: unnecessary_string_escapes
                  .replaceFirst(RegExp('\\(.*\\)'), ''),
              style: Globals.subtitleTextStyle,
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          // borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        height: _cardHeight,
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
                    width: 35,
                    alignment: Alignment.topLeft,
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
                          IconButton(
                            iconSize: 32,
                            padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            onPressed: () async {
                              int p = _textCtr.selection.start;
                              String txt = await showSttDialog(
                                  context: context,
                                  localeId: viewmodel.answerLang);
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
                          ),
                        ])))
          ],
        ),
      ),
      Container(
        alignment: Alignment.center,
        height: 100,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Globals.incorrectColor,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Globals().incorrectButtonIcon,
                Text(
                  L10n.of(context)!.skip,
                  style: Globals.buttonTextStyle,
                )
              ],
            ),
            onPressed: () {
              viewmodel.wrongAnswer();
              if (!viewmodel.next()) {
                Navigator.of(context)
                    .pushNamed('/quizResultPage', arguments: viewmodel.quiz.id);
              } else {
                _scrollToIndex(viewmodel.index);
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
      // Fluttertoast.showToast(msg: L10n.of(context)!.correct);
      viewmodel.correctAnswer();
      if (!viewmodel.next()) {
        Navigator.of(context)
            .pushNamed('/quizResultPage', arguments: viewmodel.quiz.id);
      } else {
        CorrectPopupDialog().popup(context);
        _scrollToIndex(viewmodel.index);
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
                primary: Globals.incorrectColor,
                onPrimary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Globals().incorrectButtonIcon,
                Text(
                  L10n.of(context)!.incorrect,
                  style: Globals.buttonTextStyle,
                )
              ]),
              onPressed: () {
                viewmodel.wrongAnswer();
                if (!viewmodel.next()) {
                  Navigator.of(context).pushNamed('/quizResultPage',
                      arguments: viewmodel.quiz.id);
                } else {
                  _scrollToIndex(viewmodel.index);
                }
              },
            )),
        SizedBox(
            width: 130,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Globals.correctColor,
                onPrimary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Globals().correctButtonIcon,
                Text(
                  L10n.of(context)!.correct,
                  style: Globals.buttonTextStyle,
                )
              ]),
              onPressed: () {
                viewmodel.correctAnswer();
                if (!viewmodel.next()) {
                  Navigator.of(context).pushNamed('/quizResultPage',
                      arguments: viewmodel.quiz.id);
                } else {
                  _scrollToIndex(viewmodel.index);
                }
              },
            ))
      ]),
    );
  }

  void _scrollToIndex(int index) {
    _scrollController.animateTo(Globals().screenSizeWidth * index,
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
  }
}
