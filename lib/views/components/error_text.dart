import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorText extends StatelessWidget {
  const ErrorText({Key? key, required this.code, required this.message})
      : super(key: key);

  final String code;
  final String message;

  @override
  Widget build(BuildContext context) {
    String result = "";
    switch (code) {
      case 'invalid-email':
        result = L10n.of(context)!.invalidEmail;
        break;
      case 'wrong-password':
        result = L10n.of(context)!.wrongPassword;
        break;
      case 'user-not-found':
        result = L10n.of(context)!.userNotFound;
        break;
      case 'user-disabled':
        result = L10n.of(context)!.userDisabled;
        break;
      case 'too-many-requests':
        result = L10n.of(context)!.tooManyRequests;
        break;
      case 'operation-not-allowed':
        result = L10n.of(context)!.operationNotAllowed;
        break;
      case 'email-already-in-use':
        result = L10n.of(context)!.emailAlreadyInUse;
        break;
      case 'weak-password':
        result = L10n.of(context)!.weakPassword;
        break;
      case 'missing-email':
        result = L10n.of(context)!.missingEmail;
        break;
      case 'password-not-match':
        result = L10n.of(context)!.passwordNotMatch;
        break;
    }
    if (result.isEmpty) result = message;

    return Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Text(
          result,
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ));
  }
}
