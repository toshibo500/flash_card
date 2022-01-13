import 'package:flutter/material.dart';
import 'package:flash_card/globals.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CorrectPopupDialog {
  void popup(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
        return SafeArea(
          child: Builder(builder: (context) {
            return Material(
                color: Colors.transparent,
                child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        alignment: Alignment.center,
                        height: 100.0,
                        width: 200.0,
                        color: Colors.transparent,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Globals().correctPopupIcon,
                              Text(
                                L10n.of(context)!.correctPopUpText,
                                style: Globals.correctPpopUpStyle,
                              ),
                            ]))));
          }),
        );
      },
      barrierColor: Colors.transparent,
    );
  }
}
