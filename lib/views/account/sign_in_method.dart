import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flash_card/globals.dart';

class SignInMethodPage extends StatelessWidget {
  const SignInMethodPage({Key? key}) : super(key: key);

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
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: ElevatedButton(
                      child: Text(
                        L10n.of(context)!.loginWithGoogle,
                        style: Globals.buttonTextStyle,
                      ),
                      style: Globals.buttonStyle,
                      onPressed: () {},
                    )),
                Container(
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: ElevatedButton(
                      style: Globals.buttonStyle,
                      child: Text(
                        L10n.of(context)!.loginWithFacebook,
                        style: Globals.buttonTextStyle,
                      ),
                      onPressed: () {},
                    )),
                Container(
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: ElevatedButton(
                      style: Globals.buttonStyle,
                      child: Text(
                        L10n.of(context)!.loginWithTwitter,
                        style: Globals.buttonTextStyle,
                      ),
                      onPressed: () {},
                    )),
                const Divider(
                  thickness: 3,
                  height: 50,
                  indent: 20,
                  endIndent: 20,
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: ElevatedButton(
                      child: Text(
                        L10n.of(context)!.loginWithEmail,
                        style: Globals.buttonTextStyle,
                      ),
                      style: Globals.buttonStyle,
                      onPressed: () {
                        Navigator.of(context).pushNamed('/signInPage');
                      },
                    )),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Row(
                    children: <Widget>[
                      Text(L10n.of(context)!.notHaveAccount),
                      TextButton(
                        child: Text(
                          L10n.of(context)!.signUp,
                          style: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          //signup screen
                          Navigator.of(context).pushNamed('/signUpPage');
                        },
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
              ],
            )));
  }
}
