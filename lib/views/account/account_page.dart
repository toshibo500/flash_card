import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flash_card/globals.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

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
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text('Login with Google'),
                      onPressed: () {},
                    )),
                Container(
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text('Login with Facebook'),
                      onPressed: () {},
                    )),
                Container(
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text('Login with Twitter'),
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
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text('Login with e-mail'),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/signInPage');
                      },
                    )),
                Row(
                  children: <Widget>[
                    const Text('Does not have account?'),
                    TextButton(
                      child: const Text(
                        'Sign up',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        //signup screen
                        Navigator.of(context).pushNamed('/signUpPage');
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ],
            )));
  }
}
