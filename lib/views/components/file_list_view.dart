import 'package:flash_card/viewmodels/book_viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flash_card/views/components/input_title_dialog.dart';
import 'package:flip_card/flip_card.dart';

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
      children: _buildListTileView(),
      onReorder: (int oldIndex, int newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        widget.viewModel.reorder(oldIndex, newIndex);
      },
    );
  }

  List<Widget> _buildListTileView() {
    List<Widget> tiles = [];
    for (int index = 0; index < widget.viewModel.items.length; index++) {
      if (widget.viewModel is BookViewModel) {
        tiles.add(_buildFlipCard(widget.viewModel.items[index].front,
            widget.viewModel.items[index].back, index));
      } else {
        tiles.add(_buildCard(widget.viewModel.items[index].title, index));
      }
    }
    return tiles;
  }

  Widget _buildFlipCard(String front, String back, int index) {
    return Card(
      key: Key('$index'),
      child: FlipCard(
        direction: FlipDirection.VERTICAL,
        speed: 300,
        onFlipDone: (status) {
          // print(status);
        },
        front: _buildFlipCardContent(front, index),
        back: _buildFlipCardContent(back, index),
      ),
    );
  }

  Container _buildFlipCardContent(String text, int index) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 5, 0, 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(text, style: Theme.of(context).textTheme.headline5),
          SizedBox(
            width: widget.viewModel.editMode ? 140 : 0,
            child: _buildIconButtons(text, index),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String text, int index) {
    return Card(
      key: Key('$index'),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[_buildListTile(text, index)]),
    );
  }

  Widget _buildListTile(String text, int index) {
    return ListTile(
      title: Text(text),
      subtitle: Text(index.toString()),
      enabled: !widget.viewModel.editMode,
      onTap: () {
        if (widget.nextPage != "") {
          Navigator.of(context).pushNamed(widget.nextPage,
              arguments: widget.viewModel.items[index]);
        }
      },
      trailing: _buildIconButtons(text, index),
    );
  }

  Visibility _buildIconButtons(String text, int index) {
    return Visibility(
      visible: widget.viewModel.editMode,
      child: Wrap(
        children: <Widget>[
          _editIconButton(text, index),
          _deleteIconButton(index),
          _dragIconButton(index),
        ],
      ),
    );
  }

  IconButton _editIconButton(String text, int index) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () async {
        String title =
            await showInputTitleDialog(context: context, title: text);
        if (title != "") {
          int seq = widget.viewModel.items[index].sequence;
          widget.viewModel.update(
            index: index,
            title: title,
            summary: '',
            sequence: seq,
          );
        }
      },
    );
  }

  IconButton _deleteIconButton(int index) {
    return IconButton(
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
    );
  }

  ReorderableDragStartListener _dragIconButton(int index) {
    return ReorderableDragStartListener(
      index: index,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: const Icon(Icons.drag_handle_rounded),
      ),
    );
  }
}
