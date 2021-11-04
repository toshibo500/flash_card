import 'package:flash_card/models/folder_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flash_card/components/input_title_dialog.dart';
import 'package:flash_card/models/folder_list_model.dart';

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

  List<FolderModel> _folderItems = [];

  // @override
  // void initState() {
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => FolderListModel(),
      child: Scaffold(
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
                    _folderItems.add(FolderModel(title, ''));
                  });
                }
              },
            ),
          ],
        ),
        body: Consumer<FolderListModel>(builder: (context, folder, _) {
          _folderItems = folder.items;
          return ReorderableListView(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
                final FolderModel item = _folderItems.removeAt(oldIndex);
                _folderItems.insert(newIndex, item);
              });
            },
          );
        }),
      ),
    );
  }

  Widget _buildListTileView(String text, int index) {
    return Card(
        key: Key('$index'),
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
                    ReorderableDragStartListener(
                      index: index,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: const Icon(Icons.drag_handle_rounded),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        String title = await showInputTitleDialog(
                            context: context, title: text);
                        if (title != "") {
                          setState(() {
                            _folderItems[index] = FolderModel(title, '');
                          });
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
                          setState(() {
                            _folderItems.removeAt(index);
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
