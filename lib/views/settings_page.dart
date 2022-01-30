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
  @override
  Widget build(BuildContext context) {
    var _drawerMenuViewModel = Provider.of<SettingsViewModel>(context);
    final Map<String, String> _langItems = _drawerMenuViewModel.langItems;

    // 並び順用のMapを生成。contextがいるのでここで生成する。
    final Map<int, String> _quizOrderItems = {};
    Globals().quizOrderItems.forEach((key, value) {
      _quizOrderItems[key] = L10n.of(context)!.quizOrderItems(key);
    });

    // 並び替え方法用のMapを生成。contextがいるのでここで生成する。
    final Map<int, String> _quizOrderMethodItems = {};
    Globals().quizOrderMethodItems.forEach((key, value) {
      _quizOrderMethodItems[key] = L10n.of(context)!.quizOrderMethodItems(key);
    });

    // 問題数用のmap
    Map<int, String> _nummap = {};
    for (int i = 1; i <= 100; i++) {
      _nummap[i] = i.toString();
    }

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
                        context: context,
                        items: _langItems,
                        checkedItemKey:
                            _drawerMenuViewModel.preference.frontSideLang);
                    if (key != null) {
                      _drawerMenuViewModel.preference.frontSideLang = key;
                      // クイズページの表示用に名前も保存しておく
                      _drawerMenuViewModel.preference.frontSideLangName =
                          _langItems[key];
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
                        context: context,
                        items: _langItems,
                        checkedItemKey:
                            _drawerMenuViewModel.preference.backSideLang);
                    if (key != null) {
                      _drawerMenuViewModel.preference.backSideLang = key;
                      // クイズページの表示用に名前も保存しておく
                      _drawerMenuViewModel.preference.backSideLangName =
                          _langItems[key];

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
                  trailing: SizedBox(
                      child: Text(Globals().frontAndBackItems[
                              _drawerMenuViewModel.preference.question] ??
                          '')),
                  onPressed: (context) async {
                    int? key = await showSelectBottomSheet(
                        context: context,
                        items: Globals().frontAndBackItems,
                        checkedItemKey:
                            _drawerMenuViewModel.preference.question);
                    if (key != null) {
                      _drawerMenuViewModel.preference.question = key;
                      _drawerMenuViewModel
                          .update(_drawerMenuViewModel.preference);
                    }
                  },
                ),
                SettingsTile(
                  leading: const Icon(
                    Icons.mode_rounded,
                    color: Globals.iconColor2,
                  ),
                  title: L10n.of(context)!.quizMode,
                  trailing: SizedBox(
                      child: Text(Globals().quizModeItems[
                              _drawerMenuViewModel.preference.quizMode] ??
                          '')),
                  onPressed: (context) async {
                    int? key = await showSelectBottomSheet(
                        context: context,
                        items: Globals().quizModeItems,
                        checkedItemKey:
                            _drawerMenuViewModel.preference.quizMode);
                    if (key != null) {
                      _drawerMenuViewModel.preference.quizMode = key;
                      _drawerMenuViewModel
                          .update(_drawerMenuViewModel.preference);
                    }
                  },
                ),
                SettingsTile(
                  leading: const Icon(
                    Icons.format_list_numbered_rounded,
                    color: Globals.iconColor3,
                  ),
                  title: L10n.of(context)!.quizNum,
                  trailing: SizedBox(
                      child: Text(
                          _drawerMenuViewModel.preference.quizNum.toString())),
                  onPressed: (context) async {
                    int? key = await showSelectBottomSheet(
                        context: context,
                        items: _nummap,
                        checkedItemKey:
                            _drawerMenuViewModel.preference.quizNum);
                    if (key != null) {
                      _drawerMenuViewModel.preference.quizNum = key;
                      _drawerMenuViewModel
                          .update(_drawerMenuViewModel.preference);
                    }
                  },
                ),
                SettingsTile(
                  leading: const Icon(
                    Icons.sort_by_alpha_rounded,
                    color: Globals.iconColor1,
                  ),
                  title: L10n.of(context)!.quizOrder,
                  trailing: SizedBox(
                      child: Text(_quizOrderItems[
                              _drawerMenuViewModel.preference.quizOrder] ??
                          '')),
                  onPressed: (context) async {
                    int? key = await showSelectBottomSheet(
                        context: context,
                        items: _quizOrderItems,
                        checkedItemKey:
                            _drawerMenuViewModel.preference.quizOrder);
                    if (key != null) {
                      _drawerMenuViewModel.preference.quizOrder = key;
                      _drawerMenuViewModel
                          .update(_drawerMenuViewModel.preference);
                    }
                  },
                ),
                SettingsTile(
                  enabled: !_drawerMenuViewModel.isRandom,
                  leading: const Icon(
                    Icons.sort_rounded,
                    color: Globals.iconColor2,
                  ),
                  title: L10n.of(context)!.quizOrderMethod,
                  trailing: SizedBox(
                      child: Text(_quizOrderMethodItems[_drawerMenuViewModel
                              .preference.quizOrderMethod] ??
                          '')),
                  onPressed: (context) async {
                    int? key = await showSelectBottomSheet(
                        context: context,
                        items: _quizOrderMethodItems,
                        checkedItemKey:
                            _drawerMenuViewModel.preference.quizOrderMethod);
                    if (key != null) {
                      _drawerMenuViewModel.preference.quizOrderMethod = key;
                      _drawerMenuViewModel
                          .update(_drawerMenuViewModel.preference);
                    }
                  },
                ),
              ],
            ),
          ],
        ));
  }
}
