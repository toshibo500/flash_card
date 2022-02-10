import 'package:firebase_core/firebase_core.dart';
import 'package:flash_card/models/auth_model.dart';
import 'package:flash_card/models/repositories/auth_repository.dart';
import 'package:flash_card/views/components/error_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flash_card/globals.dart';

class SingleSignOnPage extends StatefulWidget {
  const SingleSignOnPage({required this.loginMethod, Key? key})
      : super(key: key);
  final LoginMethod loginMethod;
  @override
  _SingleSignOnPage createState() => _SingleSignOnPage();
}

class _SingleSignOnPage extends State<SingleSignOnPage> {
  String errorCode = '';
  String errorMessage = '';
  bool errorVisible = false;

  @override
  void initState() {
    initFireBase();
    _sso();
    super.initState();
  }

  void initFireBase() async {
    await Firebase.initializeApp();
  }

  void _sso() async {
    try {
      if (widget.loginMethod == LoginMethod.google) {
        await _googleSSO();
      }
      Navigator.popUntil(context, ModalRoute.withName('/'));
    } on AuthException catch (e) {
      setState(() {
        errorVisible = true;
        errorCode = e.code;
        errorMessage = e.message;
      });
    }
  }

  Future<void> _googleSSO() async {
    AuthModel auth = AuthModel(loginMethod: LoginMethod.google);
    await AuthRepository().googleSignIn(auth);
    Globals().authInfo = auth;
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
                Visibility(
                    visible: !errorVisible,
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text(
                          L10n.of(context)!.signingIn,
                          style: const TextStyle(fontSize: 16),
                        ))),
                Visibility(
                  visible: errorVisible,
                  child: ErrorText(
                    code: errorCode,
                    message: errorMessage,
                  ),
                ),
              ],
            )));
  }
}
