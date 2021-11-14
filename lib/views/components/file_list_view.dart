import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flash_card/views/components/input_title_dialog.dart';

class FileListView extends StatefulWidget {
  const FileListView({Key? key, required this.viewModel, this.nextPage = ""})
      : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final viewModel;
  final String nextPage;
  @override
  _FileListView createState() => _FileListView();
}

class _FileListView extends State<FileListView> {
  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      buildDefaultDragHandles: false,
      children: <Widget>[
        for (int index = 0; index < widget.viewModel.items.length; index++)
          _buildListTileView(widget.viewModel.items[index].title, index)
      ],
      onReorder: (int oldIndex, int newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        widget.viewModel.reorder(oldIndex, newIndex);
      },
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
              enabled: !widget.viewModel.editMode,
              onTap: () {
                Navigator.of(context).pushNamed(widget.nextPage,
                    arguments: widget.viewModel.items[index]);
              },
              trailing: Visibility(
                visible: widget.viewModel.editMode,
                child: Wrap(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        String title = await showInputTitleDialog(
                            context: context, title: text);
                        if (title != "") {
                          int seq = widget.viewModel.items[index].sequence;
                          widget.viewModel.update(
                            index,
                            title,
                            '',
                            seq,
                          );
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
                          widget.viewModel.remove(index);
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
