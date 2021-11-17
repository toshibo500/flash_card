import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flash_card/views/components/input_title_dialog.dart';

class CardListView extends StatefulWidget {
  const CardListView({Key? key, required this.viewModel, this.nextPage = ""})
      : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final viewModel;
  final String nextPage;
  @override
  _CardListView createState() => _CardListView();
}

class _CardListView extends State<CardListView> {
  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      buildDefaultDragHandles: false,
      children: <Widget>[
        for (int index = 0; index < widget.viewModel.items.length; index++)
          _buildListTileView(widget.viewModel.items[index].front,
              widget.viewModel.items[index].front, index)
      ],
      onReorder: (int oldIndex, int newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        widget.viewModel.reorder(oldIndex, newIndex);
      },
    );
  }

  Widget _buildListTileView(String front, String back, int index) {
    return Card(
      key: Key('$index'),
      child: FlipCard(
        direction: FlipDirection.VERTICAL,
        speed: 300,
        onFlipDone: (status) {
          print(status);
        },
        front: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF006666),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(front, style: Theme.of(context).textTheme.headline5),
              Text('Click here to flip back',
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
        back: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF006666),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(front, style: Theme.of(context).textTheme.headline5),
              Text('Click here to flip front',
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
      ),
    );
  }
}
