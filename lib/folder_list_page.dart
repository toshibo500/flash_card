import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flash_card/components/input_title_dialog.dart';
import 'package:flash_card/models/folder_model.dart';
import 'package:flash_card/models/folder_list_model.dart';

class FolderListPage extends StatelessWidget {
  const FolderListPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        child: Scaffold(body: FolderListScreen(title: title)),
        create: (context) => FolderListModel());
  }
}

class FolderListScreen extends StatefulWidget {
  const FolderListScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _FolderListScreen createState() => _FolderListScreen();
}

class _FolderListScreen extends State<FolderListScreen> {
  bool _editFlag = false;
  void _switchEditMode() {
    setState(() {
      _editFlag = !_editFlag;
    });
  }

  List<FolderModel> _folderItems = [];

  @override
  Widget build(BuildContext context) {
    final _folderListModel = Provider.of<FolderListModel>(context);
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
                _folderListModel.add(title, '');
              }
            },
          ),
        ],
      ),
      body: Consumer<FolderListModel>(builder: (context, folderList, _) {
        _folderItems = folderList.items;
        return ReorderableListView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          buildDefaultDragHandles: false,
          children: <Widget>[
            for (int index = 0; index < _folderItems.length; index++)
              _buildListTileView(_folderItems[index].title, index)
          ],
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final item = _folderItems.removeAt(oldIndex);
              _folderItems.insert(newIndex, item);
              _folderListModel.items = _folderItems;
              _folderListModel.setFolders();
            });
          },
        );
      }),
    );
  }

  Widget _buildListTileView(String text, int index) {
    final _folderListModel = Provider.of<FolderListModel>(context);
    return Card(
        key: Key('$index'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(text),
              subtitle: Text(index.toString()),
              enabled: !_editFlag,
              onTap: () {
                Navigator.of(context).pushNamed("/folderPage",
                    arguments: _folderItems[index].title);
              },
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
                          _folderListModel.updateAt(index, title, '');
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        if (await confirm(
                          context,
                          title: const Text('Confirm'),
                          content: const Text('Would you like to remove?'),
                          textOK: const Text('Yes'),
                          textCancel: const Text('No'),
                        )) {
                          _folderListModel.removeAt(index);
                          Fluttertoast.showToast(msg: "done!");
                        }
                      },
                    ),
                    ReorderableDragStartListener(
                      index: index,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: const Icon(Icons.drag_handle_rounded),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
