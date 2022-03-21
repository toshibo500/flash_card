import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getErrorMessage(BuildContext context, String code,
    [String message = '']) {
  switch (code) {
    case 'invalid-email':
      // return L10n.of(context)!.invalidEmail;
      return '';
    case 'wrong-password':
      // return L10n.of(context)!.wrongPassword;
      return '';
    case 'user-not-found':
      // return L10n.of(context)!.userNotFound;
      return '';
    case 'user-disabled':
      // return L10n.of(context)!.userDisabled;
      return '';
    case 'too-many-requests':
      // return L10n.of(context)!.tooManyRequests;
      return '';
    case 'operation-not-allowed':
      // return L10n.of(context)!.operationNotAllowed;
      return '';
    case 'email-already-in-use':
      // return L10n.of(context)!.emailAlreadyInUse;
      return '';
    case 'weak-password':
      // return L10n.of(context)!.weakPassword;
      return '';
    case 'missing-email':
      // return L10n.of(context)!.missingEmail;
      return '';
    case 'password-not-match':
      // return L10n.of(context)!.passwordNotMatch;
      return '';
    case 'signinCanceled':
      // return L10n.of(context)!.signinCanceld;
      return '';
    case 'folder-not-found':
      return L10n.of(context)!.folderNotFound;
    case 'wrong-file':
      return L10n.of(context)!.wrongFile;
    default:
      return message;
  }
}
