import 'package:flash_card/globals.dart';
import 'package:flash_card/models/card_model.dart';
import 'package:flash_card/views/components/stt_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flash_card/models/repositories/preference_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  final List<String> _langNames = ['', ''];
  late bool _isNew;

  @override
  void initState() {
    super.initState();
    _textCtl[0].text = widget.card.front;
    _textCtl[1].text = widget.card.back;
    initPreference();
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
        _langNames[0] = value.frontSideLangName ?? '';
        _langNames[1] = value.backSideLangName ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _isNew = widget.card.id == '' ? true : false;
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
      body: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        _buildTextField(
            _textCtl[0],
            L10n.of(context)!.cardFront,
            // ignore: unnecessary_string_escapes
            _langNames[0].replaceFirst(RegExp('\\(.*\\)'), ''),
            L10n.of(context)!.createCardFrontHint),
//            'Input word or phrase for front side of the card'),
        Container(alignment: Alignment.centerRight, child: _buildMicIcon(0)),
        _buildTextField(
            _textCtl[1],
            L10n.of(context)!.cardBack,
            // ignore: unnecessary_string_escapes
            _langNames[1].replaceFirst(RegExp('\\(.*\\)'), ''),
            L10n.of(context)!.createCardBackHint),
//            'Input word or phrase for back side of the card'),
        Container(alignment: Alignment.centerRight, child: _buildMicIcon(1)),
        Container(
            padding: const EdgeInsets.only(top: 20), child: _buildButtons()),
      ])),
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
                padding: const EdgeInsets.only(right: 5),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop<bool>(context, false),
                  child: Text(L10n.of(context)!.cancel,
                      style: Globals.buttonTextStyle),
                  style: Globals.buttonStyle,
                )),
            Container(
                width: 110,
                padding: const EdgeInsets.only(right: 5),
                child: ElevatedButton(
                  style: Globals.buttonStyle,
                  onPressed: () {
                    widget.card.front = _textCtl[0].text;
                    widget.card.back = _textCtl[1].text;
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
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: IconButton(
          onPressed: () async {
            String txt = await showSttDialog(
                context: context, localeId: _langIds[index]);
            setState(() {
              _textCtl[index].text += txt;
            });
          },
          icon: const Icon(Icons.mic_rounded),
          color: Colors.blue,
        ));
  }

  Column _buildTextField(TextEditingController txtClt, String title,
      String lang, String hintText) {
    return Column(
      children: <Widget>[
        Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Globals.titleTextStyle,
                ),
                Text(
                  lang,
                  style: Globals.subtitleTextStyle,
                ),
              ],
            )),
        SizedBox(
            child: TextField(
          controller: txtClt,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(8),
            hintText: hintText,
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
          ),
          autofocus: true,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          minLines: 4,
        ))
      ],
    );
  }
}
