import 'package:flash_card/globals.dart';
import 'package:flash_card/models/card_model.dart';
import 'package:flash_card/views/components/stt_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flash_card/models/repositories/preference_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import 'components/select_bottom_sheet.dart';

class InputCardPage extends StatefulWidget {
  const InputCardPage({Key? key, required this.card}) : super(key: key);
  final CardModel card;
  @override
  _InputCardPage createState() => _InputCardPage();
}

class _InputCardPage extends State<InputCardPage> {
  final List<TextEditingController> _textCtl = [
    TextEditingController(text: ''),
    TextEditingController(text: '')
  ];
  final List<String> _langIds = ['', ''];
  late bool _isNew;
  final FocusNode _textNode1 = FocusNode();
  final FocusNode _textNode2 = FocusNode();

  @override
  void initState() {
    super.initState();
    _textCtl[0].text = widget.card.front;
    _textCtl[1].text = widget.card.back;
    _langIds[0] = widget.card.frontLang ?? '';
    _langIds[1] = widget.card.backLang ?? '';
    if (_langIds[0].isEmpty || _langIds[1].isEmpty) {
      initPreference();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initPreference() async {
    PreferenceRepository.get().then((value) {
      setState(() {
        _langIds[0] = value.frontSideLang ?? '';
        _langIds[1] = value.backSideLang ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _isNew = widget.card.id == '' ? true : false;

    // キーボードに done, 上下 アクション追加
    KeyboardActionsConfig _keyboardActionConfig = KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Theme.of(context).disabledColor,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(focusNode: _textNode1),
        KeyboardActionsItem(focusNode: _textNode2),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context)!.createCardPageTitle),
        backgroundColor: Globals.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => Navigator.pop<bool>(context, false),
        ),
        actions: const [],
      ),
      body: KeyboardActions(
          config: _keyboardActionConfig,
          child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            _buildTextField(0, L10n.of(context)!.cardFront,
                L10n.of(context)!.createCardFrontHint),
            _buildTextField(1, L10n.of(context)!.cardBack,
                L10n.of(context)!.createCardBackHint),
            Container(
                padding: const EdgeInsets.only(top: 30),
                child: _buildButtons()),
          ]))),
    );
  }

  Row _buildButtons() {
    Widget nextButton = Expanded(
        flex: 3,
        child: Container(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      widget.card.front = _textCtl[0].text;
                      widget.card.back = _textCtl[1].text;
                      Navigator.pop<bool>(context, true);
                    },
                    child: Text(
                      L10n.of(context)!.next,
                      style: Globals.buttonTextStyle,
                    ),
                    style: Globals.buttonStyle,
                  ),
                  Container()
                ])));
    Widget cancelAndSavebuttons = Expanded(
        flex: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                width: 100,
                padding: const EdgeInsets.only(right: 5),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop<bool>(context, false),
                  child: Text(L10n.of(context)!.cancel,
                      style: Globals.buttonTextStyle),
                  style: Globals.buttonStyle,
                )),
            Container(
                width: 100,
                padding: const EdgeInsets.only(right: 5),
                child: ElevatedButton(
                  style: Globals.buttonStyle,
                  onPressed: () {
                    widget.card.front = _textCtl[0].text;
                    widget.card.back = _textCtl[1].text;
                    widget.card.frontLang = _langIds[0];
                    widget.card.backLang = _langIds[1];
                    Navigator.pop<bool>(context, false);
                  },
                  child: Text(
                    L10n.of(context)!.save,
                    style: Globals.buttonTextStyle,
                  ),
                ))
          ],
        ));
    List<Widget> buttons = [];
    if (_isNew) buttons.add(nextButton);
    buttons.add(cancelAndSavebuttons);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: buttons,
    );
  }

  Container _buildMicIcon(int index) {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: IconButton(
          onPressed: () async {
            int p = _textCtl[index].selection.start;
            String txt = await showSttDialog(
                context: context, localeId: _langIds[index]);
            setState(() {
              if (p >= 0) {
                _textCtl[index].text = _textCtl[index].text.substring(0, p) +
                    txt +
                    _textCtl[index].text.substring(p);
              } else {
                _textCtl[index].text += txt;
              }
            });
          },
          iconSize: 32,
          icon: const Icon(Icons.mic_rounded),
          color: Colors.blue,
        ));
  }

  Column _buildTextField(int index, String title, String hintText) {
    return Column(
      children: <Widget>[
        Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  title,
                  style: Globals.titleTextStyle,
                ),
                TextButton(
                  onPressed: () async {
                    String? key = await showSelectBottomSheet(
                        context: context, items: Globals().langItems);
                    if (key != null) {
                      setState(() {
                        _langIds[index] = key;
                      });
                    }
                  },
                  child: Text(
                    Globals().langItems[_langIds[index]] ?? '',
                  ),
                ),
              ],
            )),
        Container(
            margin: const EdgeInsets.fromLTRB(5, 0, 5, 20),
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            height: 180,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Expanded(
                  child: TextField(
                focusNode: index == 0 ? _textNode1 : _textNode2,
                controller: _textCtl[index],
                style: Globals.contentTextStyle,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  border: InputBorder.none,
                  hintText: hintText,
                ),
                maxLines: 100,
                autofocus: false,
                keyboardType: TextInputType.multiline,
              )),
              Container(
                  width: 35,
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.fromLTRB(0, 0, 5, 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildMicIcon(index),
                      ]))
            ]))
      ],
    );
  }
}
