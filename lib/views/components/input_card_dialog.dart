import 'package:flutter/material.dart';

class InputCardDialog extends StatefulWidget {
  const InputCardDialog(
      {Key? key, String this.front = '', String this.back = ''})
      : super(key: key);
  final String? front, back;
  @override
  _InputCardDialog createState() => _InputCardDialog();
}

class _InputCardDialog extends State<InputCardDialog> {
  final TextEditingController _frontCtl = TextEditingController(text: "初期値");
  final TextEditingController _backCtl = TextEditingController(text: "初期値");

  @override
  Widget build(BuildContext context) {
    _frontCtl.text = widget.front ?? "";
    _backCtl.text = widget.back ?? "";
    return AlertDialog(
        title: const Text("Create a card"),
        content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          SizedBox(
              height: 100,
              child: TextField(
                controller: _frontCtl,
                decoration: const InputDecoration(hintText: 'front'),
                autofocus: true,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 3,
              )),
          SizedBox(
              height: 100,
              child: TextField(
                controller: _backCtl,
                decoration: const InputDecoration(hintText: 'back'),
                autofocus: true,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 3,
              ))
        ]),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop<List<String>>(context, []),
          ),
          TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop<List<String>>(
                    context, [_frontCtl.text, _backCtl.text]);
              }),
        ]);
  }

  @override
  void dispose() {
    _frontCtl.dispose();
    super.dispose();
  }
}

Future showInputCardDialog(
    {required BuildContext context,
    TransitionBuilder? builder,
    String front = "",
    String back = ""}) {
  Widget dialog = InputCardDialog(front: front, back: back);
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
  );
}
