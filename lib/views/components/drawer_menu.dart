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
                leading: const Icon(
                  Icons.settings_rounded,
                  color: Colors.lightGreen,
                ),
                title: Text(L10n.of(context)!.settings),
                onTap: () {
                  Navigator.of(context).pushNamed('/settingsPage');
                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip_rounded,
                    color: Colors.lightBlue),
                title: Text(L10n.of(context)!.privacyPolcy),
                onTap: () {
                  Navigator.of(context).pushNamed('/webViewPage',
                      arguments: WevViewPageParameters(
                          title: 'Privacy Policy',
                          url: 'https://www.google.com'));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.support_outlined,
                  color: Colors.brown[200],
                ),
                title: Text(L10n.of(context)!.aboutApp),
                onTap: () {
                  Navigator.of(context).pushNamed('/webViewPage',
                      arguments: WevViewPageParameters(
                          title: 'About this app',
                          url: 'http://news.google.com'));
                },
              ),
            ],
          ),
        ));
  }
}
