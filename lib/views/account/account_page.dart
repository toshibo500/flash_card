import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flash_card/models/repositories/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flash_card/viewmodels/settings_viewmodel.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flash_card/globals.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SettingsViewModel(),
      child: Scaffold(body: _AccountPage()),
    );
  }
}

class _AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Globals.backgroundColor,
        appBar: AppBar(
          title: Text(L10n.of(context)!.account),
          backgroundColor: Globals.backgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () => {Navigator.of(context).pop()},
          ),
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
              title: L10n.of(context)!.account,
              tiles: [
                /*
                SettingsTile(
                    title: L10n.of(context)!.profile,
                    leading: const Icon(
                      Icons.account_circle_rounded,
                      color: Globals.iconColor1,
                    ),
                    onPressed: (context) async {}),
                */
                SettingsTile(
                  title: L10n.of(context)!.password,
                  leading: const Icon(
                    Icons.password_rounded,
                    color: Globals.iconColor2,
                  ),
                  onPressed: (context) {
                    Navigator.of(context).pushNamed('/passwordPage');
                  },
                ),
              ],
            ),
            SettingsSection(
              tiles: [
                SettingsTile(
                    title: L10n.of(context)!.signOut,
                    leading: const Icon(
                      Icons.logout_rounded,
                      color: Globals.iconColor3,
                    ),
                    onPressed: (context) async {
                      if (await confirm(
                        context,
                        title: null,
                        content: Text(L10n.of(context)!.signOutConfirmation),
                        textOK: Text(L10n.of(context)!.ok),
                        textCancel: Text(L10n.of(context)!.cancel),
                      )) {
                        UserRepository().signOut();
                        Globals().userInfo = null;
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                      }
                    }),
              ],
            ),
          ],
        ));
  }
}
