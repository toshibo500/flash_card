import 'package:firebase_core/firebase_core.dart';
import 'package:flash_card/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flash_card/globals.dart';
import 'package:flash_card/models/repositories/user_repository.dart';
import 'package:flash_card/views/components/error_text.dart';
import 'package:flash_card/views/components/alert_dialog.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  @override
  _SignUpPage createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  String newEmail = ""; // 入力されたメールアドレス
  String newPassword = ""; // 入力されたパスワード
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
          title: Text(L10n.of(context)!.signUp),
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
                    onChanged: (String value) => newEmail = value,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: L10n.of(context)!.emailAddress,
                    ),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextField(
                      onChanged: (String value) => newPassword = value,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: L10n.of(context)!.password,
                      ),
                    )),
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
                        L10n.of(context)!.signUp,
                        style: Globals.buttonTextStyle,
                      ),
                      onPressed: () async {
                        errorVisible = false;
                        try {
                          UserModel auth =
                              UserModel(email: newEmail, password: newPassword);
                          await UserRepository().signUp(auth);
                          if (kDebugMode) {
                            print(auth.id);
                          }
                          Globals().userInfo = auth;
                          showAlertDialog(
                              context: context,
                              text: L10n.of(context)!.signUpDoneMsg,
                              popUntil: '/');
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
