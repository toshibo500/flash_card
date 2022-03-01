import 'package:flutter/material.dart';
import 'package:flash_card/utilities/error_message.dart';

class ErrorText extends StatelessWidget {
  const ErrorText({Key? key, required this.code, required this.message})
      : super(key: key);

  final String code;
  final String message;

  @override
  Widget build(BuildContext context) {
    String msg = getErrorMessage(context, code);
    if (msg.isEmpty) msg = message;
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Text(
          msg,
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ));
  }
}
