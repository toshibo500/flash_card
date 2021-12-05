import 'dart:ui';
import 'package:flash_card/models/preference_model.dart';
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
  final List<DropdownMenuItem<int>> _questionItems = [];
  final List<DropdownMenuItem<int>> _testModeItems = [];
  final List<DropdownMenuItem<int>> _numOfTest = [];

  _SideDrawer({Key? key}) : super(key: key) {
    initSpeech();
    PreferenceModel.frontAndBackItems.forEach((key, value) {
      _questionItems.add(DropdownMenuItem(
        child: Text(
          value,
          style: const TextStyle(fontSize: 16.0),
        ),
        value: key,
      ));
    });
    PreferenceModel.testModeItems.forEach((key, value) {
      _testModeItems.add(DropdownMenuItem(
        child: Text(
          value,
          style: const TextStyle(fontSize: 16.0),
        ),
        value: key,
      ));
    });
    List.generate(100, (index) {
      _numOfTest.add(DropdownMenuItem(
        child: Text(index.toString()),
        value: index,
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
              Container(
                height: 30,
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                child: const Text(
                  'Voice Input',
                  style: TextStyle(color: Colors.black45),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.language_rounded,
                ),
                title: const Text('Front'),
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
                title: const Text('Back'),
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
              Container(
                height: 30,
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                child: const Text(
                  'Test',
                  style: TextStyle(color: Colors.black45),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.style_rounded,
                ),
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Question'),
                      DropdownButton<int>(
                        value: _drawerMenuViewModel.preference.question,
                        items: _questionItems,
                        onChanged: (value) {
                          _drawerMenuViewModel.preference.question = value!;
                          _drawerMenuViewModel
                              .update(_drawerMenuViewModel.preference);
                        },
                      )
                    ]),
              ),
              ListTile(
                  leading: const Icon(
                    Icons.mode_rounded,
                  ),
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Mode'),
                        DropdownButton<int>(
                          value: _drawerMenuViewModel.preference.testMode,
                          items: _testModeItems,
                          onChanged: (value) {
                            _drawerMenuViewModel.preference.testMode = value!;
                            _drawerMenuViewModel
                                .update(_drawerMenuViewModel.preference);
                          },
                        )
                      ])),
              ListTile(
                  leading: const Icon(
                    Icons.format_list_numbered_rounded,
                  ),
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Number of questions'),
                        DropdownButton<int>(
                          value: _drawerMenuViewModel.preference.numOfTest,
                          items: _numOfTest,
                          onChanged: (value) {
                            _drawerMenuViewModel.preference.numOfTest = value!;
                            _drawerMenuViewModel
                                .update(_drawerMenuViewModel.preference);
                          },
                        ),
                      ])),
              Container(
                height: 30,
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                child: const Text(
                  'Misc',
                  style: TextStyle(color: Colors.black45),
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
