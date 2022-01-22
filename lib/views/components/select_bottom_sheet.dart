import 'package:flutter/material.dart';
import 'package:bottom_sheet/bottom_sheet.dart';

Future showSelectBottomSheet(
    {required BuildContext context,
    required Map<dynamic, String> items,
    dynamic checkedItemKey = '',
    double initHeight = 0.5,
    double maxHeight = 0.9}) {
  List<Widget> _children = [];
  items.forEach((key, value) {
    _children.add(ListTile(
      title: Text(value),
      onTap: () => Navigator.of(context).pop(key),
      leading: Icon(key == checkedItemKey ? Icons.check_rounded : null),
    ));
  });

  return showStickyFlexibleBottomSheet<void>(
    minHeight: 0,
    initHeight: initHeight,
    maxHeight: maxHeight,
    headerHeight: 50,
    context: context,
    decoration: BoxDecoration(
      color: Theme.of(context).bottomAppBarColor,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      ),
    ),
    headerBuilder: (context, offset) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Theme.of(context).bottomAppBarColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(offset == 1.0 ? 0 : 10),
            topRight: Radius.circular(offset == 1.0 ? 0 : 10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded))),
            ),
          ],
        ),
      );
    },
    bodyBuilder: (context, offset) {
      return SliverChildListDelegate(
        _children,
      );
    },
    anchors: [.2, 0.5, .8],
  );
}
