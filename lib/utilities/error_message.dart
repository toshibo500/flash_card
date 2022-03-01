import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getErrorMessage(BuildContext context, String code,
    [String message = '']) {
  switch (code) {
    case 'invalid-email':
      return L10n.of(context)!.invalidEmail;
    case 'wrong-password':
      return L10n.of(context)!.wrongPassword;
    case 'user-not-found':
      return L10n.of(context)!.userNotFound;
    case 'user-disabled':
      return L10n.of(context)!.userDisabled;
    case 'too-many-requests':
      return L10n.of(context)!.tooManyRequests;
    case 'operation-not-allowed':
      return L10n.of(context)!.operationNotAllowed;
    case 'email-already-in-use':
      return L10n.of(context)!.emailAlreadyInUse;
    case 'weak-password':
      return L10n.of(context)!.weakPassword;
    case 'missing-email':
      return L10n.of(context)!.missingEmail;
    case 'password-not-match':
      return L10n.of(context)!.passwordNotMatch;
    case 'signinCanceled':
      return L10n.of(context)!.signinCanceld;
    default:
      return message;
  }
}
