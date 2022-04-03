import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flash_card/models/folder_model.dart';
import 'package:flash_card/models/repositories/folder_repository.dart';
import 'package:flash_card/globals.dart';

class SelectFolderDialog extends StatefulWidget {
  const SelectFolderDialog(
      {Key? key,
      required this.parentFolderId,
      this.selectedFolderId = '',
      this.isParentSelectable = false,
      this.text = ''})
      : super(key: key);
  final String parentFolderId;
  final String? selectedFolderId;
  final bool isParentSelectable;
  final String text;
  @override
  _SelectFolderDialog createState() => _SelectFolderDialog();
}

class _SelectFolderDialog extends State<SelectFolderDialog> {
  String _selectedFolderId = '';

  @override
  void initState() {
    super.initState();
    _selectedFolderId = widget.selectedFolderId!;
    getFolders(widget.parentFolderId);
  }

  List<FolderModel> _folderList = [];
  void getFolders(String parentId) {
    // フォルダを取得
    FolderRepository().getByParentId(parentId).then((value) async {
      // 子供がいるか確認
      for (FolderModel item in value) {
        List<FolderModel> list =
            await FolderRepository().getByParentId(item.id);
        item.hasChild = list.isNotEmpty;
      }
      // 親がいる場合は戻るようのフォルダ作成
      FolderModel? parent;
      if (parentId != Globals.rootFolderId) {
        parent = await FolderRepository().getById(parentId);
        if (parent != null) {
          value = [
                FolderModel(
                    parent.parentId, parent.parentId, '..', '', 0, null, true)
              ] +
              value;
        }
      }
      setState(() {
        _folderList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        content: SizedBox(
          height: 450,
          width: 450,
          child: Column(
            children: [
              Visibility(
                visible: widget.text.isNotEmpty,
                child: Container(
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: Text(widget.text)),
              ),
              SingleChildScrollView(
                  child: SizedBox(
                height: widget.text.isNotEmpty ? 380 : 450,
                width: 450,
                child: ListView.builder(
                    itemCount: _folderList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildCard(_folderList[index], index);
                    }),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text(L10n.of(context)!.cancel),
            onPressed: () => Navigator.pop<String>(context, ''),
          ),
          TextButton(
              child: Text(L10n.of(context)!.ok),
              onPressed: _selectedFolderId.isEmpty
                  ? null
                  : () {
                      Navigator.pop<String>(context, _selectedFolderId);
                    }),
        ]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildCard(FolderModel item, int index) {
    return Card(
      key: Key('$index'),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[_buildListTile(item, index)]),
    );
  }

  Widget _buildListTile(FolderModel item, int index) {
    String text = item.title;
    Icon folderIcon = item.id == item.parentId
        // 戻る用のフォルダ
        ? const Icon(Icons.arrow_upward_rounded, color: Colors.grey)
        // フォルダアイコン
        : Globals().folderIcon;

    // 選択済みかどうか
    bool selected = item.id == _selectedFolderId;
    Icon selectedIcon = selected
        ? const Icon(
            Icons.check_rounded,
          ) // チェックアイコン
        : folderIcon;

    return SizedBox(
        height: 45,
        child: ListTile(
          dense: true,
          selected: false,
          title: Row(children: [
            Stack(
              children: [folderIcon, selectedIcon],
            ),
            const SizedBox(
              width: 10,
            ),
            Text(text)
          ]),
          onLongPress: () {
            if (item.hasChild!) {
              // 子供がいる場合はドリルダウン
              getFolders(item.id);
            }
          },
          onTap: () {
            setState(() {
              // 戻るアイコン押下
              if (item.id == item.parentId) {
                getFolders(item.id);
              } else if (widget.isParentSelectable &&
                  selected &&
                  item.hasChild!) {
                // 親フォルダも選択可能、すでに選択済み且つ子供がいる場合はドリルダウン
                getFolders(item.id);
              } else if (!widget.isParentSelectable && item.hasChild!) {
                // 親フォルダは選択不可、子供がいる場合はドリルダウン
                getFolders(item.id);
              } else {
                // いない場合は選択済に
                _selectedFolderId = item.id;
              }
            });
          },
        ));
  }
}

Future showSelectFolderDialog(
    {required BuildContext context,
    TransitionBuilder? builder,
    required String parentFolderId,
    String selectedFolderId = "",
    bool isParentSelectable = false,
    String text = ''}) {
  Widget dialog = SelectFolderDialog(
    parentFolderId: parentFolderId,
    selectedFolderId: selectedFolderId,
    isParentSelectable: isParentSelectable,
    text: text,
  );
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
  );
}
