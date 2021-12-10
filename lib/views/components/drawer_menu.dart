import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flash_card/viewmodels/drawer_menu_viewmodel.dart';
import 'package:flash_card/views/web_view_page.dart';

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
              const SizedBox(
                  height: 150,
                  child: DrawerHeader(
                    child: Center(
                      child: Text(
                        'menu',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                    ),
                  )),
              ListTile(
                leading: const Icon(Icons.settings_rounded),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.of(context).pushNamed('/settingsPage');
                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip_rounded),
                title: const Text('Privacy Policy'),
                onTap: () {
                  Navigator.of(context).pushNamed('/webViewPage',
                      arguments: WevViewPageParameters(
                          title: 'Privacy Policy',
                          url: 'https://www.google.com'));
                },
              ),
              ListTile(
                leading: const Icon(Icons.support_outlined),
                title: const Text('About this app'),
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
