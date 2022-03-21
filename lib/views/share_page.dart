import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flash_card/globals.dart';
import 'package:provider/provider.dart';
import 'package:flash_card/main.dart';
import 'package:flash_card/viewmodels/share_viewmodel.dart';
import 'package:flash_card/views/components/alert_dialog.dart';
import '../utilities/error_message.dart';
import 'components/select_folder_dialog.dart';
import 'package:file_picker/file_picker.dart';

class SharePage extends StatelessWidget {
  const SharePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ShareViewModel(),
      child: const Scaffold(body: _SharePage()),
    );
  }
}

class _SharePage extends StatelessWidget {
  const _SharePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _backupViewModel = Provider.of<ShareViewModel>(context);

    // shareする処理
    Future shareFolder(String? folder) async {
      try {
        await _backupViewModel.share(folderId: folder);
      } on PlatformException catch (e) {
        await showAlertDialog(
            icon:
                const Icon(Icons.error_rounded, color: Globals.iconColorError),
            title: L10n.of(context)!.errorDialogTitle,
            context: context,
            text: getErrorMessage(context, e.code, e.message.toString()),
            popCount: 1);
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(L10n.of(context)!.share),
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
                        L10n.of(context)!.shareAllData,
                        style: Globals.buttonTextStyle,
                      ),
                      style: Globals.buttonStyle,
                      onPressed: () async {
                        if (await confirm(
                          context,
                          title: null,
                          content: Text(L10n.of(context)!.shareConfirmation),
                          textOK: Text(L10n.of(context)!.ok),
                          textCancel: Text(L10n.of(context)!.cancel),
                        )) {
                          await shareFolder(null);
                        }
                      },
                    )),
                Container(
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: ElevatedButton(
                      child: Text(
                        L10n.of(context)!.shareFolder,
                        style: Globals.buttonTextStyle,
                      ),
                      style: Globals.buttonStyle,
                      onPressed: () async {
                        String folderId = await showSelectFolderDialog(
                            context: context,
                            parentFolderId: Globals.rootFolderId,
                            isParentSelectable: true,
                            text: L10n.of(context)!.chooseFolderToShare);
                        if (folderId.isNotEmpty) {
                          await shareFolder(folderId);
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
                        L10n.of(context)!.importData,
                        style: Globals.buttonTextStyle,
                      ),
                      style: Globals.buttonStyle,
                      onPressed: () async {
                        try {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles();

                          if (result != null) {
                            await _backupViewModel.import(
                                path: result.files.single.path);

                            await showAlertDialog(
                                context: context,
                                text: L10n.of(context)!.importDone,
                                popCount: 1);
                            reloadHomePage(context);
                          }
                        } on PlatformException catch (e) {
                          await showAlertDialog(
                              icon: const Icon(Icons.error_rounded,
                                  color: Globals.iconColorError),
                              title: L10n.of(context)!.errorDialogTitle,
                              context: context,
                              text: getErrorMessage(
                                  context, e.code, e.message.toString()),
                              popCount: 1);
                        }
                      },
                    )),
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
