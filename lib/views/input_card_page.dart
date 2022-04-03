import 'package:flash_card/globals.dart';
import 'package:flash_card/models/card_model.dart';
import 'package:flash_card/views/components/stt_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flash_card/models/repositories/preference_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import '../models/folder_model.dart';
import '../models/repositories/folder_repository.dart';
import 'components/select_bottom_sheet.dart';
import 'components/select_folder_dialog.dart';

class InputCardPage extends StatefulWidget {
  const InputCardPage({Key? key, required this.card}) : super(key: key);
  final CardModel card;
  @override
  _InputCardPage createState() => _InputCardPage();
}

class _InputCardPage extends State<InputCardPage> {
  final List<TextEditingController> _textCtl = [
    TextEditingController(text: ''),
    TextEditingController(text: '')
  ];
  final List<String> _langIds = ['', ''];
  late bool _isNew;
  late FocusNode _textNode1;
  late FocusNode _textNode2;

  @override
  void initState() {
    super.initState();
    _isNew = widget.card.id == '' ? true : false;
    _textCtl[0].text = widget.card.front;
    _textCtl[1].text = widget.card.back;
    _langIds[0] = widget.card.frontLang ?? '';
    _langIds[1] = widget.card.backLang ?? '';
    if (_langIds[0].isEmpty || _langIds[1].isEmpty) {
      initPreference();
    }
    _textNode1 = FocusNode();
    _textNode2 = FocusNode();
    getFolder(widget.card.folderId);
  }

  @override
  void dispose() {
    _textNode1.dispose();
    _textNode2.dispose();
    super.dispose();
  }

  void initPreference() async {
    PreferenceRepository().get().then((value) {
      setState(() {
        _langIds[0] = value.frontSideLang ?? '';
        _langIds[1] = value.backSideLang ?? '';
      });
    });
  }

  late FolderModel _folder = FolderModel('', '', '', '', 0);
  void getFolder(String folderId) {
    // フォルダを取得
    FolderRepository().getById(folderId).then((value) {
      setState(() {
        _folder = value!;
      });
    });
  }

  TextButton _keyboardTextbutton(String text, Function()? onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: Globals.keyboardTextButtonStyle,
      ),
    );
  }

  // キーボードアクション
  Widget _keyboardActionItems(int index) {
    return SizedBox(
        height: 40,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _keyboardTextbutton('Save&Next', _nextOnPressd),
          _keyboardTextbutton('Cancel', _cancelOnPressd),
          _keyboardTextbutton('Save', _saveOnPressd),
          _buildMicIcon(index, 24, Colors.black87)
        ]));
  }

  @override
  Widget build(BuildContext context) {
    // キーボードに done, 上下 アクション追加
    KeyboardActionsConfig _keyboardActionConfig = KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Theme.of(context).disabledColor,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _textNode1,
          footerBuilder: (_) => PreferredSize(
              child: _keyboardActionItems(0),
              preferredSize: const Size.fromHeight(40)),
        ),
        KeyboardActionsItem(
          focusNode: _textNode2,
          footerBuilder: (_) => PreferredSize(
              child: _keyboardActionItems(1),
              preferredSize: const Size.fromHeight(40)),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context)!.createCardPageTitle),
        backgroundColor: Globals.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => Navigator.pop<bool>(context, false),
        ),
        actions: const [],
      ),
      body: KeyboardActions(
          config: _keyboardActionConfig,
          child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            _isNew ? Container() : _buildCard(_folder), // 編集時のみフォルダ変更可能
            _buildTextField(0, L10n.of(context)!.cardFront,
                L10n.of(context)!.createCardFrontHint),
            _buildTextField(1, L10n.of(context)!.cardBack,
                L10n.of(context)!.createCardBackHint),
            Container(
                padding: const EdgeInsets.only(top: 30),
                child: _buildButtons()),
          ]))),
    );
  }

  bool _validation() {
    if (_textCtl[0].text.isEmpty) {
      _textNode1.requestFocus();
      return false;
    }
    if (_textCtl[1].text.isEmpty) {
      _textNode2.requestFocus();
      return false;
    }
    return true;
  }

  // nextボタン押下時
  void _nextOnPressd() {
    if (!_validation()) return;
    widget.card.front = _textCtl[0].text;
    widget.card.back = _textCtl[1].text;
    Navigator.pop<bool>(context, true);
  }

  // Cancelボタン押下時
  void _cancelOnPressd() => Navigator.pop<bool>(context, false);

  // saveボタン押下時
  void _saveOnPressd() {
    if (!_validation()) return;
    widget.card.front = _textCtl[0].text;
    widget.card.back = _textCtl[1].text;
    widget.card.frontLang = _langIds[0];
    widget.card.backLang = _langIds[1];
    Navigator.pop<bool>(context, false);
  }

  Widget _buildCard(FolderModel folder) {
    return Column(children: <Widget>[
      Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.fromLTRB(5, 5, 10, 0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  L10n.of(context)!.folderName,
                  style: Globals.titleTextStyle,
                ),
              ])),
      Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.grey, width: 0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[_buildListTile(folder)]),
      )
    ]);
  }

  Widget _buildListTile(FolderModel folder) {
    String text = folder.title;
    Icon icon = Globals().folderIcon; // フォルダアイコン
    return SizedBox(
        height: 45,
        child: ListTile(
          dense: true,
          title: Row(children: [
            icon,
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 16),
            )
          ]),
          onTap: () async {
            String folderId = await showSelectFolderDialog(
              context: context,
              parentFolderId: folder.parentId,
              selectedFolderId: folder.id,
              isParentSelectable: false,
              text: L10n.of(context)!.chooseFolderToMove,
            );
            if (folderId.isNotEmpty) {
              getFolder(folderId);
              widget.card.folderId = folderId;
            }
          },
        ));
  }

  Row _buildButtons() {
    // Nextボタン
    Widget nextButton = Expanded(
        flex: 3,
        child: Container(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _nextOnPressd,
                    child: Text(
                      L10n.of(context)!.next,
                      style: Globals.buttonTextStyle,
                    ),
                    style: Globals.buttonStyle,
                  ),
                  Container()
                ])));
    Widget cancelAndSavebuttons = Expanded(
        flex: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Cancelボタン
            Container(
                width: 120,
                padding: const EdgeInsets.only(right: 5),
                child: ElevatedButton(
                  onPressed: _cancelOnPressd,
                  child: Text(L10n.of(context)!.cancel,
                      style: Globals.buttonTextStyle),
                  style: Globals.buttonStyle,
                )),
            // Saveボタン
            Container(
                width: 110,
                padding: const EdgeInsets.only(right: 5),
                child: ElevatedButton(
                  style: Globals.buttonStyle,
                  onPressed: _saveOnPressd,
                  child: Text(
                    L10n.of(context)!.save,
                    style: Globals.buttonTextStyle,
                  ),
                ))
          ],
        ));
    List<Widget> buttons = [];
    if (_isNew) buttons.add(nextButton);
    buttons.add(cancelAndSavebuttons);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: buttons,
    );
  }

  Container _buildTextFieldMicIcon(int index) {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: _buildMicIcon(index));
  }

  IconButton _buildMicIcon(int index,
      [double iconSize = 32, Color color = Colors.blue]) {
    return IconButton(
      onPressed: () async {
        int p = _textCtl[index].selection.start;
        String txt =
            await showSttDialog(context: context, localeId: _langIds[index]);
        setState(() {
          if (p >= 0) {
            _textCtl[index].text = _textCtl[index].text.substring(0, p) +
                txt +
                _textCtl[index].text.substring(p);
          } else {
            _textCtl[index].text += txt;
          }
        });
      },
      iconSize: iconSize,
      icon: const Icon(Icons.mic_rounded),
      color: color,
    );
  }

  Column _buildTextField(int index, String title, String hintText) {
    return Column(
      children: <Widget>[
        Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.fromLTRB(5, 5, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  title,
                  style: Globals.titleTextStyle,
                ),
                TextButton(
                  onPressed: () async {
                    String? key = await showSelectBottomSheet(
                        context: context, items: Globals().langItems);
                    if (key != null) {
                      setState(() {
                        _langIds[index] = key;
                      });
                    }
                  },
                  child: Text(
                    Globals().langItems[_langIds[index]] ?? '',
                  ),
                ),
              ],
            )),
        Container(
            margin: const EdgeInsets.fromLTRB(5, 0, 5, 20),
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            height: 150,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Expanded(
                  child: TextField(
                focusNode: index == 0 ? _textNode1 : _textNode2,
                controller: _textCtl[index],
                style: Globals.contentTextStyle,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  border: InputBorder.none,
                  hintText: hintText,
                ),
                maxLines: 100,
                autofocus: false,
                keyboardType: TextInputType.multiline,
              )),
              Container(
                  width: 35,
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.fromLTRB(0, 0, 5, 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildTextFieldMicIcon(index),
                      ]))
            ]))
      ],
    );
  }
}
