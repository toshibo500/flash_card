import 'package:firebase_core/firebase_core.dart';
import 'package:flash_card/models/user_model.dart';
import 'package:flash_card/models/repositories/user_repository.dart';
import 'package:flash_card/views/components/alert_dialog.dart';
import 'package:flash_card/views/components/error_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flash_card/globals.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({Key? key}) : super(key: key);
  @override
  _PasswordPage createState() => _PasswordPage();
}

class _PasswordPage extends State<PasswordPage> {
  String _oldPassword = ""; // 古いパスワード
  String _newPassword = ""; // 新しいパスワード
  String _newPassword2 = ""; // 新しいパスワード確認
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
          title: Text(L10n.of(context)!.password),
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
                    onChanged: (String value) => _oldPassword = value,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: L10n.of(context)!.oldPassword,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    onChanged: (String value) => _newPassword = value,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: L10n.of(context)!.newPassword,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    onChanged: (String value) => _newPassword2 = value,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: L10n.of(context)!.confirmPassword,
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
                    margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: Text(L10n.of(context)!.save),
                      onPressed: () async {
                        errorVisible = false;
                        try {
                          _valiation();
                          UserModel userModl = UserModel(
                              email: Globals().userInfo?.email ?? '',
                              password: _oldPassword);
                          await UserRepository().updatePassword(
                              userModel: userModl, newPassword: _newPassword);
                          if (kDebugMode) {
                            print(userModl.id);
                          }
                          Globals().userInfo = userModl;
                          showAlertDialog(
                            context: context,
                            text: L10n.of(context)!.passwordChangedMsg,
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

  bool _valiation() {
    if (_newPassword != _newPassword2) {
      throw AuthException(
          code: 'password-not-match', message: 'password does not match.');
    }
    return true;
  }
}
