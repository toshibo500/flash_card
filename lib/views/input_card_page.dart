import 'package:flash_card/models/card_model.dart';
import 'package:flash_card/views/components/stt_dialog.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _textCtl[0].text = widget.card.front;
    _textCtl[1].text = widget.card.back;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        _buildTextField(_textCtl[0], 'Front:',
            'Input word or phrase for front side of the card'),
        Container(alignment: Alignment.centerRight, child: _buildMicIcon(0)),
        _buildTextField(_textCtl[1], 'Back:',
            'Input word or phrase for back side of the card'),
        Container(alignment: Alignment.centerRight, child: _buildMicIcon(1)),
        Container(
            padding: const EdgeInsets.only(top: 20), child: _buildButtons()),
      ])),
    );
  }

  Row _buildButtons() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
        padding: const EdgeInsets.only(left: 15),
        child: ElevatedButton(
          onPressed: () {},
          child: const Text(' Next '),
        ),
      ),
      Row(
        children: [
          Container(
              padding: const EdgeInsets.only(right: 5),
              child: ElevatedButton(
                onPressed: () => Navigator.pop<CardModel>(context, widget.card),
                child: const Text('Cancel'),
              )),
          Container(
              padding: const EdgeInsets.only(right: 15),
              child: ElevatedButton(
                onPressed: () {
                  widget.card.front = _textCtl[0].text;
                  widget.card.back = _textCtl[1].text;
                  Navigator.pop<CardModel>(context, widget.card);
                },
                child: const Text('  Save  '),
              ))
        ],
      )
    ]);
  }

  Container _buildMicIcon(int index) {
    return Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: IconButton(
          onPressed: () async {
            String txt = await showSttDialog(context: context);
            // ignore: avoid_print
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
            child: Text(title)),
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
