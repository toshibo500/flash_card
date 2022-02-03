import 'package:firebase_core/firebase_core.dart';
import 'package:flash_card/models/auth_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flash_card/globals.dart';
import 'package:flash_card/models/repositories/auth_repository.dart';
import 'package:flash_card/views/components/error_text.dart';

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
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                    ),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextField(
                      maxLengthEnforcement: MaxLengthEnforcement.none,
                      onChanged: (String value) => newPassword = value,
                      obscureText: true,
                      maxLength: 20,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
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
                      child: const Text('Sign Up'),
                      onPressed: () async {
                        errorVisible = false;
                        try {
                          await AuthRepository().signUp(AuthModel(
                              email: newEmail, password: newPassword));
                          Navigator.popUntil(context, ModalRoute.withName('/'));
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
