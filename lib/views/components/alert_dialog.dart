import 'package:flutter/material.dart';

Future<void> showAlertDialog(
    {required BuildContext context,
    required String text,
    Icon? icon,
    String? title,
    String buttonText = 'OK',
    String popUntil = '',
    int popCount = 2}) async {
  List<Widget> list = [];
  if (icon != null) {
    list.add(icon);
    list.add(const SizedBox(
      width: 5,
    ));
  }
  if (title != null) list.add(Text(title));

  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: list.isNotEmpty
              ? Row(
                  children: list,
                )
              : null,
          content: Text(text),
          actions: <Widget>[
            // ボタン領域
            TextButton(
              child: Text(buttonText),
              onPressed: () {
                if (popUntil.isNotEmpty) {
                  Navigator.popUntil(context, ModalRoute.withName(popUntil));
                } else {
                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= popCount);
                }
              },
            ),
          ],
        );
      });
}
