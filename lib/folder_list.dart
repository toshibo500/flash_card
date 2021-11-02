import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flash_card/components/input_title_dialog.dart';
import 'package:confirm_dialog/confirm_dialog.dart';

class FolderList extends StatefulWidget {
  const FolderList({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _FolderList createState() => _FolderList();
}

class _FolderList extends State<FolderList> {
  bool _editFlag = false;
  void _switchEditMode() {
    setState(() {
      _editFlag = !_editFlag;
    });
  }

  final List<String> folderList = ["テキスト１", "テキスト２", "テキスト３", "テキスト4"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => {},
        ),
        actions: [
          IconButton(
              icon: Icon(_editFlag ? Icons.done : Icons.edit_rounded),
              onPressed: () {
                _switchEditMode();
              }),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              String title = await showInputTitleDialog(context: context);
              if (title != "") {
                setState(() {
                  folderList.add(title);
                });
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: folderList.length,
        itemBuilder: (context, index) =>
            _buildListTileView(folderList[index], index),
      ),
    );
  }

  Widget _buildListTileView(String text, int index) {
    return Card(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          title: Text(text),
          subtitle: Text(index.toString()),
          trailing: Visibility(
            visible: _editFlag,
            child: Wrap(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    String title = await showInputTitleDialog(
                        context: context, title: text);
                    if (title != "") {
                      setState(() {
                        folderList[index] = title;
                      });
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    if (await confirm(context)) {
                      setState(() {
                        folderList.removeAt(index);
                        Fluttertoast.showToast(msg: "done!");
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }
}
