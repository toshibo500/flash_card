import 'package:flash_card/models/card_model.dart';
import 'package:flash_card/viewmodels/book_viewmodel.dart';
import 'package:flash_card/viewmodels/folder_viewmodel.dart';
import 'package:flash_card/viewmodels/folder_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flash_card/views/components/input_title_dialog.dart';
import 'package:flip_card/flip_card.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flash_card/globals.dart';

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
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
              child: Column(
            children: [
              Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  height: widget.viewModel.editMode ? 80 : 70,
                  child: SingleChildScrollView(
                      child: Text(text,
                          style: Theme.of(context).textTheme.headline5,
                          overflow: TextOverflow.clip))),
              Visibility(
                  visible: !widget.viewModel.editMode,
                  child: SizedBox(
                    height: 15,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildHistoryBox(index),
/*                           Container(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                                onPressed: () {},
                                iconSize: 16,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                color: Theme.of(context)
                                    .disabledColor, // Globals.iconColor2,
                                icon: const Icon(Icons.mic_rounded)), 
                          ),*/
                        ]),
                  )),
            ],
          )),
          SizedBox(
            width: widget.viewModel.editMode ? 140 : 0,
            child: _buildIconButtons(index),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryBox(int index) {
    CardModel card = widget.viewModel.items[index];
    DateFormat outputFormat = DateFormat(L10n.of(context)!.dateTimeFormat);
    return Container(
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.bottomLeft,
        child: Row(
          children: <Widget>[
            const Icon(
              Icons.check_circle_rounded,
              color: Globals.iconColor2,
              size: 16.0,
            ),
            SizedBox(
              width: 30,
              child: Text(card.correctNum.toString()),
            ),
            const Icon(
              Icons.not_interested_outlined,
              color: Globals.iconColor3,
              size: 16.0,
            ),
            SizedBox(
              width: 30,
              child: Text(card.wrongNum.toString()),
            ),
            const Icon(
              Icons.access_time_rounded,
              color: Globals.iconColor1,
              size: 16.0,
            ),
            Text(card.quizedAt != null
                ? outputFormat.format(card.quizedAt as DateTime)
                : ""),
          ],
        ));
  }

  Widget _buildCard(String text, int index) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      key: Key('$index'),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[_buildListTile(index)]),
    );
  }

  Widget _buildListTile(int index) {
    var item = widget.viewModel.items[index];
    String text = item.title;
    Icon icon = Globals().folderIcon;

    List<Widget> subContents = [];
    if (widget.viewModel is FolderListViewModel) {
      icon = Globals().folderIcon;
      subContents.add(
          _buildSubContentIcons(Globals().bookIcon, item.books.length, index));
    } else if (widget.viewModel is FolderViewModel) {
      icon = Globals().bookIcon;
      subContents.add(
          _buildSubContentIcons(Globals().cardIcon, item.cards.length, index));
    }

    return ListTile(
      leading: icon,
      title: Container(
          height: widget.viewModel.editMode ? 60 : 40,
          alignment: Alignment.centerLeft,
          child: Text(text)),
      subtitle: Visibility(
        visible: !widget.viewModel.editMode,
        child: Container(
            height: 20,
            alignment: Alignment.bottomLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: subContents,
            )),
      ),
      enabled: !widget.viewModel.editMode,
      onTap: () {
        if (widget.nextPage != "") {
          Navigator.of(context)
              .pushNamed(widget.nextPage, arguments: item)
              .then((value) {
            // HOMEに戻った場合、再読み込みしてほしいが何故かされないので、明示的に読み込む。
            if (widget.nextPage == '/folderPage') {
              widget.viewModel.getAll();
            }
          });
        }
      },
      trailing: _buildIconButtons(index),
    );
  }

  Widget _buildSubContentIcons(Icon icon, int num, int index) {
    var item = widget.viewModel.items[index];
    DateFormat outputFormat = DateFormat(L10n.of(context)!.dateTimeFormat);

    var subContents = Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon.icon,
            size: 16,
            color: icon.color,
          ),
          SizedBox(
            width: 30,
            child: Text(
              num.toString(),
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color),
            ),
          ),
          const Icon(
            Icons.access_time_rounded,
            color: Globals.iconColor1,
            size: 16.0,
          ),
          Text(
            item.quizedAt != null
                ? outputFormat.format(item.quizedAt as DateTime)
                : "",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
          ),
        ],
      ),
    );

    return subContents;
  }

  Visibility _buildIconButtons(int index) {
    return Visibility(
      visible: widget.viewModel.editMode,
      child: Wrap(
        children: <Widget>[
          _editIconButton(index),
          _deleteIconButton(index),
          _dragIconButton(index),
        ],
      ),
    );
  }

  IconButton _editIconButton(int index) {
    if (widget.viewModel is BookViewModel) {
      return _editCardIconButton(index);
    } else {
      return _editTitleIconButton(index);
    }
  }

  IconButton _editTitleIconButton(int index) {
    String text = widget.viewModel.items[index].title;
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () async {
        String title = await showInputTitleDialog(
            context: context,
            dialogTitle: L10n.of(context)!.folderName,
            title: text);
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

  IconButton _editCardIconButton(int index) {
    CardModel card = widget.viewModel.items[index];
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () async {
        await Navigator.of(context).pushNamed('/inputCardPage', arguments: card)
            as bool;
        widget.viewModel.update(
          index: index,
          bookId: card.bookId,
          front: card.front,
          back: card.back,
          sequence: card.sequence,
        );
      },
    );
  }

  IconButton _deleteIconButton(int index) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () async {
        if (await confirm(
          context,
          title: null,
          content: Text(L10n.of(context)!.deleteConfirmation),
          textOK: Text(L10n.of(context)!.ok),
          textCancel: Text(L10n.of(context)!.cancel),
        )) {
          widget.viewModel.remove(index);
          Fluttertoast.showToast(msg: L10n.of(context)!.deleteDone);
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
