import 'package:firebase_core/firebase_core.dart';
import 'package:flash_card/models/repositories/user_repository.dart';
import 'package:flash_card/views/components/error_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flash_card/globals.dart';
import 'package:flash_card/views/components/alert_dialog.dart';

class RestPasswordPage extends StatefulWidget {
  const RestPasswordPage({Key? key}) : super(key: key);
  @override
  _RestPasswordPage createState() => _RestPasswordPage();
}

class _RestPasswordPage extends State<RestPasswordPage> {
  String _email = ""; // 入力されたメールアドレス
  String errorCode = '';
  String errorMessage = '';
  bool errorVisible = false;

  @override
  void initState() {
    initFireBase();
    super.initState();
  }

  void initFireBase() async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(L10n.of(context)!.restPassword),
          backgroundColor: Globals.backgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () => Navigator.pop<bool>(context, false),
          ),
          actions: const [],
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    onChanged: (String value) => _email = value,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: L10n.of(context)!.emailAddress,
                    ),
                  ),
                ),
                Visibility(
                  visible: errorVisible,
                  child: ErrorText(
                    code: errorCode,
                    message: errorMessage,
                  ),
                ),
                Container(
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      style: Globals.buttonStyle,
                      child: Text(
                        L10n.of(context)!.restPassword,
                        style: Globals.buttonTextStyle,
                      ),
                      onPressed: () async {
                        errorVisible = false;
                        try {
                          await UserRepository().restPassword(email: _email);
                          showAlertDialog(
                            context: context,
                            text: L10n.of(context)!.passwordRestMailSent,
                          );
                        } on AuthException catch (e) {
                          setState(() {
                            errorVisible = true;
                            errorCode = e.code;
                            errorMessage = e.message;
                          });
                        }
                      },
                    )),
              ],
            )));
  }
}
