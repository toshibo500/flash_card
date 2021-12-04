import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flash_card/utilities/stt.dart';
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
  final Stt _stt = Stt();
  final List<DropdownMenuItem<String>> _langItems = [];
  final List<DropdownMenuItem<int>> _qAorderItems = [];

  static const Map<int, String> _qAOrder = {0: 'Front->Back', 1: 'Back->Front'};

  _SideDrawer({Key? key}) : super(key: key) {
    initSpeech();
    _qAOrder.forEach((key, value) {
      _qAorderItems.add(DropdownMenuItem(
        child: Text(
          value,
          style: const TextStyle(fontSize: 16.0),
        ),
        value: key,
      ));
    });
  }

  void initSpeech() async {
    await _stt.initSpeechState().then((value) => {setItems()});
  }

  void setItems() {
    for (var element in _stt.localeNames) {
      _langItems.add(DropdownMenuItem(
        child: Text(
          element.name,
          style: const TextStyle(fontSize: 16.0),
        ),
        value: element.localeId,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var _drawerMenuViewModel = Provider.of<DrawerMenuViewModel>(context);
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
                        'Settings',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                    ),
                  )),
              ListTile(
                leading: const Icon(
                  Icons.settings_rounded,
                ),
                title: const Text('Front side lang'),
                subtitle: DropdownButton<String>(
                  value: _drawerMenuViewModel.preference.frontSideLang,
                  items: _langItems,
                  onChanged: (value) {
                    _drawerMenuViewModel.preference.frontSideLang = value!;
                    _drawerMenuViewModel
                        .update(_drawerMenuViewModel.preference);
                  },
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.language_rounded,
                ),
                title: const Text('Back side lang'),
                subtitle: DropdownButton<String>(
                  value: _drawerMenuViewModel.preference.backSideLang,
                  items: _langItems,
                  onChanged: (value) {
                    _drawerMenuViewModel.preference.backSideLang = value!;
                    _drawerMenuViewModel
                        .update(_drawerMenuViewModel.preference);
                  },
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.book_rounded,
                ),
                title: const Text('Question'),
                subtitle: DropdownButton<int>(
                  value: _drawerMenuViewModel.preference.qAorder,
                  items: _qAorderItems,
                  onChanged: (value) {
                    _drawerMenuViewModel.preference.qAorder = value!;
                    _drawerMenuViewModel
                        .update(_drawerMenuViewModel.preference);
                  },
                ),
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
