import 'package:firebase_core/firebase_core.dart';
import 'package:flash_card/models/user_model.dart';
import 'package:flash_card/models/repositories/user_repository.dart';
import 'package:flash_card/views/components/error_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flash_card/globals.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);
  @override
  _SignInPage createState() => _SignInPage();
}

class _SignInPage extends State<SignInPage> {
  String _email = ""; // 入力されたメールアドレス
  String _password = ""; // 入力されたパスワード
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
          title: Text(L10n.of(context)!.signIn),
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
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    onChanged: (String value) => _password = value,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: L10n.of(context)!.password,
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
                        L10n.of(context)!.signIn,
                        style: Globals.buttonTextStyle,
                      ),
                      onPressed: () async {
                        errorVisible = false;
                        try {
                          UserModel auth =
                              UserModel(email: _email, password: _password);
                          await UserRepository().signIn(auth);
                          if (kDebugMode) {
                            print(auth.id);
                          }
                          Globals().userInfo = auth;
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
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/restPasswordPage');
                    },
                    child: Text(
                      L10n.of(context)!.forgotPassword,
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(L10n.of(context)!.notHaveAccount),
                    TextButton(
                      child: Text(
                        L10n.of(context)!.signUp,
                        style: const TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        //signup screen
                        Navigator.of(context)
                            .pushReplacementNamed('/signUpPage');
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ],
            )));
  }
}
