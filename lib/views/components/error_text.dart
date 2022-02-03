import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  const ErrorText({Key? key, required this.code, required this.message})
      : super(key: key);

  final String code;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Text(
          getErrorMessage(code) ?? message,
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ));
  }

  String? getErrorMessage(String code) {
    String? result;
    switch (code) {
      case 'invalid-email':
        result = 'メールアドレスが間違っています。';
        break;
      case 'wrong-password':
        result = 'パスワードが間違っています。';
        break;
      case 'user-not-found':
        result = 'このアカウントは存在しません。';
        break;
      case 'user-disabled':
        result = 'このメールアドレスは無効になっています。';
        break;
      case 'too-many-requests':
        result = '回線が混雑しています。もう一度試してみてください。';
        break;
      case 'operation-not-allowed':
        result = 'メールアドレスとパスワードでのログインは有効になっていません。';
        break;
      case 'email-already-in-use':
        result = 'このメールアドレスはすでに登録されています。';
        break;
      default:
        break;
    }
    return result;
  }
}
