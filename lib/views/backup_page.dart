import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flash_card/globals.dart';

class BackupPage extends StatelessWidget {
  const BackupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(L10n.of(context)!.backup),
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
                        L10n.of(context)!.backupData,
                        style: Globals.buttonTextStyle,
                      ),
                      style: Globals.buttonStyle,
                      onPressed: () async {},
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
                        L10n.of(context)!.restoreData,
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
                      Text(L10n.of(context)!.lastUpdatedAt('2022/2/14')),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
              ],
            )));
  }
}
