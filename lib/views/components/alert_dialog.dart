import 'package:flutter/material.dart';

void showAlertDialog(
    {required BuildContext context,
    required String text,
    String buttonText = 'OK',
    String popUntil = ''}) async {
  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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
                  Navigator.of(context).popUntil((_) => count++ >= 2);
                }
              },
            ),
          ],
        );
      });
}
