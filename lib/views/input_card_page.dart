import 'package:flash_card/models/card_model.dart';
import 'package:flash_card/views/components/stt_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flash_card/models/repositories/preference_repository.dart';

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
      if (value != null) {
        _langIds[0] = value.frontSideLang!;
        _langIds[1] = value.backSideLang!;
      }
    });
  }

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
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
    letterSpacing: 1,
    fontSize: 14.0,
  );

  static ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      primary: Colors.lightBlue,
      onPrimary: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ));

  @override
  Widget build(BuildContext context) {
    _isNew = widget.card.id == '' ? true : false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a frip card'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => Navigator.pop<CardModel>(context, widget.card),
        ),
        actions: const [],
      ),
      body: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        _buildTextField(_textCtl[0], 'Front',
            'Input word or phrase for front side of the card'),
        Container(alignment: Alignment.centerRight, child: _buildMicIcon(0)),
        _buildTextField(_textCtl[1], 'Back',
            'Input word or phrase for back side of the card'),
        Container(alignment: Alignment.centerRight, child: _buildMicIcon(1)),
        Container(
            padding: const EdgeInsets.only(top: 20), child: _buildButtons()),
      ])),
    );
  }

  Row _buildButtons() {
    Widget nextButton = Expanded(
        flex: 2,
        child: Container(
            padding: const EdgeInsets.only(left: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      widget.card.front = _textCtl[0].text;
                      widget.card.back = _textCtl[1].text;
                      Navigator.pop<bool>(context, true);
                    },
                    child: const Text(
                      ' Next ',
                      style: buttonTextStyle,
                    ),
                    style: buttonStyle,
                  ),
                  Container()
                ])));
    Widget cancelAndSavebuttons = Expanded(
        flex: 3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                padding: const EdgeInsets.only(right: 5),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop<bool>(context, false),
                  child: const Text('Cancel', style: buttonTextStyle),
                  style: buttonStyle,
                )),
            Container(
                padding: const EdgeInsets.only(right: 5),
                child: ElevatedButton(
                  style: buttonStyle,
                  onPressed: () {
                    widget.card.front = _textCtl[0].text;
                    widget.card.back = _textCtl[1].text;
                    Navigator.pop<bool>(context, false);
                  },
                  child: const Text(
                    ' Save ',
                    style: buttonTextStyle,
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

  Column _buildTextField(
      TextEditingController txtClt, String title, String hintText) {
    return Column(
      children: <Widget>[
        Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: Text(
              title,
              style: titleTextStyle,
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
