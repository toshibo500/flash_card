import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flash_card/viewmodels/settings_viewmodel.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flash_card/views/components/select_bottom_sheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flash_card/globals.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SettingsViewModel(),
      child: Scaffold(body: _SettingsPage()),
    );
  }
}

class _SettingsPage extends StatelessWidget {
//  final Map<String, String> _langItems = {};
  final List<DropdownMenuItem<int>> _questionItems = [];
  final List<DropdownMenuItem<int>> _quizModeItems = [];
  final List<DropdownMenuItem<int>> _numOfQuiz = [];

  _SettingsPage({Key? key}) : super(key: key) {
    Globals().frontAndBackItems.forEach((key, value) {
      // PreferenceModel.frontAndBackItems.forEach((key, value) {
      _questionItems.add(DropdownMenuItem(
        child: Text(
          value,
          style: const TextStyle(fontSize: 16.0),
        ),
        value: key,
      ));
    });

    Globals().quizModeItems.forEach((key, value) {
      // PreferenceModel.quizModeItems.forEach((key, value) {
      _quizModeItems.add(DropdownMenuItem(
        child: Text(
          value,
          style: const TextStyle(fontSize: 16.0),
        ),
        value: key,
      ));
    });
    List.generate(100, (index) {
      _numOfQuiz.add(DropdownMenuItem(
        child: Text(index.toString()),
        value: index,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    var _drawerMenuViewModel = Provider.of<SettingsViewModel>(context);
    final Map<String, String> _langItems = _drawerMenuViewModel.langItems;
    // 並び順用のDropdownMenuItemを生成。contextがいるのでここで生成する。
    List<DropdownMenuItem<int>> _quizOrderItems = [];
    Globals().quizOrderItems.forEach((key, value) {
      _quizOrderItems.add(DropdownMenuItem(
        child: Text(
          L10n.of(context)!.orderOfQuizTitle(key),
          style: const TextStyle(fontSize: 16.0),
        ),
        value: key,
      ));
    });
    return Scaffold(
        backgroundColor: Globals.backgroundColor,
        appBar: AppBar(
          title: Text(L10n.of(context)!.settings),
          backgroundColor: Globals.backgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () => {Navigator.of(context).pop()},
          ),
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
              title: L10n.of(context)!.voiceInput,
              tiles: [
                SettingsTile(
                  title: L10n.of(context)!.cardFront,
                  leading: const Icon(
                    Icons.language_rounded,
                    color: Globals.iconColor1,
                  ),
                  trailing: SizedBox(
                      child: Text(_langItems[
                              _drawerMenuViewModel.preference.frontSideLang] ??
                          '')),
                  onPressed: (context) async {
                    String? key = await showSelectBottomSheet(
                        context: context, items: _langItems);
                    if (key != null) {
                      _drawerMenuViewModel.preference.frontSideLang = key;
                      _drawerMenuViewModel
                          .update(_drawerMenuViewModel.preference);
                    }
                  },
                ),
                SettingsTile(
                  title: L10n.of(context)!.cardBack,
                  leading: const Icon(
                    Icons.language_rounded,
                    color: Globals.iconColor2,
                  ),
                  trailing: SizedBox(
                      child: Text(_langItems[
                              _drawerMenuViewModel.preference.backSideLang] ??
                          '')),
                  onPressed: (context) async {
                    String? key = await showSelectBottomSheet(
                        context: context, items: _langItems);
                    if (key != null) {
                      _drawerMenuViewModel.preference.backSideLang = key;
                      _drawerMenuViewModel
                          .update(_drawerMenuViewModel.preference);
                    }
                  },
                ),
              ],
            ),
            SettingsSection(
              title: L10n.of(context)!.quiz,
              tiles: [
                SettingsTile(
                  leading: const Icon(
                    Icons.style_rounded,
                    color: Globals.iconColor1,
                  ),
                  title: L10n.of(context)!.question,
                  trailing: DropdownButton<int>(
                    underline: DropdownButtonHideUnderline(child: Container()),
                    value: _drawerMenuViewModel.preference.question,
                    items: _questionItems,
                    onChanged: (value) {
                      _drawerMenuViewModel.preference.question = value!;
                      _drawerMenuViewModel
                          .update(_drawerMenuViewModel.preference);
                    },
                  ),
                ),
                SettingsTile(
                  leading: const Icon(
                    Icons.mode_rounded,
                    color: Globals.iconColor2,
                  ),
                  title: L10n.of(context)!.quizMode,
                  trailing: DropdownButton<int>(
                    value: _drawerMenuViewModel.preference.quizMode,
                    underline: DropdownButtonHideUnderline(child: Container()),
                    items: _quizModeItems,
                    onChanged: (value) {
                      _drawerMenuViewModel.preference.quizMode = value!;
                      _drawerMenuViewModel
                          .update(_drawerMenuViewModel.preference);
                    },
                  ),
                ),
                SettingsTile(
                  leading: const Icon(
                    Icons.format_list_numbered_rounded,
                    color: Globals.iconColor3,
                  ),
                  title: L10n.of(context)!.numberOfQuestion,
                  trailing: DropdownButton<int>(
                    value: _drawerMenuViewModel.preference.numOfQuiz,
                    underline: DropdownButtonHideUnderline(child: Container()),
                    items: _numOfQuiz,
                    onChanged: (value) {
                      _drawerMenuViewModel.preference.numOfQuiz = value!;
                      _drawerMenuViewModel
                          .update(_drawerMenuViewModel.preference);
                    },
                  ),
                ),
                SettingsTile(
                  leading: const Icon(
                    Icons.sort_rounded,
                    color: Globals.iconColor2,
                  ),
                  title: L10n.of(context)!.quizOrder,
                  trailing: DropdownButton<int>(
                    value: _drawerMenuViewModel.preference.orderOfQuiz,
                    underline: DropdownButtonHideUnderline(child: Container()),
                    items: _quizOrderItems,
                    onChanged: (value) {
                      _drawerMenuViewModel.preference.orderOfQuiz = value!;
                      _drawerMenuViewModel
                          .update(_drawerMenuViewModel.preference);
                    },
                  ),
                ),
              ],
            ),
          ],
        ));

    /* SizedBox(
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
                  'Quiz',
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
                          value: _drawerMenuViewModel.preference.quizMode,
                          items: _quizModeItems,
                          onChanged: (value) {
                            _drawerMenuViewModel.preference.quizMode = value!;
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
                          value: _drawerMenuViewModel.preference.numOfQuiz,
                          items: _numOfQuiz,
                          onChanged: (value) {
                            _drawerMenuViewModel.preference.numOfQuiz = value!;
                            _drawerMenuViewModel
                                .update(_drawerMenuViewModel.preference);
                          },
                        ),
                      ])),
            ],
          ),
        )); */
  }
}
