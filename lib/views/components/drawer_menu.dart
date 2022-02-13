import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flash_card/viewmodels/drawer_menu_viewmodel.dart';
import 'package:flash_card/views/web_view_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flash_card/globals.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DrawerMenuViewModel(),
      child: Scaffold(body: _SideDrawer()),
    );
  }
}

class _SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 350,
        child: Drawer(
          child: Column(
            children: <Widget>[
              SizedBox(
                  height: 150,
                  child: DrawerHeader(
                    child: Center(
                      child: Text(
                        L10n.of(context)!.drawer,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                    decoration: const BoxDecoration(
                      color: Globals.backgroundColor,
                    ),
                  )),
              ListTile(
                leading: Icon(
                  Icons.account_circle_rounded,
                  color: Globals().userInfo == null
                      ? Globals.iconColor3
                      : Globals.iconColor2,
                ),
                title: Text(Globals().userInfo?.displayName ??
                    L10n.of(context)!.account),
                onTap: () {
                  // Drawerを閉じてから設定を開く
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(Globals().userInfo != null
                      ? '/accountPage'
                      : '/signInMethodPage');
                },
              ),
              ListTile(
                enabled: true,
                leading: const Icon(
                  Icons.backup_rounded,
                  color: Globals.iconColor3,
                ),
                title: Text(L10n.of(context)!.backup),
                onTap: () {
                  // Drawerを閉じてから設定を開く
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(Globals().userInfo != null
                      ? '/backupPage'
                      : '/signInMethodPage');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.settings_rounded,
                  color: Globals.iconColor1,
                ),
                title: Text(L10n.of(context)!.settings),
                onTap: () {
                  // Drawerを閉じてから設定を開く
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/settingsPage');
                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip_rounded,
                    color: Globals.iconColor2),
                title: Text(L10n.of(context)!.privacyPolcy),
                onTap: () {
                  // Drawerを閉じてから設定を開く
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/webViewPage',
                      arguments: WevViewPageParameters(
                          title: L10n.of(context)!.privacyPolcy,
                          url: L10n.of(context)!.privacyPolicyURL));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.support_outlined,
                  color: Globals.iconColor3,
                ),
                title: Text(L10n.of(context)!.aboutApp),
                onTap: () {
                  // Drawerを閉じてから設定を開く
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/webViewPage',
                      arguments: WevViewPageParameters(
                          title: L10n.of(context)!.aboutApp,
                          url: L10n.of(context)!.aboutAppURL));
                },
              ),
            ],
          ),
        ));
  }
}
