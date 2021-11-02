import 'package:flutter/material.dart';

class InputTitleDialog extends StatefulWidget {
  const InputTitleDialog({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _InputTitleDialog createState() => _InputTitleDialog();
}

class _InputTitleDialog extends State<InputTitleDialog> {
  final TextEditingController _textFieldController =
      TextEditingController(text: "初期値");

  @override
  Widget build(BuildContext context) {
    _textFieldController.text = widget.title ?? "";
    return AlertDialog(
        title: const Text("This is the title"),
        content: TextField(
          controller: _textFieldController,
          decoration: const InputDecoration(hintText: 'input folder name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop<String>(context, ""),
          ),
          TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop<String>(context, _textFieldController.text);
              }),
        ]);
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }
}

Future showInputTitleDialog(
    {required BuildContext context,
    TransitionBuilder? builder,
    String title = ""}) {
  Widget dialog = InputTitleDialog(title: title);
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
  );
}
