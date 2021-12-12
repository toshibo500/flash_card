import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InputTitleDialog extends StatefulWidget {
  const InputTitleDialog(
      {Key? key, required this.dialogTitle, String this.title = ''})
      : super(key: key);
  final String dialogTitle;
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
        title: Text(widget.dialogTitle),
        content: TextField(
          controller: _textFieldController,
//          decoration: const InputDecoration(hintText: 'input folder name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            child: Text(L10n.of(context)!.cancel),
            onPressed: () => Navigator.pop<String>(context, ""),
          ),
          TextButton(
              child: Text(L10n.of(context)!.ok),
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
    required String dialogTitle,
    String title = ""}) {
  Widget dialog = InputTitleDialog(dialogTitle: dialogTitle, title: title);
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
  );
}
