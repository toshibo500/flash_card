import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flash_card/utilities/error_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flash_card/globals.dart';
import 'package:flash_card/viewmodels/backup_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flash_card/main.dart';
import 'components/alert_dialog.dart';
import 'components/progress_dialog.dart';
import 'package:flash_card/utilities/date_time_util.dart';

class BackupPage extends StatelessWidget {
  const BackupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BackupViewModel(),
      child: const Scaffold(body: _BackupPage()),
    );
  }
}

class _BackupPage extends StatelessWidget {
  const _BackupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _backupViewModel = Provider.of<BackupViewModel>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(L10n.of(context)!.backup),
          backgroundColor: Globals.backgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () {
              reloadHomePage(context);
            },
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
                      onPressed: () async {
                        if (await confirm(
                          context,
                          title: null,
                          content: Text(L10n.of(context)!.backupConfirmation),
                          textOK: Text(L10n.of(context)!.ok),
                          textCancel: Text(L10n.of(context)!.cancel),
                        )) {
                          showProgressDialog(context);
                          await Future.delayed(const Duration(seconds: 1));
                          try {
                            await _backupViewModel.backup();
                            Navigator.of(context).pop();
                            await showAlertDialog(
                                context: context,
                                text: L10n.of(context)!.backupDone,
                                popCount: 1);
                            reloadHomePage(context);
                          } on PlatformException catch (e) {
                            Navigator.of(context).pop();
                            await showAlertDialog(
                                icon: const Icon(Icons.error_rounded,
                                    color: Globals.iconColorError),
                                title: L10n.of(context)!.errorDialogTitle,
                                context: context,
                                text: getErrorMessage(
                                    context, e.code, e.message.toString()),
                                popCount: 1);
                          }
                        }
                      },
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
                      onPressed: () async {
                        if (await confirm(
                          context,
                          title: null,
                          content: Text(L10n.of(context)!.resotreConfirmation),
                          textOK: Text(L10n.of(context)!.ok),
                          textCancel: Text(L10n.of(context)!.cancel),
                        )) {
                          showProgressDialog(context);
                          await Future.delayed(const Duration(seconds: 1));
                          try {
                            await _backupViewModel.restore();
                            Navigator.of(context).pop();
                            await showAlertDialog(
                                context: context,
                                text: L10n.of(context)!.restoreDone,
                                popCount: 1);
                            reloadHomePage(context);
                          } on PlatformException catch (e) {
                            Navigator.of(context).pop();
                            await showAlertDialog(
                                icon: const Icon(Icons.error_rounded,
                                    color: Globals.iconColorError),
                                title: L10n.of(context)!.errorDialogTitle,
                                context: context,
                                text: getErrorMessage(
                                    context, e.code, e.message.toString()),
                                popCount: 1);
                          }
                        }
                      },
                    )),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Row(
                    children: <Widget>[
                      Text(L10n.of(context)!.lastUpdatedAt(
                          DateTimeUtil.toLocaleString(
                              _backupViewModel.lastBackuptime,
                              'yyyy-MM-dd HH:mm'))),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
              ],
            )));
  }

  void reloadHomePage(BuildContext context) {
    RouteSettings settings = const RouteSettings(name: '/');
    // 普通に戻ると画面が再描画されないのでMyHomePageを再表示
    Navigator.of(context).pushAndRemoveUntil(
        // 左から右に遷移させるためだけにこんなめんどくさいコードを書く。 ----
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            // 表示する画面のWidget
            return const MyHomePage();
          },
          settings: settings,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            //const begin = Offset(1.0, 0.0); // 右から左
            const Offset begin = Offset(-1.0, 0.0); // 左から右
            const Offset end = Offset.zero;
            final Animatable<Offset> tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: Curves.easeInOut));
            final Animation<Offset> offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
        // --------------------------------------------------------
        (_) => false); // falseにするとスタックを削除して全て遷移する。
  }
}
